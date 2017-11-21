classdef ImageClassifier
    %IMAGECLASSIFIER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        k
        model
        X_train
        Y_train
    end
    
    methods        
        function obj = ImageClassifier(X, Y, k)
            obj.X_train = X;
            obj.Y_train = Y;
            obj.k = k;
        end
        
        function obj = Train(obj)
            obj.model = fitcknn(obj.X_train, obj.Y_train,'NumNeighbors', obj.k);
        end
        
        function [labels, scores, costs] = Predict(obj, X)
            [labels, scores, costs] = predict(obj.model, X);
        end
        
        function results = Evaluate(obj, X, Y)
            
        end
    end
    
    methods(Static)
        function [X, Y] = LoadData(file_path)
            X = [];
            Y = [];
            
            [~,name,~] = fileparts(file_path);
            class = strsplit(name,'_');

            data = fopen(file_path);
            line = fgetl(data);
            
            while ischar(line)
                Y = [Y; class{1}];
                image = imread(line);
                thresholds = ImageClassifier.CalculateThresholds(image);
                X = [X; thresholds];
                line = fgetl(data);
            end
            fclose(data);
        end
    end
    
    methods(Static, Access = private)
       function [sobel_v, sobel_h, canny_b] = CalculateThresholds(image)
                image = rgb2gray(image);
                [~, sobel_v] = edge(image, 'Sobel', [], 'vertical');
                [~, sobel_h] = edge(image, 'Sobel', [], 'horizontal');
                [~, canny_b] = edge(image, 'Canny', [], 'both');
                
        end 
    end
    
end

