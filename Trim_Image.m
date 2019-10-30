function imagemat = Trim_Image(imagemat, padding)
	if size(imagemat, 3) == 3
		trim_map = rgb2gray(imagemat);
	else
		trim_map = imagemat;
	end

	[hh, ww] = size(trim_map);
	h_map = min(trim_map, [], 2) < 255;
	w_map = min(trim_map, [], 1) < 255;

	h_start = max(1,  find(h_map, 1, 'first') - padding);
	h_end   = min(hh, find(h_map, 1, 'last') + padding);
	w_start = max(1,  find(w_map, 1, 'first') - padding);
	w_end   = min(ww, find(w_map, 1, 'last') + padding);
	imagemat = imagemat(h_start:h_end, w_start:w_end, :);
end