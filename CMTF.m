function isDone = CMTF(SubjectID)
%% CMFT(SubjectID), eg. CMFT('jarod')
%% Rui Xu 5/26/2006
%% Ruosi Wang 2/9/2011

isDone = 0;
warning off;
rootDir = pwd;
AssertOpenGL; % check for Opengl compatibility, abort 
HideCursor;

%% Program Preparation
fmt = 'jpg'; % Use JPEG image type.
KbName('UnifyKeyNames');
sKey = KbName('space');
r1Key = KbName('1!');
r2Key = KbName('2@');
r3Key = KbName('3#');
escKey = KbName('ESCAPE');

% trialQueue & answer information
trialQueue1 = Shuffle (1:30);
trialQueue2 = Shuffle (1:24);
load ('TarPosn.mat');

% Open a fullScreen window
Screen('Preference','SkipSyncTests',1);
Screens=Screen('Screens');
ScreenNumber=max(Screens);
white=WhiteIndex(ScreenNumber);
window=Screen('OpenWindow',ScreenNumber,white);
refresh = Screen('GetFlipInterval', window);

% Dirction Position
ScreenRect=Screen(ScreenNumber,'rect');
directRect = [0 0 1024 768];
directPosn = CenterRect(directRect, ScreenRect);

% Option Pic 
noArray = imread('123.jpg',fmt);

% Task Name
imgArray = imread('TaskName.jpg', fmt);
TaskName = Screen('MakeTexture',window,imgArray);

% Practice Direction
imgArray = imread('PracticeDirect.jpg', fmt);
PracticeDirect = Screen('MakeTexture',window,imgArray);

% PracticeRight Direction (after choosing a right response in Practice)
imgArray = imread('PracticeRight.jpg', fmt);
PracticeRight = Screen('MakeTexture',window,imgArray);

% PracticeWrong Direction (after choosing a wrong response in Practice)
imgArray = imread('PracticeWrong.jpg', fmt);
PracticeWrong = Screen('MakeTexture',window,imgArray);

% ResumeLearning Direction
imgArray = imread('ResumeLearning.jpg', fmt);
ResumeLearning = Screen('MakeTexture',window,imgArray);

% Direction for reviewing target faces(Part I)
imgArray = imread('ReviewDirect.jpg', fmt);
ReviewDirect = Screen('MakeTexture',window,imgArray);

% Review Faces & Direction
imgArray = imread('ReviewScreen.jpg', fmt);
ReviewScreen = Screen('MakeTexture',window,imgArray);

% No Noise Test Direction
imgArray = imread('NoNoiseTestDirect.jpg', fmt);
NoNoiseTestDirect = Screen('MakeTexture',window,imgArray);

% Direction for reviewing target faces(Part II)
imgArray = imread('ReviewDirect2.jpg', fmt);
ReviewDirect2 = Screen('MakeTexture',window,imgArray);

% Noise Test Direction
imgArray = imread('NoiseTestDirect.jpg', fmt);
NoiseTestDirect = Screen('MakeTexture',window,imgArray);

% End of Experiment
imgArray = imread('EndExp.jpg', fmt);
EndExp = Screen('MakeTexture',window,imgArray);

% Banner Position
BannerRect1 = [0 0 750 200];
BannerRect2 = [0 0 250 100];
BannerPosn1 = OffsetRect(CenterRect(BannerRect1,ScreenRect),0, -200);
BannerPosn2 = OffsetRect(CenterRect(BannerRect2,ScreenRect),0, -150);

% PracticeBanner
imgArray = imread('PracticeBanner.jpg', fmt);
PracticeBanner = Screen('MakeTexture',window,imgArray);

% PracticeBanner2
imgArray = imread('PracticeBanner2.jpg', fmt);
PracticeBanner2 = Screen('MakeTexture',window,imgArray);

% TestBanner
imgArray = imread('TestBanner.jpg', fmt);
TestBanner = Screen('MakeTexture',window,imgArray);

