function image1 = Embed_Image(image1, image2, cxcy)
	if size(image1, 3) == 1, image1 = image1(:, :, [1 1 1]); end
	[h2, w2, l2] = size(image2);
	if l2 == 1, image2 = image2(:, :, [1 1 1]); end

	widx = round(cxcy(1) - (w2 * .5) + (1:w2));
	hidx = round(cxcy(2) - (h2 * .5) + (1:h2));

	image1(hidx, widx, :) = image2;
end