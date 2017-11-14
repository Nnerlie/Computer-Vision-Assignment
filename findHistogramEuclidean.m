% findHistogramEuclidean finds the most matching histogram using euclidean distance
% 
% Parameters
%	hist_matrix:	Matrix of histograms to compare, all color channels separate
%	imlocation:		Location of the image to find a matching histogram for 
%	nobins:			Number of bins in a histogram
%
% Returns
%	imindex:		The index of the most matching histogram in hist_matrix
%%%

function imindex = findHistogramEuclidean(hist_matrix, image, nobins)

% Compute histogram of given image
redhist = imhist(image(:,:,1), nobins);
greenhist = imhist(image(:,:,2), nobins);
bluehist = imhist(image(:,:,3), nobins);

% Normalise the histograms
redhist = redhist ./ sum(redhist(:));
greenhist = greenhist ./ sum(greenhist(:));
bluehist = bluehist ./ sum(bluehist(:));

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
[value, imindex] = min(distances);
