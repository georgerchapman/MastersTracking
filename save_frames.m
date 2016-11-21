function n = save_frames(videoFile, videoExt, slash)

%% Load video
% loads video file and converts into a matrix of images.
v = VideoReader([videoFile, videoExt]);

foldercheck = dir(['frames', slash, videoFile]);
if isempty(foldercheck)
    mkdir(['frames', slash, videoFile]);
end

count = 0;
while hasFrame(v)
    count = count + 1;
    frame = rgb2gray(readFrame(v)); % grayscale of image
    save(['frames', slash , videoFile, slash, int2str(count), '.mat'],'frame','-v7.3') % save frames
end

n = count;

end
