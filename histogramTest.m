
for i = 1:20
	I = imread(sprintf('./Wallpapers/im%d.JPG',i));
	hR = imhist(I(:,:,1));
	hR = hR ./ sum(hR(:));
	hG = imhist(I(:,:,2));
	hG = hG ./ sum(hG(:));
	hB = imhist(I(:,:,3));
	hB = hB ./ sum(hB(:));
	histograms{i} = [hR, hG, hB];
end

findHistogramEuclidean(histograms, './Wallpapers/club.JPG', 256)

