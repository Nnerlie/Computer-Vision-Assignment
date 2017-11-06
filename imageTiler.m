tileSize = 800;

% Load the image and get its dimensions
image = imread('image.jpg');
[height, width, depth] = size(image);

% The number of whole row & column blocks within the image
rows = floor(height / tileSize);
columns = floor(width / tileSize);

% the width of each row & column respectively
rows = [tileSize * ones(1, rows), rem(height, tileSize)];
columns = [tileSize * ones(1, columns), rem(width, tileSize)];

% convert to cells, last row & column will be uncomplete blocks
% they are removed to crop the iamge
cells = mat2cell(image, rows, columns, depth);
cells = cells(1:end-1,1:end-1);

% display the tile at position 2 2
imshow(cells{2,2})
