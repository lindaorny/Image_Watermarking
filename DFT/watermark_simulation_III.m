% ----------
% Digital Watermarking for CS-SCHT and DFT
% Watermark Embedding and Extraction
% ----------
clc;
clear;
close all;
warning off;
addpath 'func/'
addpath 'img/'

global H;
global NC_Array;

img_1 = 'img/lena.bmp';
img_2 = 'img/cameraman.jpg';
img_3 = 'img/peppers.tif';

% ----------
% Define global variable matrix H
% ----------

% H=([1, 1, 1, 1, 1, 1, 1, 1;
%     1, 1, j, j,-1,-1,-j,-j;
%     1, j,-1,-j, 1, j,-1,-j;
%     1,-1,-j, j,-1, 1, j,-j;
%     1,-1, 1,-1,-1,-1, 1,-1;
%     1,-1, j,-j,-1, 1,-j, j;
%     1,-j,-1, j, 1,-j,-1, j;
%     1, 1,-j,-j,-1,-1, j, j]);

H = dftmtx(8);
NC_Array = [];

% SEL = 3;
% ----------
% Read the image and watermark

% img_1: lena image
% img_2: cameraman image
% img_3: peppers image
% ----------
I0 = imread(img_1);
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
[Mwk_1st0,Mwk_1sts] = func_wk_insert_final(I0,Marks1s,Power,Blksize,RR,CC);

% ----------
% Export the Watermarked Image
% ----------
imwrite(uint8(Mwk_1sts),'dft.bmp');

% ----------
% Certain level of attacks
% ----------
for i = 1:7
SEL = i;
if SEL == 1
noise0    = 15*randn(size(Mwk_1sts));
Mwk_1st   = double(Mwk_1sts) + noise0;
end

if SEL == 2
Mwk_1st   = double(imrotate(Mwk_1sts,0.1,'bilinear','crop'));
end

if SEL == 3
Mwk_1st   = Mwk_1sts;
Mwk_1st(601:800,601:800) = 255*rand(200,200);
end

if SEL == 4
Mwk_1st   = imresize(Mwk_1sts,1/2);
Mwk_1st   = imresize(Mwk_1st,2);
end

if SEL == 5
Mwk_1st   = Mwk_1sts;
Mwk_1st(200,:) = 255*rand(1,1024);
Mwk_1st(:,400) = 255*rand(1024,1);
end

if SEL == 6
G = fspecial('gaussian', [5 5], 0.5);
Mwk_1st = imfilter(Mwk_1sts,G,'same');
end

if SEL == 7
Mwk_1st = double((1.2*Mwk_1sts));
end

% ----------
% Watermark Extraction (to the decoder)
% ----------
Msg1      = func_wk_desert_final(Mwk_1st,Blksize,RR,CC,4);

% ----------
% Inverse Arnold Transform
% ----------
Msg1s     = Arnold(uint8(255*Msg1),1,1); 

% ----------
% Export the Attacked Image
% ----------
attack_mth = 'dft_attack';
imwrite(uint8(Mwk_1st),sprintf('%s%d.bmp',attack_mth,i));

% ----------
% Export the Extracted Watermark
% ----------
transform_mth = 'dft';
imwrite(Msg1s,sprintf('%s%d.bmp',transform_mth,i));

Marks1 = imresize(Marks1,[RR,CC]);
NC     = func_nc(uint8(Marks1),uint8(Msg1s));

NC_Array(i) = NC;

end;

Display_III;

figure;
I0          = imresize(I0,[1024,1024]);
dft_watermarked = imread('dft.bmp');
dft_img = imresize(dft_watermarked,[1024,1024]);

PSNR = func_psnr(uint8(I0),uint8(dft_img));
txt_str =  sprintf('%s%0.5f','PSNR: ', PSNR);

subplot(121);
imshow(I0);
title('Original Image');

img_PSNR = insertText(uint8(dft_watermarked), [450 900], txt_str,'FontSize',70);
ax = subplot(122);
imshow(img_PSNR, 'Parent', ax); 
title('Watermarked Image');

% if SEL == 8
% compressed_img = imread('compressed_img.jpg');
% Mwk_1st = compressed_img;
% end
% 
% if SEL == 9
% Mwk_1st = Mwk_1sts;
% imwrite(uint8(Mwk_1st),'cs_scht_watermarked_image.bmp');
% end

% figure
% subplot(221);
% imshow(I0,[]);
% title('Original Image');
% subplot(222);
% imshow(Marks1,[]);
% title('Original Watermark');
% subplot(223);
% imshow(uint8(Mwk_1st));
% title('Attacked Image');
% subplot(224);
% imshow(Msg1s,[]);
% title('Extracted Watermark');

% PSNR = func_psnr(uint8(I0),uint8(Mwk_1st));
% txt_str =  sprintf('%s%0.5f','PSNR: ', PSNR);
% J = insertText(uint8(Mwk_1st), [450 900], txt_str,'FontSize',70);

% figure
% subplot(121);
% imshow(I0,[]);
% title('Original Image');
% subplot(122);
% imshow(J);
% title('Watermarked Image');

% Marks1 = imresize(Marks1,[RR,CC]);
% NC     = func_nc(uint8(Marks1),uint8(Msg1s)) 

 