function [features, labels] = trainkNN(manmadefile, naturefile)
	features = [];
	labels = [];

	manmade = fopen(manmadefile);
	line = fgetl(manmade);
    
	while ischar(line)
		labels = [labels; 'manmade'];
		[thresh_v, thresh_h] = getThresholds(line);
		features = [features; thresh_v, thresh_h];
		line = fgetl(manmade);
	end
	fclose(manmade);

	nature = fopen(naturefile);
	line = fgetl(nature);
	while ischar(line)
		labels = [labels; 'natural'];
		[thresh_v, thresh_h] = getThresholds(line);
		features = [features; thresh_v, thresh_h];
		line = fgetl(nature);
	end
	fclose(nature);
end

function [thres1, thres2] = getThresholds(image_location)
		I = imread(image_location);
		I = rgb2gray(I);
		[v, thres1] = edge(I, 'Sobel', [], 'vertical');
		[h, thres2] = edge(I, 'Sobel', [], 'horizontal');
end
