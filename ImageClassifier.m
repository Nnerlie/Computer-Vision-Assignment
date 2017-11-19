classdef ImageClassifier
    %IMAGECLASSIFIER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function [X, Y] = LoadData(obj, file_path)
            X = [];
            Y = [];

            data = fopen(file_path);
            line = fgetl(data);
            
            while ischar(line)
                Y = [Y; 'manmade'];
                [thresh_v, thresh_h] = getThresholds(line)
                X = [X; thresh_v, thresh_h];
                line = fgetl(data);
            end
            fclose(data);
        end

        function [thres1, thres2] = getThresholds(obj, image)
                image = rgb2gray(image);
                [v, thres1] = edge(image, 'Sobel', [], 'vertical');
                [h, thres2] = edge(image, 'Sobel', [], 'horizontal');
        end

    end
    
end

