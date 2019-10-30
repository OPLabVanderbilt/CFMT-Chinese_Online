function imwrite_gray(imagemat, path)
	test_gray = std(double(imagemat), [], 3);
	if mean(test_gray(:)) == 0
		imagemat = imagemat(:, :, 1);
	end
	imwrite(imagemat, path);
end