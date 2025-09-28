clc
clear

[minCost, path] = lot_sizing_shortest_path_file('lotsizeb.txt');

disp('Minimal cost:');
disp(minCost);
disp('Shortest path arcs (i -> j):');
disp(path);

function [minCost, path] = lot_sizing_shortest_path_file(filename)

% === Step 1: Read data from file ===
    opts = detectImportOptions(filename,'NumHeaderLines',0);
    opts.DataLines = [2 Inf];  % read lines 2 to end
    data = readmatrix(filename, opts);
    
    fid = fopen(filename,'r');
    n = fscanf(fid, '%d',1);
    fclose(fid);
    
    d = data(:,1);
    f = data(:,2);
    p = data(:,3);
    h = data(:,4);

 % === Step 2: Compute cumulative demand and c[i] ===
    dCum = zeros(n, n);
    c = zeros(1, n);
    for i = 1:n
        for j = i:n
            dCum(i,j) = sum(d(i:j));
        end
        c(i) = p(i) + sum(h(i:n));
    end

    % === Step 3: Compute arc costs ===
    arcCost = inf(n+1, n+1);
    for i = 0:(n-1)
        for j = (i+1):n
            arcCost(i+1,j+1) = f(i+1) + c(i+1) * dCum(i+1,j);
        end
    end

    % === Step 4: Compute K ===
    K = 0;
    for i = 1:n
        K = K + h(i) * dCum(1,i);
    end

    % === Step 5: Shortest path ===
    dist = inf(1, n+1);
    pred = zeros(1, n+1);
    dist(1) = 0; 

    for i = 0:(n-1)
        for j = (i+1):n
            if dist(j+1) > dist(i+1) + arcCost(i+1,j+1)
                dist(j+1) = dist(i+1) + arcCost(i+1,j+1);
                pred(j+1) = i;
            end
        end
    end

    % --- Step 6: Reconstruct path ---
    path = [];
    current = n;
    while current > 0
        prev = pred(current+1);
        path = [[prev, current]; path];
        current = prev;
    end

    % --- Step 6: Compute minimal cost corrected by K ---
    minCost = dist(n+1) - K;
end