function cells = imageTiler(image, tiles_x, tiles_y)
    % Get the image's dimensions
    [height, width, depth] = size(image);

    % The size (px) of each whole row & column block within the image
    tile_width = floor(height / tiles_x);
    tile_height = floor(width / tiles_y);

    % the number of tiles 
    tile_width = [tile_width * ones(1, tiles_x), rem(height, tiles_x)];
    tile_height = [tile_height * ones(1, tiles_y), rem(width, tiles_y)];

    % convert to cells, last row & column will be uncomplete blocks
    % they are removed to crop the image
    cells = mat2cell(image, tile_width, tile_height, depth);
    cells = cells(1:end-1,1:end-1);

    % display the tile at position 2 2
    imshow(cells{2,2})
end
