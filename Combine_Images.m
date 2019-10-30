function imagemat = Combine_Images(image1, image2, spacing)
	[h1, w1, l1] = size(image1);
	if l1 == 1, image1 = image1(:, :, [1 1 1]); end
	[h2, w2, l2] = size(image2);
	if l2 == 1, image2 = image2(:, :, [1 1 1]); end

	hh = h1 + spacing + h2;
	ww = max([w1, w2]);
	imagemat = uint8(ones(hh, ww, 3) * 255);

	imagemat = Embed_Image(imagemat, image1, [ww * .5, h1 * .5]);
	imagemat = Embed_Image(imagemat, image2, [ww * .5, h1 + spacing + h2 * .5]);
end