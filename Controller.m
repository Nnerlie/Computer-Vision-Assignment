classdef Controller
    %MASTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods(Static)
        function image = CropImage(image, tileSize)
            imageSize = [size(image, 1), size(image, 2)];

            if (imageSize < tileSize)
                    image = imresize(image,max([imageSize(1)/tileSize(1), imageSize(2)/tileSize(2)]));
                    imageSize = [size(image,1), size(image, 2)];
            end

            if (imageSize > tileSize)
                    image = imresize(image, max([tileSize(1)/imageSize(1), tileSize(2)/imageSize(2)]));
                    imageSize = [size(image,1), size(image, 2)];
            end

            if (imageSize(1) > tileSize(1))
                    ymin = round((imageSize(1) - tileSize(1)) / 2) + 1;
                    image = imcrop(image, [1, ymin, tileSize(2)-1, tileSize(1)-1]);
            elseif (imageSize(2) > tileSize(2))
                    xmin = round((imageSize(2) - tileSize(2)) / 2) + 1;
                    image = imcrop(image, [xmin, 1, tileSize(2)-1, tileSize(1)-1]);
            end
        end
        
        function cells = TileImage(image, tiles_x, tiles_y)
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
        
        function imindex = FindHistogramChisquared(hist_matrix, image, nobins)

            [redhist, greenhist, bluehist] = FindHistogram(image, nobins)

            % Compute chi-squared distance between image histogram and all histograms in the matrix
            m = size(hist_matrix, 2);
            for j = 1 : m
                RGB_hist = cell2mat(hist_matrix(j));
                red_divide = redhist + RGB_hist(:,1);
                red_divide(red_divide == 0) = 1;
                green_divide = greenhist + RGB_hist(:,2);
                green_divide(green_divide == 0) = 1;
                blue_divide = bluehist + RGB_hist(:,3);
                blue_divide(blue_divide == 0) = 1;
                red_distances(:,j) = 0.5*sum(((redhist - RGB_hist(:,1)).^2)./red_divide);
                green_distances(:,j) = 0.5*sum(((greenhist - RGB_hist(:,2)).^2)./green_divide);
                blue_distances(:,j) = 0.5*sum(((bluehist - RGB_hist(:,3)).^2)./blue_divide);
            end

            % Sum up all the histogram columns (produces a vector of similarities)
            % Find the smallest distance
            % Return the index of that distance
            distances = red_distances + green_distances + blue_distances;
            [~, imindex] = min(distances);
        end
        
        function imindex = FindHistogramEuclidean(hist_matrix, image, nobins)

            [redhist, greenhist, bluehist] = FindHistogram(image, nobins)

            % Compute euclidean distance between image histogram and all histograms in the matrix
            m = size(hist_matrix, 2);
            for j = 1 : m
                RGB_hist = cell2mat(hist_matrix(j));
                red_distances(:,j) = sqrt(sum((redhist - RGB_hist(:,1)).^2));
                green_distances(:,j) = sqrt(sum((greenhist - RGB_hist(:,2)).^2));
                blue_distances(:,j) = sqrt(sum((bluehist - RGB_hist(:,3)).^2));
            end
            % Sum up all the histogram columns (produces a vector of similarities)
            % Find the smallest distance
            % Return the index of that distance
            distances = red_distances + green_distances + blue_distances;
            [~, imindex] = min(distances);
        end
        
        function [redhist, greenhist, bluehist] = FindHistogram(image, nobins)
            % Compute histogram of given image
            redhist = imhist(image(:,:,1), nobins);
            greenhist = imhist(image(:,:,2), nobins);
            bluehist = imhist(image(:,:,3), nobins);

            % Normalise the histograms
            redhist = redhist ./ sum(redhist(:));
            greenhist = greenhist ./ sum(greenhist(:));
            bluehist = bluehist ./ sum(bluehist(:));
        end
        
        function [X, Y] = LoadData(file_path)
            X = [];
            Y = [];

            data = fopen(file_path);
            line = fgetl(data);

            while ischar(line)
                Y = [Y; 'manmade'];
                [thresh_v, thresh_h] = GetThresholds(line);
                X = [X; thresh_v, thresh_h];
                line = fgetl(data);
            end
            fclose(data);
        end

        function [thres1, thres2] = GetThresholds(image_path)
                I = imread(image_path);
                I = rgb2gray(I);
                [~, thres1] = edge(I, 'Sobel', [], 'vertical');
                [~, thres2] = edge(I, 'Sobel', [], 'horizontal');
        end
    end
end

