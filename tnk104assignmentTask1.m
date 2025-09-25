clc
clear

project_sorting('network_data.txt');

function project_sorting(filename)

    % Open and read the file
    fileID = fopen(filename, 'r');
    if fileID == -1
        error('Cannot open file: %s', filename);
    end

    % Read number of arcs
    num_arcs = fscanf(fileID, '%d', 1);

    % Read arc pairs
    arcs = fscanf(fileID, '%d %d', [2, num_arcs])';
    fclose(fileID);

    % Extract all unique node labels
    nodes = unique(arcs(:));
    n = length(nodes);

    % Create adjacency matrix and in-degree array
    adj = zeros(n); 
    in_degree = zeros(1, n);

    % Map node numbers to indices in adjacency matrix,
    % since the numbering of nodes aren't consecutive
    node_idx = containers.Map(nodes, 1:n);
    
    % Fills the adjacency matrix and counts how many prerequisites each subtask has
    for k = 1:size(arcs,1)
        from = arcs(k,1);
        to = arcs(k,2);
        i = node_idx(from);
        j = node_idx(to);
        adj(i,j) = 1;
        in_degree(j) = in_degree(j) + 1;
    end
    
    % Initialize queue with nodes having zero in-degree
    queue = find(in_degree == 0);
    ordering = [];
    
    while ~isempty(queue)
        current = queue(1);               % Take the first node from the queue
        queue(1) = [];                    % Remove it from the queue
        ordering(end+1) = nodes(current); % Add it to the execution order
        
        % Decrease in-degree of neighbors
        neighbors = find(adj(current,:) == 1);                     % Find all subtasks depending on current
        for k = 1:length(neighbors)
            in_degree(neighbors(k)) = in_degree(neighbors(k)) - 1; % One prerequisite completed
            if in_degree(neighbors(k)) == 0                        % If all prerequisites are done
                queue(end+1) = neighbors(k);                       % Add the neighbor to the queue
            end
        end
    end

    % Check if a valid ordering exists
    if length(ordering) ~= n
        fprintf('Error! The project network has a cycle, no valid ordering exists.\n');
    else
    % Print order of subtasks
    fprintf('One possible ordering of subtasks: ');
    fprintf('%d ', ordering);
    fprintf('\n');

    % Create a directed graph (convert arcs to strings so node names are correct)
    G = digraph(string(arcs(:,1)), string(arcs(:,2)));
    
    % Plot
    figure;
    h = plot(G, 'Layout', 'layered', 'ArrowSize', 8, 'NodeFontSize', 12, 'LineWidth', 1.2);
    labelnode(h, 1:numnodes(G), G.Nodes.Name);
    title('Project Network (subtasks and precedence)');

    end
    
end
