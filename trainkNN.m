function [features, labels] = trainkNN(manmadefile, naturefile)
	features = [];
	labels = [];

	manmade = fopen(manmadefile);
	line = fgetl(manmade);
	i = 1;
	while ischar(line)
		labels = [labels; 'manmade'];
		[thresh_v, thresh_h] = getThresholds(line)
		features = [features; thresh_v, thresh_h];
		line = fgetl(manmade);
		i++;
	end
	fclose(manmade);

	i = 1;
	nature = fopen(naturefile);
	line = fgetl(nature);
	while ischar(line)
		labels = [labels; 'nature'];
		[thresh_v, thresh_h] = getThresholds(line)
		features = [features; thresh_v, thresh_h];
		line = fgetl(nature);
		i++;
	end
	fclose(nature);
	features
	labels
end

function [thres1, thres2] = getThresholds(image_location)
		I = imread(image_location);
		I = rgb2gray(I);
		[v, thres1] = edge(I, 'Sobel', [], 'vertical');
		[h, thres2] = edge(I, 'Sobel', [], 'horizontal');
end