% Pic Dirction
PracticeDir = char([rootDir '/Practice']);		% 1-3 LP,Front,RP 4-6 LP Front RP, with distractors
LearningDir = char([rootDir '/SingleFace'], ...		% Single Face , 1-3, 4-6,...,16-18, LFR single faces of 6 person
			[rootDir '/Learning']);		% Learning , 1-3, 4-6,...,16-18, LFR with distractors of 6 person
NoNoiseDir = char([rootDir '/NoNoise']);		% No noise, 30, with distractors
NoiseDir = char([rootDir '/Noise']);			% Noise, 24, with distractors

% Stimulus Position
stimRect1 = [0 0 750 400];
stimRect2 = [0 0 250 300];
stimPosn1 = OffsetRect(CenterRect(stimRect1,ScreenRect),0, 100);
stimPosn2 = OffsetRect(CenterRect(stimRect2,ScreenRect),0, 50);

% Practice Pic (Learn)
cd(PracticeDir);
d = dir('*.jpg');
[numitems junk] = size(d);
[itemlist{1:numitems}] = deal(d.name);

for theitem = 1:3
	filename = itemlist{theitem};
	[imgArray] = imread(filename, fmt);
	PracticePic(theitem) = Screen('MakeTexture',window,imgArray);
end

% Practice Pic (Test) 
for theitem = 4:6
	filename = itemlist{theitem};
	[imgArray] = imread(filename, fmt);
	imgArray2(:,:,1)= [imgArray(:,:,1)' noArray']';
	imgArray2(:,:,2)= [imgArray(:,:,2)' noArray']';
	imgArray2(:,:,3)= [imgArray(:,:,3)' noArray']';
    PracticePic(theitem) = Screen('MakeTexture',window,imgArray2);
end

% Target Faces
cd(deblank(LearningDir(1, :)));
d = dir('*.jpg');
[numitems junk] = size(d);
[itemlist{1:numitems}] = deal(d.name);

for theitem = 1:numitems
	filename = itemlist{theitem};
	[imgArray] = imread(filename, fmt);
	LearnFace(theitem) = Screen('MakeTexture',window,imgArray);
end

% Test Faces
cd(deblank(LearningDir(2, :)));
d = dir('*.jpg');
[numitems junk] = size(d);
[itemlist{1:numitems}] = deal(d.name);

for theitem = 1:numitems
	filename = itemlist{theitem};
	[imgArray] = imread(filename, fmt);
	imgArray = imresize(imgArray,0.5);
	imgArray= [imgArray' noArray']';
	TestFace(theitem) = Screen('MakeTexture',window,imgArray);
end

% NoNoise Faces
cd(NoNoiseDir);
d = dir('*.jpg');
[numitems junk] = size(d);
[itemlist{1:numitems}] = deal(d.name);

for theitem = 1:numitems
	filename = itemlist{theitem};
	[imgArray] = imread(filename, fmt);
	imgArray = imresize(imgArray,0.5);
	imgArray= [imgArray' noArray']';
	NoNoiseFace(theitem) = Screen('MakeTexture',window,imgArray);
end

% Noise Faces
cd(NoiseDir);
d = dir('*.jpg');
[numitems junk] = size(d);
[itemlist{1:numitems}] = deal(d.name);

for theitem = 1:numitems
	filename = itemlist{theitem};
	[imgArray] = imread(filename, fmt);
	imgArray = imresize(imgArray,0.5);
	imgArray2(:,:,1)= [imgArray(:,:,1)' noArray']';
	imgArray2(:,:,2)= [imgArray(:,:,2)' noArray']';
	imgArray2(:,:,3)= [imgArray(:,:,3)' noArray']';
	NoiseFace(theitem) = Screen('MakeTexture',window,imgArray2);
end

%% Experiment Start
experimentStart = GetSecs;

% Display Task Name (2s)
Screen('DrawTexture', window, TaskName,[],directPosn);
vbl = Screen('Flip',window);
Screen('Flip',window,vbl + 2 - refresh/2);

