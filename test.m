image = imread('image.jpg');

% split the image into cells
cells = imageTiler(image, 100, 100);
[x, y, z] = size(cells{1,1});

% foreach image comparison
for i = 1:250
    I = imread(sprintf('./images/natural/sun_ (%d).jpg',i));
    I = cropImage(I, [x, y]);
    cropped{i} = I;
    
    hR = imhist(I(:,:,1));
    hR = hR ./ sum(hR(:));
    hG = imhist(I(:,:,2));
    hG = hG ./ sum(hG(:));
    hB = imhist(I(:,:,3));
    hB = hB ./ sum(hB(:));
    histograms{i} = [hR, hG, hB];
end

for i = 1:100
    for j = 1:100
        results(i, j) = findHistogramEuclidean(histograms, cell2mat(cells(i,j)), 256);
    end
end

for i = 1:100
    for j = 1:100
        if(j == 1)
            composite_row = cell2mat(cropped(results(i, j)));
        else
            composite_row = cell2mat([composite_row cropped(results(i, j))]);
        end
    end
    rows{i} = composite_row;
end

for i = 1:100
    if(i == 1)
        composite_image = cell2mat(rows(i));
    else
       	composite_image = [composite_image; cell2mat(rows(i))];
    end
end

imshow(composite_image);

