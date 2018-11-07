function [ im_blended ] = blend( im_input1, im_input2 )
%BLEND Blends two images together via feathering
% Pre-conditions:
%     `im_input1` and `im_input2` are both RGB images of the same size
%     and data type
% Post-conditions:
%     `im_blended` has the same size and data type as the input images
    
    assert(all(size(im_input1) == size(im_input2)));
    assert(size(im_input1, 3) == 3);

    im_blended = zeros(size(im_input1), 'like', im_input1);

    %------------- YOUR CODE STARTS HERE -----------------
    
    alpha1 = rgb2alpha(im_input1);
    alpha2 = rgb2alpha(im_input2);
    
    red_channel = (alpha1.*im_input1(:,:,1) + alpha2.*im_input2(:,:,1)) ...
        ./(alpha1 + alpha2);
    green_channel = (alpha1.*im_input1(:,:,2) + alpha2.*im_input2(:,:,2)) ...
        ./(alpha1 + alpha2);
    blue_channel = (alpha1.*im_input1(:,:,3) + alpha2.*im_input2(:,:,3)) ...
        ./(alpha1 + alpha2);
    
    im_blended(:,:,1) = red_channel;
    im_blended(:,:,2) = green_channel;
    im_blended(:,:,3) = blue_channel;
    
    %------------- YOUR CODE ENDS HERE -----------------

end

function im_alpha = rgb2alpha(im_input, epsilon)
% Returns the alpha channel of an RGB image.
% Pre-conditions:
%     im_input is an RGB image.
% Post-conditions:
%     im_alpha has the same size as im_input. Its intensity is between
%     epsilon and 1, inclusive.

    if nargin < 2
        epsilon = 0.001;
    end
    
    %------------- YOUR CODE STARTS HERE -----------------
    
    im_bin = im2bw(im_input, epsilon);
    
    comp_im = imcomplement(im_bin);
    bw_im = bwdist(comp_im,'euclidean');
    im_alpha = rescale(bw_im, epsilon, 1);
    
    %------------- YOUR CODE ENDS HERE -----------------

end
