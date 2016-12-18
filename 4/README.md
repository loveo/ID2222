# Spectral Graph Analysis

The goal was to implement the K-eigenvector algorithm and use it in order to analyze two given graphs.

## Implementations

The algorithm was implmented in MATLAB since it is desgined to work with matrices and its mathematical operations:
```matlab
k = 4;
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

c = kmeans(Y, k);
```

The cluster vector **c** and eigenvectors **X** could then be plotted and analyzed graphically by altering **k**, the amount of clusters.
The algorithm uses k-means to cluster the different nodes which makes it a somewhat best-effort algorithm since different setups in k-means gives different clusters.

## Graph 1

The first graph has four clear components but it is hard to say wether it has five or four communities. When using four clusters, the naivness of k-means is shown by splitting a cluster into two communites. This effected is mitigated when using five clusters which suggests that the graph actually has five communities.

### With 4 clusters
![graph](https://github.com/loveo/ID2222/blob/master/4/graphs/graph_1_k_4_spectral.png)
![fiedler](https://github.com/loveo/ID2222/blob/master/4/graphs/graph_1_k_4_fiedler.png)

### With 5 clusters
![graph](https://github.com/loveo/ID2222/blob/master/4/graphs/graph_1_k_5_spectral.png)
![fiedler](https://github.com/loveo/ID2222/blob/master/4/graphs/graph_1_k_5_fiedler.png)

## Graph 2

The second graph has two clear communities which can be seen when plotting the graph. By looking at the fiedler vectors it is very obvious that these communities are tied together tightly and that it is hard to seperate them with few cuts.

### With 2 clusters
![graph](https://github.com/loveo/ID2222/blob/master/4/graphs/graph_2_k_2_spectral.png)
![fiedler](https://github.com/loveo/ID2222/blob/master/4/graphs/graph_2_k_2_fiedler.png)
