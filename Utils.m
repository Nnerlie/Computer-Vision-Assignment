classdef Utils
    %UTILS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods(Static)
        function [X, Y] = LoadImages(file_path)
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
    
end

