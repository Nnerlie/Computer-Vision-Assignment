% findHistogramChisquared finds the most matching histogram using chi-squared distance
% 
% Parameters
%	hist_matrix:	Matrix of histograms to compare 
%	image:			Image to find a matching histogram for 
%
% Returns
%	imindex:		The index of the most matching histogram in hist_matrix
%%%

function imindex = findHistogramChisquared(hist_matrix, image)

% Compute histogram of given image
% Compute chi-squared distance between image histogram and all histograms in the matrix
% Sum up all the histogram columns (produces a vector of similarities)
% Find the smallest distance
% Return the index of that distance
