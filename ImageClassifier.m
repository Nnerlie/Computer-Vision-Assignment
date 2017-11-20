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
        
        function [predictions, scores, costs] = Evaluate(obj, X, Y)
            [predictions, scores, costs] = obj.Predict(X);
            hit = false(size(Y, 1), 1);
            for pos = 1:size(predictions)
                if (predictions(pos,:) == Y(pos,:))
                    hit(pos,:) = true;
                end
            end
            correct = 0;
            for pos = 1:size(hit)
                if(hit(pos,:))
                    correct = correct + 1;
                end
            end
            percent = correct / size(hit, 1) * 100
            correct
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
                features = ImageClassifier.GetFeatures(image);
                X = [X; features];
                line = fgetl(data);
            end
            fclose(data);
        end
    end
    
    methods(Static, Access = private)
		function features = GetFeatures(image)
				features = ClaculateThresholds(image);
				features = [features, CalculateNumberOfLines(image)];
		end

       function [sobel_v, sobel_h] = CalculateThresholds(image)
                image = rgb2gray(image);
                
                [~, sobel_v] = edge(image, 'Sobel', [], 'vertical');
                [~, sobel_h] = edge(image, 'Sobel', [], 'horizontal');
        end 

		function lines = CalculateNumberOfLines(image)
				image = rgb2gray(image);
                [h, ~, ~] = size(image);

                edges = edge(image,'canny');
                
                [H,theta,rho] = hough(edges);
                peaks  = houghpeaks(H,1000,'threshold',ceil(0.4*max(H(:))));
                lines = houghlines(edges, theta, rho, peaks,'FillGap',1,'MinLength',h/20);
				lines = size(lines, 2);
		end
    end
    
end


