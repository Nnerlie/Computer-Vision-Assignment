classdef CompositeImage
    %COMPOSITEIMAGE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        target_image
        source_images
        tiles_x
        tiles_y
        cells
        source_images_cropped
        target_associations
        composite_image
    end
    
    methods
        function obj = CompositeImage(target_image, source_images, tiles_x, tiles_y)
            obj.target_image = imread(target_image);
            obj.source_images = source_images;
            obj.tiles_x = tiles_x;
            obj.tiles_y = tiles_y;
            obj.cells = obj.TileImage();
            [obj.source_images_cropped, obj.target_associations] = obj.CompareTiles();
            obj.composite_image = obj.BuildImage();
        end
    end
   
    methods(Access = private)
        function cells = TileImage(obj)
            % Get the image's dimensions
            [height, width, depth] = size(obj.target_image);
            
            % The size (px) of each whole row & column block within the image
            tile_width = floor(height / obj.tiles_x);
            tile_height = floor(width / obj.tiles_y);

            % the number of tiles 
            tile_width = [tile_width * ones(1, obj.tiles_x), rem(height, obj.tiles_x)];
            tile_height = [tile_height * ones(1, obj.tiles_y), rem(width, obj.tiles_y)];

            % convert to cells, last row & column will be uncomplete blocks
            % they are removed to crop the image
            cells = mat2cell(obj.target_image, tile_width, tile_height, depth);
            cells = cells(1:end-1,1:end-1);
        end
        
        function [source_images_cropped, target_associations] = CompareTiles(obj)
            [x, y, ~] = size(obj.cells{1,1});
           
            data = fopen(obj.source_images);
            line = fgetl(data);
            
            i = 1;
            while ischar(line)
                source_image = imread(line);
                if size(source_image, 3) == 3
                    source_image = CropImage(obj, source_image, [x, y]);
                    source_image = imgaussfilt(source_image,2);
                    source_images_cropped{i} = source_image;

                    hR = imhist(source_image(:,:,1));
                    hR = hR ./ sum(hR(:));
                    hG = imhist(source_image(:,:,2));
                    hG = hG ./ sum(hG(:));
                    hB = imhist(source_image(:,:,3));
                    hB = hB ./ sum(hB(:));
                    histograms{i} = [hR, hG, hB];
                end
                line = fgetl(data);
                i = i +1;
            end
            fclose(data);
                      
            for x = 1:obj.tiles_x
                for y = 1:obj.tiles_y
                    target_associations(x, y) = FindHistogramEuclidean(obj, histograms, cell2mat(obj.cells(x,y)), 256);
                end
            end
        end
        
        function composite_image = BuildImage(obj)
            for x = 1:obj.tiles_x
                for y = 1:obj.tiles_y
                    if(y == 1)
                        composite_row = cell2mat(obj.source_images_cropped(obj.target_associations(x, y)));
                    else
                        composite_row = cell2mat([composite_row obj.source_images_cropped(obj.target_associations(x, y))]);
                    end
                end
                rows{x} = composite_row;
            end

            for x = 1:obj.tiles_x
                if(x == 1)
                    composite_image = cell2mat(rows(x));
                else
                    composite_image = [composite_image; cell2mat(rows(x))];
                end
            end
            
            imshow(composite_image);
        end
        
        function imindex = FindHistogramChisquared(obj, hist_matrix, image, nobins)
    
            [redhist, greenhist, bluehist] = FindHistogram(obj, image, nobins);

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
        
        function imindex = FindHistogramEuclidean(obj, hist_matrix, image, nobins)

            [redhist, greenhist, bluehist] = FindHistogram(obj, image, nobins);

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
        
        function [redhist, greenhist, bluehist] = FindHistogram(obj, image, nobins)
            % Compute histogram of given image
            redhist = imhist(image(:,:,1), nobins);
            greenhist = imhist(image(:,:,2), nobins);
            bluehist = imhist(image(:,:,3), nobins);

            % Normalise the histograms
            redhist = redhist ./ sum(redhist(:));
            greenhist = greenhist ./ sum(greenhist(:));
            bluehist = bluehist ./ sum(bluehist(:));
        end
        
        function image = CropImage(obj, image, tileSize)
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
    end
end
