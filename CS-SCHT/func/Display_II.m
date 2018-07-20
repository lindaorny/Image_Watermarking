
addpath 'img/'
NC = [];

% ----------
% Present the Original image, watermark and permuted watermark
% ----------
% figure
% subplot(221);
% imshow(I0,[]);
% title('Original Image');
% subplot(222);
% imshow(uint8(Mwk_1st),[]);
% title('Watermarked Image');
% subplot(223);
% imshow(Marks1,[]);
% title('Watermark');
% subplot(224);
% imshow(Marks1s,[]);
% title('Permuted Watermark');


attacked_image = {'cs-scht_attack1.bmp','cs-scht_attack2.bmp','cs-scht_attack3.bmp','cs-scht_attack4.bmp','cs-scht_attack5.bmp','cs-scht_attack6.bmp','cs-scht_attack7.bmp'};
extracted_watermark = {'cs-scht1.bmp', 'cs-scht2.bmp', 'cs-scht3.bmp', 'cs-scht4.bmp', 'cs-scht5.bmp','cs-scht6.bmp','cs-scht7.bmp'};

% ==========
% NCC
% ==========
Marks1 = imread('Watermark_CityUHK.bmp');
Marks1 = imresize(Marks1,[110,110]);

for i=1:7;
watermarked_image = imread(extracted_watermark{i});
NC(i)    = func_nc(uint8(Marks1),uint8(watermarked_image));
end

% ==========
% Type of Attacks
% ==========
Type_of_attacks = [ "Noise attack ";
    "Rotation attack ";
    "Cropping attack ";
    "Scaling attack ";
    "Pixel reduction attack ";
    "Guassian Smoothing attack ";
    "Sharpening attack "];

figure;
for j = 1 : 7; 
    this_image = imread(attacked_image{j}); 
    ax = subplot(2,7,j); 
    imshow(this_image, 'Parent', ax); 
    title(Type_of_attacks(j));
end

i = 8;

for j = 1 : 7; 
    this_image = imread(extracted_watermark{j});
    ax = subplot(2,7,i); 
    
    Array_str =  sprintf('%s%0.5f','NCC: ', NC(j));
    J_2 = insertText(uint8(this_image), [10 90], Array_str,'FontSize',14);
    
    imshow(J_2, 'Parent', ax); 
    title(Type_of_attacks(j));
    set(gcf, 'Position', [1200, 400, 1200, 400]);
    i = i + 1;
end



