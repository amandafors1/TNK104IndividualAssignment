clc
clear

[assignment1, total_cost1] = greedy_gap('GAPinstance1.txt');
disp('Assignment for instance 1: '); disp(assignment1);
disp('Total cost for instance 1: '); disp(total_cost1);
[assignment2, total_cost2] = greedy_gap('GAPinstance2.txt');
disp('Assignment for instance 2: '); disp(assignment2);
disp('Total cost for instance 2: '); disp(total_cost2);


function [assignment, total_cost] = greedy_gap(filename)

fid = fopen(filename, 'r');
    if fid == -1
        error(['Cannot open file: ' filename]);
    end
    
    % Read m and n
    line = fgetl(fid);
    nums = sscanf(line, '%d');
    m = nums(1); n = nums(2);
    
    % Read cost matrix
    cost = zeros(m, n);
    for i = 1:m
        line = fgetl(fid);
        cost(i,:) = sscanf(line, '%d')';
    end
    
    % Read requirement matrix
    req = zeros(m, n);
    for i = 1:m
        line = fgetl(fid);
        req(i,:) = sscanf(line, '%d')';
    end
    
    % Read capacities
    line = fgetl(fid);
    cap = sscanf(line, '%d')';
    
    fclose(fid);

    remaining = cap;               % Remaining capacities
    assignment = -ones(1, n);      % Assignment of jobs to machines
    total_cost = 0;

    for j = 1:n
        % Sort machines by increasing cost for job j
        [~, idx] = sort(cost(:, j));
        assigned = false;
        for k = 1:m
            i = idx(k); % Machine candidate
            if req(i, j) <= remaining(i)
                assignment(j) = i;
                remaining(i) = remaining(i) - req(i, j);
                total_cost = total_cost + cost(i, j);
                assigned = true;
                break;
            end
        end
        if ~assigned
            error(['Job ' num2str(j) ' could not be assigned.']);
        end
    end
end
