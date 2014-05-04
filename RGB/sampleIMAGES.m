function patches = sampleIMAGES(IMAGES)
% sampleIMAGES
% Returns 10000 patches for training

%load IMAGES;    % load images from disk 

patchsize = 8;  % we'll use 8x8 patches 
numpatches = 1200;
image_channels=3;
%numpatches = 10;

% Initialize patches with zeros.  Your code will fill in this matrix--one
% column per patch, 10000 columns. 
patches = zeros(patchsize*patchsize*3,numpatches);

%% ---------- YOUR CODE HERE --------------------------------------
%  Instructions: Fill in the variable called "patches" using data 
%  from IMAGES.  
%  
%  IMAGES is a 3D array containing 10 images
%  For instance, IMAGES(:,:,6) is a 512x512 array containing the 6th image,
%  and you can type "imagesc(IMAGES(:,:,6)), colormap gray;" to visualize
%  it. (The contrast on these images look a bit off because they have
%  been preprocessed using using "whitening."  See the lecture notes for
%  more details.) As a second example, IMAGES(21:30,21:30,1) is an image
%  patch corresponding to the pixels in the block (21,21) to (30,30) of
%  Image 1

imageHeight = size(IMAGES,1);
imageWidth  = size(IMAGES,2)/3;
for i = 1:numpatches
	image_no = randi(60);
	y1 = randi(imageHeight-patchsize+1);
	y2 = y1 + (patchsize - 1);
	x11 = randi(imageWidth-patchsize+1);
	x12 = randi(imageWidth*2-patchsize+1);
	x13 = randi(imageWidth*3-patchsize+1);

	x21 = x11 + (patchsize - 1);
	x22 = x12 + (patchsize - 1);
	x23 = x13 + (patchsize - 1);
	p1  = IMAGES(y1:y2, x11:x21, image_no); 
	p2  = IMAGES(y1:y2, x12:x22, image_no);
	p3  = IMAGES(y1:y2, x13:x23, image_no);
	p   = [p1 p2 p3]
	patches(:,i) = p(:);
end;
fprintf('\n patches Data Length = %d Features = %d \n',size(patches,1),size(patches,2));	


%% ---------------------------------------------------------------
% For the autoencoder to work well we need to normalize the data
% Specifically, since the output of the network is bounded between [0,1]
% (due to the sigmoid activation function), we have to make sure 
% the range of pixel values is also bounded between [0,1]
patches = normalizeData(patches);

end


%% ---------------------------------------------------------------
function patches = normalizeData(patches)

% Squash data to [0.1, 0.9] since we use sigmoid as the activation
% function in the output layer

% Remove DC (mean of images). 
patches = bsxfun(@minus, patches, mean(patches));

% Truncate to +/-3 standard deviations and scale to -1 to 1
pstd = 3 * std(patches(:));
patches = max(min(patches, pstd), -pstd) / pstd;

% Rescale from [-1,1] to [0.1,0.9]
patches = (patches + 1) * 0.4 + 0.1;

end
