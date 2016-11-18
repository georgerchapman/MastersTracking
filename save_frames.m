function n = save_frames(videoFile, videoExt)

%% Load video
% loads video file and converts into a matrix of images.
v = VideoReader([videoFile, videoExt]);

foldercheck = dir(['frames\', videoFile]);
if isempty(foldercheck)
    mkdir(['frames\', videoFile]);
end

count = 0;
while hasFrame(v)
    count = count + 1;
    frame = rgb2gray(readFrame(v)); % grayscale of image
    save(['frames\', videoFile, '\', int2str(count), '.mat'],'frame','-v7.3') % save frames
end

n = count;

end