isContinue =1;
while isContinue == 1
	isContinue =0;
	
	% Practice Direction
	Screen('DrawTexture', window, PracticeDirect,[],directPosn);
    Screen('Flip',window);
    
    % Press space key to advance experiment
	while KbCheck, end;
	while 1
	    [keyIsDown,junk,keyCode] = KbCheck;
	    if keyIsDown && keyCode(sKey), 
		break; % continue only when "space" key is pressed
	    end
    end
    
    Screen('Flip',window);

	% Practice Start 
	PracticeAnswer = [1 2 2]; % L,R,F
	tempKey = zeros(1,3);
	tempRT = zeros(1,3);

	for i  = 1:3
		Screen('DrawTexture',window,PracticePic(i),[], stimPosn2);
		Screen('DrawTexture',window,PracticeBanner2,[], BannerPosn2);
        vbl = Screen('Flip',window);
        Screen('Flip',window,vbl + 0.5 - refresh/2);

	    Screen('Flip',window);
        WaitSecs(0.5);
	end

	for i  = 4:6
		trialStart = GetSecs;

		Screen('DrawTexture',window,PracticePic(i),[], stimPosn1);
		Screen('DrawTexture',window,PracticeBanner,[], BannerPosn1);
	    Screen('Flip',window);

		%% collect a key response
		responded = 0; oneRT = 0; 
		while responded==0  %% wait for response
			[keyIsDown,secs,keyCode] = KbCheck;
			if keyIsDown &&  keyCode(r1Key)   && ~responded,
				responded = 1;
				tempKey(i-3) = 1;
				if oneRT == 0
					  oneRT = GetSecs-trialStart;
				end
			elseif keyIsDown &&  keyCode(r2Key)   && ~responded,
				responded = 1;
				tempKey(i-3) = 2;
				if oneRT == 0
					  oneRT = GetSecs-trialStart;
				end
			elseif keyIsDown &&  keyCode(r3Key)   && ~responded,
				responded = 1;
				tempKey(i-3) = 3;
				if oneRT == 0
					  oneRT = GetSecs-trialStart;
				end		
			elseif keyIsDown && keyCode(escKey),
				Screen('CloseAll'); showcursor;
				disp('ESC is pressed to abort the program.');
				cd (rootDir);
				return;
			end
		end	
		tempRT(i-3)  = oneRT;
		if tempKey(i-3) ~= PracticeAnswer(i-3)
			isContinue = 1;
			break;
        end
        
		Screen('Flip',window);
        WaitSecs(0.5);
	end
	if isContinue == 1,
		% After choosing a wrong response
		Screen('DrawTexture',window,PracticeWrong,[],directPosn);
        Screen('Flip',window);

		while KbCheck, end;
		while 1
		    [keyIsDown,secs,keyCode] = KbCheck;
		    if keyIsDown & keyCode(sKey), 
			break; % continue only when "space" key is pressed
		    end
		end

		Screen('Flip',window);
	end
end

% after choosing the right response
Screen('DrawTexture',window,PracticeRight,[],directPosn);
Screen('Flip',window);

while KbCheck, end;
while 1
    [keyIsDown,secs,keyCode] = KbCheck;
    if keyIsDown & keyCode(sKey), 
        break; % continue only when "space" key is pressed
    end
end

Screen('Flip',window);
WaitSecs(0.5);

% Learning 6 target faces

LearningKey = zeros(18,1);
LearningRT = zeros(18,1);
LearningCorrect = 0;

