k = 4;

E = csvread('./data/example1.dat');


col1 = E(:,1);
col2 = E(:,2);
matrix_size = max(max(col1,col2));

As = sparse(col1, col2, 1, matrix_size, matrix_size);
A = full(As);
G = graph(A,'OmitSelfLoops');
H = plot(G,'-or');
D_inv = diag(1./sqrt(sum(A, 2)));
L = D_inv * A * D_inv;

[X,~] = eigs(L, k);
Y = normr(X);

c = kmeans(Y, k);



K = zeros(k,matrix_size);
%for i=1:k
 %   K = [K, {0}];
    
%end
%K = reshape(K,k,0);



for n = 1:length(c)
    clusterIndex = c(n);
    %K(clusterIndex) = [K(clusterIndex) n];
    for m = 1:241
        if K(clusterIndex, m) == 0
            K(clusterIndex,m) = n;
            break;
        end
    end
    
    %[K(clusterIndex) n]; 
end
J = K(1,:);
J = J(J~=0);
highlight(H,J, 'NodeColor', 'g');

J = K(2,:);
J = J(J~=0);
highlight(H,J, 'NodeColor', 'y');

J = K(3,:);
J = J(J~=0);
highlight(H,J, 'NodeColor', 'b');

J = K(4,:);
J = J(J~=0);
highlight(H,J, 'NodeColor', 'c');



%A(A~=0)

