% 179
I = rgb2gray(imread('images/natural/image_ (179).jpg'));

[h, thresh_h] = edge(I, 'Sobel', [], 'horizontal');
[v, thresh_v] = edge(I, 'Sobel', [], 'vertical');

imshowpair(h, v);
thresh_v
thresh_h

load fisheriris
X = meas;
Y = species;
rng(10); % For reproducibility
Mdl = fitcknn(X,Y,'NumNeighbors',4);