for i  = 1:6
	for j  = 1:3
        Screen('DrawTexture',window,LearnFace(i*3-3+j),[], stimPosn2);
		Screen('DrawTexture',window,PracticeBanner2,[], BannerPosn2);
        vbl = Screen('Flip',window);
        Screen('Flip',window,vbl + 3 - refresh/2);

		vbl = Screen('Flip',window);
        Screen('Flip',window,vbl + 0.5 - refresh/2);
	end

	for j  = 1:3
		trialStart = GetSecs;
        Screen('DrawTexture',window,TestFace(i*3-3+j),[], stimPosn1);
		Screen('DrawTexture',window,PracticeBanner,[], BannerPosn1);
        Screen('Flip',window);
        
		% collect a key response
		responded = 0; oneRT = 0; 
		while responded==0  %% wait for response
			[keyIsDown,secs,keyCode] = KbCheck;
			if keyIsDown &&  keyCode(r1Key)  && ~responded,
				responded = 1;
				LearningKey(i*3-3+j,1) = 1;
				if oneRT == 0
					  oneRT = GetSecs-trialStart;
				end
			elseif keyIsDown &&  keyCode(r2Key) && ~responded,
				responded = 1;
				LearningKey(i*3-3+j,1) = 2;
				if oneRT == 0
					  oneRT = GetSecs-trialStart;
				end
			elseif keyIsDown &&  keyCode(r3Key) && ~responded,
				responded = 1;
				LearningKey(i*3-3+j,1) = 3;
				if oneRT == 0
					  oneRT = GetSecs-trialStart;
				end		
			elseif keyIsDown && keyCode(escKey),
				Screen('CloseAll'); showcursor;
				disp('ESC is pressed to abort the program.');
				cd (rootDir);
				return;
			end
		end	
		LearningRT(i*3-3+j,1)  = oneRT;
		if LearningKey(i*3-3+j,1) == TarPosnLearning(i*3-3+j,1),
			LearningCorrect = LearningCorrect+1;
        end
        
        Screen('Flip',window);
        WaitSecs(0.5);
	end	

	if i ~= 6
        Screen('DrawTexture',window,ResumeLearning,[], directPosn);
        Screen('Flip',window);
		
		while KbCheck, end;
		while 1
		    [keyIsDown,secs,keyCode] = KbCheck;
		    if keyIsDown & keyCode(sKey), 
			break; % continue only when "space" key is pressed
		    end
		end
		Screen('Flip',window);	
	end
end

% Review Direction (Part I)
Screen('DrawTexture',window,ReviewDirect,[], directPosn);
Screen('Flip',window);

while KbCheck, end;
while 1
    [keyIsDown,secs,keyCode] = KbCheck;
    if keyIsDown & keyCode(sKey), 
        break; % continue only when "space" key is pressed
    end
end

	Screen('Flip',window);

% Review Faces (Part I: 20s)
Screen('DrawTexture',window,ReviewScreen,[], directPosn);
vbl = Screen('Flip',window);
Screen('Flip',window,vbl + 20 - refresh/2);


% NoNoiseTest Direction: waiting for response
Screen('DrawTexture',window,NoNoiseTestDirect,[], directPosn)
Screen('Flip',window);

while KbCheck, end;
while 1
    [keyIsDown,secs,keyCode] = KbCheck;
    if keyIsDown & keyCode(sKey), 
        break; % continue only when "space" key is pressed
    end
end

Screen('Flip',window);

% NoNoiseTest Start

NoNoiseKey = zeros(30,1);
NoNoiseRT = zeros(30,1);
NoNoiseCorrect = 0;

	for i  = 1:30
		trialStart = GetSecs;
        
        Screen('DrawTexture',window,NoNoiseFace(trialQueue1(i)),[], stimPosn1);
		Screen('DrawTexture',window,TestBanner,[], BannerPosn1);
        Screen('Flip',window);

		%% collect a key response
		responded = 0; oneRT = 0; 
		while responded==0  %% wait for response
			[keyIsDown,secs,keyCode] = KbCheck;
			if keyIsDown &&  keyCode(r1Key)   && ~responded,
				responded = 1;
				NoNoiseKey(i,1) = 1;
				if oneRT == 0
					  oneRT = GetSecs-trialStart;
				end
			elseif keyIsDown &&  keyCode(r2Key)   && ~responded,
				responded = 1;
				NoNoiseKey(i,1) = 2;
				if oneRT == 0
					  oneRT = GetSecs-trialStart;
				end
			elseif keyIsDown &&  keyCode(r3Key)   && ~responded,
				responded = 1;
				NoNoiseKey(i,1) = 3;
				if oneRT == 0
					  oneRT = GetSecs-trialStart;
				end		
			elseif keyIsDown && keyCode(escKey),
				Screen('CloseAll'); showcursor;
				disp('ESC is pressed to abort the program.');
				cd (rootDir);
				return;
			end
		end	
		NoNoiseRT(i,1)  = oneRT;
		if NoNoiseKey(i,1) == TarPosnNoNoise(trialQueue1(i))
			NoNoiseCorrect = NoNoiseCorrect+1;
        end

	    Screen('Flip',window);
        WaitSecs(0.5);
	end	

