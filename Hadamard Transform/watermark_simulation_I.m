% ----------
% Digital Watermarking for Hadamard Transform
% Watermark Embedding and Extraction
% ----------
clc;
clear;
close all;
warning off;
addpath 'function/'
addpath 'img/'

% ----------
% Define global variable matrix H
% ----------
global H;
global NC_Array;

img_1 = 'img/lena.bmp';
img_2 = 'img/cameraman.jpg';
img_3 = 'img/peppers.tif';

N = 8; % Define the number of blocks
H = hadamard(N);
NC_Array = [];
% ----------
% Read the image and watermark
% ----------
I0 = imread(img_3);
I1 = imread('img/Watermark_CityUHK.bmp');
[I0,Marks1] = func_read_images(I0,I1);

% ---------
% Resize the image and Set the size of watermark
% ---------
I0          = imresize(I0,[1024,1024]);
RR          = 110;
CC          = 110;

% ----------
% Define Power and Block size
% ----------
Power       = 8;  
Blksize     = 8;   

% ----------
% Perform Arnold Transform
% ----------
Marks1s     = Arnold(Marks1,1,0); 

% ----------
% Forward the image and watermark to the encoder
% ----------
Mwk_1st   = func_wk_embed(I0,Marks1s,Power,Blksize,RR,CC);

% ----------
% Export the Watermarked Image
% ----------
imwrite(uint8(Mwk_1st),'Hadamard.bmp');

% ----------
% Certain level of attacks
% ----------
for i = 1:7
SEL = i;
if SEL == 1
% Noise attack
noise0    = 10*randn(size(Mwk_1st));
Mwk_1st0   = double(Mwk_1st) + noise0;
end

if SEL == 2
% Rotation attack
Mwk_1st0   = double(imrotate(Mwk_1st,0.1,'bilinear','crop'));
end

if SEL == 3
% Cropping attack
Mwk_1st0(601:800,601:800) = 255*rand(200,200);
end

if SEL == 4
% Scaling attack
Mwk_1st0   = imresize(Mwk_1st,1/2);
Mwk_1st0   = imresize(Mwk_1st0,2);
end

if SEL == 5
% Pixel reduction attack
Mwk_1st0(200,:) = 255*rand(1,1024);
Mwk_1st0(:,400) = 255*rand(1024,1);
end

if SEL == 6
% Guassian Smoothing attack
G = fspecial('gaussian', [5 5], 0.5);
Mwk_1st0 = imfilter(Mwk_1st,G,'same');
end

if SEL == 7
% Sharpening attack
Mwk_1st0 = double((1.5*Mwk_1st));
end

% ----------
% Watermark Extraction (to the decoder)
% ----------
Msg1      = func_wk_extract(Mwk_1st0,Blksize,RR,CC,4);

% ----------
% Inverse Arnold Transform
% ----------
Msg1s     = Arnold(uint8(255*Msg1),1,1); 

% ----------
% Export the Attacked Image
% ----------
attack_mth = 'hadamard_attack';
imwrite(uint8(Mwk_1st0),sprintf('%s%d.bmp',attack_mth,i));

% ----------
% Export the Extracted Watermark
% ----------
transform_mth = 'hadamard';
imwrite(Msg1s,sprintf('%s%d.bmp',transform_mth,i));

Marks1 = imresize(Marks1,[RR,CC]);
NC     = func_nc(uint8(Marks1),uint8(Msg1s));

NC_Array(i) = NC;

% figure
% subplot(221);
% imshow(I0,[]);
% title('Original Image');
% subplot(222);
% imshow(Marks1,[]);
% title('Original Watermark');
% subplot(223);
% imshow(Mwk_1st,[]);
% title('Attacked Image');
% subplot(224);
% imshow(Msg1s,[]);
% title('Extracted Watermark');

end

Display;

% ==========
% PSNR
% ==========
figure;
I0          = imresize(I0,[1024,1024]);
Hadamard_watermarked = imread('Hadamard.bmp');
Hadamard_img = imresize(Hadamard_watermarked,[1024,1024]);

PSNR = func_psnr(uint8(I0),uint8(Hadamard_img));
txt_str =  sprintf('%s%0.5f','PSNR: ', PSNR);

subplot(121);
imshow(I0);
title('Original Image');

img_PSNR = insertText(uint8(Hadamard_watermarked), [450 900], txt_str,'FontSize',70);
ax = subplot(122);
imshow(img_PSNR, 'Parent', ax); 
title('Watermarked Image');


% for K = 1 : 5; 
%     figure
% subplot(1,7,i)
% % set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% % set(gcf, 'Toolbar', 'none', 'Menu', 'none');
% imshow('{i}.bmp',[]);
% title(Type_of_attacks(i));
% end

% Marks1 = imresize(Marks1,[RR,CC]);
% NC     = func_nc(uint8(Marks1),uint8(Msg1s)); 


% if SEL == 8
% compressed_img = imread('compressed_img.jpg');
% Mwk_1st = compressed_img;
% end
% 
% if SEL == 9
% imwrite(uint8(Mwk_1st),'Hadamard.bmp');
% end

% ----------
% Result
% ----------
% figure
% subplot(221);
% imshow(I0,[]);
% title('Original Image');
% subplot(222);
% imshow(Marks1,[]);
% title('Original Watermark');
% subplot(223);
% imshow(Mwk_1st,[]);
% title('Attacked Image');
% subplot(224);
% imshow(Msg1s,[]);
% title('Extracted Watermark');

% ----------
% Present the result
% ----------
% Marks1 = imresize(Marks1,[RR,CC]);
% NC     = func_nc(uint8(Marks1),uint8(Msg1s));
% PSNR = func_psnr(uint8(I0),uint8(Mwk_1st));
 