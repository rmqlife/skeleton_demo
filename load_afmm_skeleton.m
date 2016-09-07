function im = load_afmm_skeleton(filepath)
% load the skeleton image
im = imread(filepath);
im = im(:,:,1);
% process to remove the window bar
im = im(23:size(im,1),:,1);
im = uint8(255*(im>0));
