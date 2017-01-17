k = 4;

%E = csvread('./data/example1.dat');
E= csvread('D:/Workspace/Github/ID2222/4/data/example1.dat');


col1 = E(:,1);
col2 = E(:,2);
matrix_size = max(max(col1,col2));

As = sparse(col1, col2, 1, matrix_size, matrix_size);
A = full(As);

D_inv = diag(1./sqrt(sum(A, 2)));
L = D_inv * A * D_inv;

[X,~] = eigs(L, k);
Y = normr(X);

c = kmeans(Y, k);


% Plotting

G = graph(A,'OmitSelfLoops');
figure(1);
H = plot(G,':ok');

% Place nodes in clusters

K = zeros(k,matrix_size);

for n = 1:length(c)
    clusterIndex = c(n);

    for m = 1:241
        if K(clusterIndex, m) == 0
            K(clusterIndex,m) = n;
            break;
        end
    end
end

% Highlight nodes
colors = ['g', 'b', 'y', 'c', 'm', 'k'];

for n = 1:k
   J = K(n,:);
   J = J(J~=0);
   highlight(H, J, 'NodeColor', colors(n));
end

% Fiedler plot

figure(2);
plot(X);
title('Fiedler');
