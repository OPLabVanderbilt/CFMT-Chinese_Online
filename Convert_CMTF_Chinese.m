output_dir = 'CMTF-Chinese-online/';
input_dir  = 'CMTF-Chinese-MATLAB/';
image_dirs = {
	strcat(input_dir, 'Practice/');
	strcat(input_dir, 'SingleFace/');
	strcat(input_dir, 'Learning/');
	strcat(input_dir, 'NoNoise/');
	strcat(input_dir, 'Noise/');
	};
caption_dir = 'CMTF-text/';

% test/trial info
test_info = load(strcat(input_dir, 'TarPosn.mat'));
test_info.TarPosnPractice = [1, 2, 2]';
trial_info = load('TrialQueues.mat');


CMTF_isi    = 500;
CMTF_width1 = 576;
CMTF_width2 = 192;


if ~exist(output_dir, 'dir')
	mkdir(output_dir);
end
trial_num = 0;


% title page
trial_num = trial_num + 1;
imagemat = imread(fullfile(caption_dir, 'titlepage.jpg'));
filename = sprintf('trial-%03d_limit-5000_isi-%d.png', trial_num, CMTF_isi);
imwrite_gray(imagemat, fullfile(output_dir, filename));


% practice instruction
trial_num = trial_num + 1;
imagemat = imread(fullfile(caption_dir, 'inst_practice1.jpg'));
filename = sprintf('trial-%03d_clickable-true_isi-%d.png', trial_num, CMTF_isi);
imwrite_gray(imagemat, fullfile(output_dir, filename));

% practice memorize
for i = 1:3
	trial_num = trial_num + 1;
	stim_file = dir(fullfile(image_dirs{1}, sprintf('bart_%d*.jpg', i)));
	imagemat = imread(fullfile(image_dirs{1}, stim_file.name));
	imagemat = Add_Caption(imagemat, fullfile(caption_dir, 'textP.jpg'));
	filename = sprintf('trial-%03d_limit-3000_isi-%d.png', trial_num, CMTF_isi);
	imwrite_gray(imagemat, fullfile(output_dir, filename));
end
% practice test
for i = 1:3
	trial_num = trial_num + 1;
	stim_file = dir(fullfile(image_dirs{1}, sprintf('pract_%d*.jpg', i)));
	imagemat = imread(fullfile(image_dirs{1}, stim_file.name));
	imagemat = imagemat(:, 65 + (1:620), :);  % crop width from 750px to 620px
	imagemat = imresize(imagemat, CMTF_width1 / 620);
	imagemat = Add_Caption(imagemat, fullfile(caption_dir, 'inst_practice2.jpg'));
	filename = sprintf('trial-%03d_clickable-true_sections-3_correct-%d_isi-%d.png', ...
			trial_num, test_info.TarPosnPractice(i), CMTF_isi);
	imwrite_gray(imagemat, fullfile(output_dir, filename));
end


% learning 6 target faces
bn = 0;
for f = 1:6
	% learning instruction
	trial_num = trial_num + 1;
	if f == 1
		imagemat = imread(fullfile(caption_dir, 'inst_memorize1.jpg'));
	else
		imagemat = imread(fullfile(caption_dir, 'inst_memorize2.jpg'));
	end
	filename = sprintf('trial-%03d_clickable-true_isi-%d.png', trial_num, CMTF_isi);
	imwrite_gray(imagemat, fullfile(output_dir, filename));

	% learning memorize
	for i = 1:3
		trial_num = trial_num + 1;
		stim_file = dir(fullfile(image_dirs{2}, sprintf('%02d.*_%d*.jpg', f, i)));
		imagemat = imread(fullfile(image_dirs{2}, stim_file.name));
		imagemat = imresize(imagemat, CMTF_width2 / size(imagemat, 2));
		imagemat = Add_Caption(imagemat, fullfile(caption_dir, 'text_memorize.jpg'));
		filename = sprintf('trial-%03d_limit-3000_isi-%d.png', trial_num, CMTF_isi);
		imwrite_gray(imagemat, fullfile(output_dir, filename));
	end
	
	% learning test
	for i = 1:3
		bn = bn + 1;
		trial_num = trial_num + 1;
		stim_file = dir(fullfile(image_dirs{3}, sprintf('%02d.*.s%d.jpg', f, i)));
		imagemat = imread(fullfile(image_dirs{3}, stim_file.name));
		imagemat = imresize(imagemat, CMTF_width1 / size(imagemat, 2));
		imagemat = Add_Caption(imagemat, fullfile(caption_dir, 'textT_which_face.jpg'));
		filename = sprintf('trial-%03d_clickable-true_sections-3_correct-%d_isi-%d.png', ...
				trial_num, test_info.TarPosnLearning(bn), CMTF_isi);
		imwrite_gray(imagemat, fullfile(output_dir, filename));
	end
