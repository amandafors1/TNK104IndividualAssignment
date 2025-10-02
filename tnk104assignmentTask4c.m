clc
clear

[best_assign1, best_cost1] = exhaustive_gap('GAPinstance1.txt');
disp('Best assignment for instance 1: '); disp(best_assign1);
disp('Best total cost for instance 1: '); disp(best_cost1);
[best_assign2, best_cost2] = exhaustive_gap('GAPinstance2.txt');
disp('Best assignment for instance 2: '); disp(best_assign2);
disp('Best total cost for instance 2: '); disp(best_cost2);

function [best_assign, best_cost] = exhaustive_gap(filename)
    
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

    best_cost = inf;
    best_assign = [];
    
    % Generate all possible assignments (243x5 matrix)
    grids = cell(1, n);
    [grids{:}] = ndgrid(1:m);
    assignments = zeros(m^n, n); 
    for j = 1:n
        assignments(:, j) = grids{j}(:);
    end
    
    % Loop through all possible assignments
    for a = 1:size(assignments,1)
        assignment = assignments(a,:);
        remaining = cap;
        total = 0;
        feasible = true;
        for j = 1:n
            i = assignment(j);
            if req(i,j) <= remaining(i)
                remaining(i) = remaining(i) - req(i,j);
                total = total + cost(i,j);
            else
                feasible = false;
                break;
            end
        end
        % If lower cost than previously found, 
        % set to best assignment and cost
        if feasible && total < best_cost
            best_cost = total;
            best_assign = assignment;
        end

    end
end