% findHistogramChisquared finds the most matching histogram using chi-squared distance
% 
% Parameters
%	hist_matrix:	Matrix of histograms to compare, all color channels separate
%	imlocation:		Location of the image to find a matching histogram for 
%	nobins:			Number of bins in a histogram
%
% Returns
%	imindex:		The index of the most matching histogram in hist_matrix
%%%

function imindex = findHistogramChisquared(hist_matrix, I, nobins)

% Compute histogram of given image
% I = imread(imlocation);
redhist = imhist(I(:,:,1), nobins);
greenhist = imhist(I(:,:,2), nobins);
bluehist = imhist(I(:,:,3), nobins);

% Normalise the histograms
redhist = redhist ./ sum(redhist(:));
greenhist = greenhist ./ sum(greenhist(:));
bluehist = bluehist ./ sum(bluehist(:));

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
[value, imindex] = min(distances);

%% Try converting to HSV??
