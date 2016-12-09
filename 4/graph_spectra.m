k = 10;

E = csvread('./data/example1.dat');
col1 = E(:,1);
col2 = E(:,2);
matrix_size = max(max(col1,col2));

As = sparse(col1, col2, 1, matrix_size, matrix_size);
A = full(As);

D_inv = diag(1./sqrt(sum(A, 2)));
L = D_inv * A * D_inv;

[X,~] = eigs(L, k);
Y = normr(X);

c = kmeans(Y, k)