% Review Direction (Part II)
Screen('DrawTexture',window, ReviewDirect2,[], directPosn);
Screen('Flip',window);

while KbCheck, end;
while 1
    [keyIsDown,secs,keyCode] = KbCheck;
    if keyIsDown & keyCode(sKey), 
        break; % continue only when "space" key is pressed
    end
end

Screen('Flip',window);

% Review Faces (Part II: 20s)
Screen('DrawTexture',window,ReviewScreen,[], directPosn);
vbl = Screen('Flip',window);
Screen('Flip',window,vbl + 20 - refresh/2);

% NoiseTest Direction: Waiting for response
Screen('DrawTexture',window,NoiseTestDirect,[], directPosn)
Screen('Flip',window);

while KbCheck, end;
while 1
    [keyIsDown,secs,keyCode] = KbCheck;
    if keyIsDown & keyCode(sKey), 
        break; % continue only when "space" key is pressed
    end
end

Screen('Flip',window);

% NoiseTestStart

NoiseKey = zeros(24,1);
NoiseRT = zeros(24,1);
NoiseCorrect = 0;

	for i  = 1:24
		trialStart = GetSecs;

        Screen('DrawTexture',window,NoiseFace(trialQueue2(i)),[], stimPosn1);
		Screen('DrawTexture',window,TestBanner,[], BannerPosn1);
        Screen('Flip',window);
        
		%% collect a key response
		responded = 0; oneRT = 0; 
		while responded==0  %% wait for response
			[keyIsDown,secs,keyCode] = KbCheck;
			if keyIsDown &&  keyCode(r1Key)   && ~responded,
				responded = 1;
				NoiseKey(i,1) = 1;
				if oneRT == 0
					  oneRT = GetSecs-trialStart;
				end
			elseif keyIsDown &&  keyCode(r2Key)   && ~responded,
				responded = 1;
				NoiseKey(i,1) = 2;
				if oneRT == 0
					  oneRT = GetSecs-trialStart;
				end
			elseif keyIsDown &&  keyCode(r3Key)   && ~responded,
				responded = 1;
				NoiseKey(i,1) = 3;
				if oneRT == 0
					  oneRT = GetSecs-trialStart;
				end		
			elseif keyIsDown && keyCode(escKey),
				Screen('CloseAll'); showcursor;
				disp('ESC is pressed to abort the program.');
				cd (rootDir);
				return;
			end
		end	
		NoiseRT(i,1)  = oneRT;
		if NoiseKey(i,1) == TarPosnNoise(trialQueue2(i))
			NoiseCorrect = NoiseCorrect+1;
        end
        
        Screen('Flip',window);
        WaitSecs(0.5);
	end	

% End of Experiment, Save results

cd(rootDir);

Screen('DrawTexture',window,EndExp,[], directPosn);
vbl = Screen('Flip',window);
Screen('Flip',window,vbl + 1 - refresh/2);		
        
experimentEnd = GetSecs;
experimentDur = experimentEnd - experimentStart;

LearningPercentage = LearningCorrect/18;
NoNoisePercentage = NoNoiseCorrect/30;
NoisePercentage = NoiseCorrect/24;

Screen('CloseAll');
showcursor;

c = clock;

taskName = 'CMTF';

save([num2str(fix(c(1))) num2str(fix(c(2)),'%02d') num2str(fix(c(3)),'%02d') SubjectID '.mat'], ...
	'SubjectID' , 'ScreenRect','BannerPosn1','BannerPosn2','stimPosn1','stimPosn2','trialQueue1','trialQueue2','tempKey','tempRT', ...
	'experimentDur','LearningKey','LearningRT','NoNoiseKey','NoNoiseRT','NoiseKey','NoiseRT', 'taskName',...
	'LearningPercentage','LearningCorrect','NoNoisePercentage','NoNoiseCorrect','NoisePercentage','NoiseCorrect');

warning on;
isDone =1;