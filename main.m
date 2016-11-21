% progress: saves and reads in individual frames of input image.  need to
% add selecting of droplet in first frame.

homeDir = 'C:\Users\dwh\Documents\MATLAB\MQMTracking';
dirSlash = '\';

% homeDir = ['/Users/georgechapman/Documents/OneDrive/Documents/',...
%     'University/Year 4/Masters Project/Matlab'];
% dirSlash = '/';

clear
cd(homeDir);

%% Load video
% loads video file and converts into a matrix of images.
videoFile = 'corral1';
videoExt = '.avi';
nframes = save_frames(videoFile,videoExt, dirSlash);

%% Find coordinates
% finds the coordinates in the video of the maximum change in pixels
% between frames.

cd([homeDir, dirSlash, 'frames', dirSlash, videoFile])

threshold = 0; % min difference between frames to be considered
maxShift = 20; % circle of radius 10 for search for next position

% load list of frames
framelist = dir('*.mat');
nframes = size(framelist,1);
frames = zeros(nframes,1);
for i = 1:nframes
    framestr = framelist(i).name;
    framestr = framestr(:,1:end-4); % removes .mat
    frames(i) = str2double(framestr);
end
frames = sortrows(frames); % frame numbers ordered

% load first frame
load([num2str(frames(1)),'.mat']);
imagesc(frame);
pause(1);
xMax(1) = input('Enter droplet x position: ');
yMax(1) = input('Enter droplet y position: ');

h = waitbar(0,'Tracking');
[X,Y] = meshgrid(1:size(frame,2),1:size(frame,1));
for i = 2:nframes
    frameprev = frame;
    load([num2str(frames(i)),'.mat']);
    
    diff = abs(frame - frameprev);

    blobs = conv2(double(diff),-fspecial('log',30,6),'same');
    clear diff

    blobs(blobs < threshold) = 0;

    R = ( (X - xMax(i - 1)).^2 + (Y - yMax(i - 1)).^2 ).^0.5;
    blobs(R > maxShift) = 0;

    blobMax = max(blobs(:));

    if blobMax ~= 0
        [yMax(i), xMax(i)] = find(blobs == blobMax);
    else
        xMax(i) = xMax(i-1);
        yMax(i) = yMax(i-1);
    end

    waitbar(i/nframes,h);
end

close(h);

xMax(1) = xMax(2);
yMax(1) = yMax(2);

cd(homeDir);

%% Plot results
cd([homeDir, dirSlash, 'frames', dirSlash, videoFile])
% animated view
% for i = 2:nframes
%     load([num2str(frames(i)),'.mat']);
%     imagesc(frame);
%     hold on;
%     plot(xMax(1:i),yMax(1:i),'r-')
%     hold off;
%     axis equal
%     pause;
% end

% end view
load([num2str(frames(end)),'.mat']);
imagesc(frame);
hold on;
plot(xMax,yMax,'r-')
hold off;
axis equal

cd(homeDir);