end


% review instruction
trial_num = trial_num + 1;
imagemat = imread(fullfile(caption_dir, 'inst_review1.jpg'));
filename = sprintf('trial-%03d_clickable-true_isi-%d.png', trial_num, CMTF_isi);
imwrite_gray(imagemat, fullfile(output_dir, filename));

% review faces
trial_num = trial_num + 1;
imagemat = imread(strcat(input_dir, 'ReviewScreen.jpg'));
imagemat = imagemat(196:705, 220 + (1:576), :);  % crop review faces
imagemat = Add_Caption(imagemat, fullfile(caption_dir, 'text_review2.jpg'));
filename = sprintf('trial-%03d_limit-20000_isi-%d.png', trial_num, CMTF_isi);
imwrite_gray(imagemat, fullfile(output_dir, filename));

% test instruction
trial_num = trial_num + 1;
imagemat = imread(fullfile(caption_dir, 'inst_review2.jpg'));
filename = sprintf('trial-%03d_clickable-true_isi-%d.png', trial_num, CMTF_isi);
imwrite_gray(imagemat, fullfile(output_dir, filename));


% test no noise
stim_mat = num2cell(combmat((1:6)', (1:5)'));
stim_mat = stim_mat(trial_info.TrialQueue1, :);
correct_mat = test_info.TarPosnNoNoise(trial_info.TrialQueue1);

for bn = 1:30
	trial_num = trial_num + 1;
	stim_file = dir(fullfile(image_dirs{4}, ...
			sprintf('%02d.*.t%d.jpg', stim_mat{bn, :})));
	imagemat = imread(fullfile(image_dirs{4}, stim_file.name));
	imagemat = imresize(imagemat, CMTF_width1 / size(imagemat, 2));
	imagemat = Add_Caption(imagemat, fullfile(caption_dir, 'text_which_face_6.jpg'));
	filename = sprintf('trial-%03d_clickable-true_sections-3_correct-%d_isi-%d.png', ...
			trial_num, correct_mat(bn), CMTF_isi);
	imwrite_gray(imagemat, fullfile(output_dir, filename));
end


% review faces again
trial_num = trial_num + 1;
imagemat = imread(strcat(input_dir, 'ReviewScreen.jpg'));
imagemat = imagemat(196:705, 220 + (1:576), :);  % crop review faces
imagemat = Add_Caption(imagemat, fullfile(caption_dir, 'text_review2.jpg'));
filename = sprintf('trial-%03d_limit-20000_isi-%d.png', trial_num, CMTF_isi);
imwrite_gray(imagemat, fullfile(output_dir, filename));


% test noise
stim_mat = num2cell(combmat((1:6)', (1:4)'));
stim_mat = stim_mat(trial_info.TrialQueue2, :);
correct_mat = test_info.TarPosnNoise(trial_info.TrialQueue2);

for bn = 1:24
	trial_num = trial_num + 1;
	stim_file = dir(fullfile(image_dirs{5}, ...
			sprintf('%02d.*.%d.jpg', stim_mat{bn, :})));
	imagemat = imread(fullfile(image_dirs{5}, stim_file.name));
	imagemat = imresize(imagemat, CMTF_width1 / size(imagemat, 2));
	imagemat = Add_Caption(imagemat, fullfile(caption_dir, 'text_which_face_6.jpg'));
	filename = sprintf('trial-%03d_clickable-true_sections-3_correct-%d_isi-%d.png', ...
			trial_num, correct_mat(bn), CMTF_isi);
	imwrite_gray(imagemat, fullfile(output_dir, filename));
end


% thank you
trial_num = trial_num + 1;
imagemat = imread(fullfile(caption_dir, 'thanks.jpg'));
filename = sprintf('trial-%03d_clickable-true.png', trial_num);
imwrite_gray(imagemat, fullfile(output_dir, filename));

