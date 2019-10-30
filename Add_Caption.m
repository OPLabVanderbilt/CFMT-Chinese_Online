function imagemat = Add_Caption(imagemat, caption_pic)
	caption_padding = 15;
	caption_spacing = 15;
	image_min_width = 240;


	[hh, ww, ll] = size(imagemat);
	if ll == 1, imagemat = imagemat(:, :, [1 1 1]); end
	if ww < image_min_width
		newmat = uint8(ones(hh, image_min_width, 3) * 255);
		newmat(:, round((image_min_width - ww) * .5) + (1:ww), :) = imagemat;
		imagemat = newmat;
	end

	if exist('caption_pic', 'var') && ~isempty(caption_pic)
		caption_image = imread(caption_pic);
		caption_image = Trim_Image(caption_image, caption_padding);
		imagemat = Combine_Images(caption_image, imagemat, caption_spacing);
	end
end

