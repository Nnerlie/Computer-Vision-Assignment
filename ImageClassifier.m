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
        
        function [percent, correct, total] = Evaluate(obj, X, Y)
            [labels, ~, ~] = obj.Predict(X);
            total = size(Y, 1);
            hits = false(total, 1);
            for pos = 1:size(labels)
                if (labels(pos,:) == Y(pos,:))
                    hits(pos,:) = true;
                end
            end
            correct = 0;
            for pos = 1:size(hits)
                if(hits(pos,:))
                    correct = correct + 1;
                end
            end
            percent = correct / size(X,1) * 100;
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
                fprintf("Loading image '%s'\n", line);
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
% 				features = ImageClassifier.CalculateThresholds(image);
 				features = [ImageClassifier.CalculateNumberOfLines(image)];
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

		function WriteTrainedDataToFile(class_name, features)
				fileID = fopen(strcat(class_name, '_trained_data.txt'), 'w');
				for n = 1:size(features, 1)
						feature_string = sprintf('%d', features(n, :));
						fprintf(fileID, '%d\n', feature_string);
				end
				fclose(fileID);
		end

		function features = ReadTrainedDataFromFile(class_name)
				fileID = fopen(strcat(class_name, '_trained_data.txt'));
				line = fgetl(fileID);
				features = line;
				while ischar(line)
						line = fgetl(fileID);
						features = [features; line];
				end
		end
    end
end
