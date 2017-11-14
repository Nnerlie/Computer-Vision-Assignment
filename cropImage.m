function image = cropImage(I, tileSize)
	imageSize = [size(I, 1), size(I, 2)];

	if (imageSize < tileSize)
			I = imresize(I,max([imageSize(1)/tileSize(1), imageSize(2)/tileSize(2)]));
			imageSize = [size(I,1), size(I, 2)];
	end

	if (imageSize > tileSize)
			I = imresize(I, max([tileSize(1)/imageSize(1), tileSize(2)/imageSize(2)]));
			imageSize = [size(I,1), size(I, 2)];
	end

	if (imageSize(1) > tileSize(1))
			ymin = round((imageSize(1) - tileSize(1)) / 2) + 1;
			image = imcrop(I, [1, ymin, tileSize(2)-1, tileSize(1)-1]);
	elseif (imageSize(2) > tileSize(2))
			xmin = round((imageSize(2) - tileSize(2)) / 2) + 1;
			image = imcrop(I, [xmin, 1, tileSize(2)-1, tileSize(1)-1]);
	else
			image = I;
    end
end
