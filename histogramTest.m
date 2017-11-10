
for i = 1:250
	I = imread(sprintf('./images/natural/sun_ (%d).jpg',i));
	hR = imhist(I(:,:,1));
	hR = hR ./ sum(hR(:));
	hG = imhist(I(:,:,2));
	hG = hG ./ sum(hG(:));
	hB = imhist(I(:,:,3));
	hB = hB ./ sum(hB(:));
	histograms{i} = [hR, hG, hB];
end

findHistogramEuclidean(histograms, './images/natural/sun_ (48).jpg', 256)

