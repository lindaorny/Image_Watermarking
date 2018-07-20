clc;
clear all;
addpath 'jpegcompression/'
I = imread('dft.bmp');
I1=I;
[row,coln]= size(I);
I= double(I);
%---------------------------------------------------------
% Subtracting each image pixel value by 128 
%--------------------------------------------------------
I = I - (128*ones(1024));

j = 10;
for compression_level=1:9
% quality = input('What quality of compression you require - ');
quality = j;

%----------------------------------------------------------
% Quality Matrix Formulation
%----------------------------------------------------------
Q50 = [ 16 11 10 16 24 40 51 61;
     12 12 14 19 26 58 60 55;
     14 13 16 24 40 57 69 56;
     14 17 22 29 51 87 80 62; 
     18 22 37 56 68 109 103 77;
     24 35 55 64 81 104 113 92;
     49 64 78 87 103 121 120 101;
     72 92 95 98 112 100 103 99];
 
 if quality > 50
     QX = round(Q50.*(ones(8)*((100-quality)/50)));
     QX = uint8(QX);
 elseif quality < 50
     QX = round(Q50.*(ones(8)*(50/quality)));
     QX = uint8(QX);
 elseif quality == 50
     QX = Q50;
 end
 
%----------------------------------------------------------
% Formulation of forward DCT Matrix and inverse DCT matrix
%----------------------------------------------
DCT_matrix8 = dct(eye(8));
iDCT_matrix8 = DCT_matrix8';   %inv(DCT_matrix8);

%----------------------------------------------------------
% Jpeg Compression
%----------------------------------------------------------
dct_restored = zeros(row,coln);
QX = double(QX);
%----------------------------------------------------------
% Jpeg Encoding
%----------------------------------------------------------
%----------------------------------------------------------
% Forward Discret Cosine Transform
%----------------------------------------------------------

for i1=[1:8:row]
    for i2=[1:8:coln]
        zBLOCK=I(i1:i1+7,i2:i2+7);
        win1=DCT_matrix8*zBLOCK*iDCT_matrix8;
        dct_domain(i1:i1+7,i2:i2+7)=win1;
    end
end
%-----------------------------------------------------------
% Quantization of the DCT coefficients
%-----------------------------------------------------------
for i1=[1:8:row]
    for i2=[1:8:coln]
        win1 = dct_domain(i1:i1+7,i2:i2+7);
        win2=round(win1./QX);
        dct_quantized(i1:i1+7,i2:i2+7)=win2;
    end
end
%-----------------------------------------------------------
% Jpeg Decoding 
%-----------------------------------------------------------
% Dequantization of DCT Coefficients
%-----------------------------------------------------------
for i1=[1:8:row]
    for i2=[1:8:coln]
        win2 = dct_quantized(i1:i1+7,i2:i2+7);
        win3 = win2.*QX;
        dct_dequantized(i1:i1+7,i2:i2+7) = win3;
    end
end
%-----------------------------------------------------------
% Inverse DISCRETE COSINE TRANSFORM
%-----------------------------------------------------------
for i1=[1:8:row]
    for i2=[1:8:coln]
        win3 = dct_dequantized(i1:i1+7,i2:i2+7);
        win4=iDCT_matrix8*win3*DCT_matrix8;
        dct_restored(i1:i1+7,i2:i2+7)=win4;
    end
end
I2=dct_restored;
% ---------------------------------------------------------
% Conversion of Image Matrix to Intensity image
%----------------------------------------------------------
K=mat2gray(I2);
%----------------------------------------------------------
%Display of Results
%----------------------------------------------------------
% figure(1);
% imshow(I1);
% title('original image');
% 
% figure(2);
% imshow(K);
% title('restored image from dct');
attack_mth = 'dft_compression_';
folder = '/Users/user/Documents/FYP/FYP Product/DFT/jpegcompression';
imwrite(K,fullfile(folder,sprintf('%s%d.jpg',attack_mth,j)));

global H;
midband=[   0,0,0,1,1,1,1,0;
            0,0,1,1,1,1,0,0;
            0,1,1,1,1,0,0,0;
            1,1,1,1,0,0,0,0;
            1,1,1,0,0,0,0,0;
            1,1,0,0,0,0,0,0;
            1,0,0,0,0,0,0,0;
            0,0,0,0,0,0,0,0;];

Mwk_pic = double(K);
Mw      = size(Mwk_pic,1);	         
Nw      = size(Mwk_pic,2);	         
Max_msg = Mw*Nw/(8^2);
Mo      = 110;	
No      = 110;	
rand('state',0);

Pn_seq0 = round(2*(rand(1, sum(sum(midband)))-0.5));
LEN                         = length(Pn_seq0);
Ns                          = randperm(LEN);
Pn_seq                      = Pn_seq0;
for i = 1:LEN
    Pn_seq(i) = Pn_seq0(Ns(i)); 
end
Theta   = sign(Pn_seq);

x       = 1;
y       = 1;
KK      = 5;

% H       = hadamard(Blksize);
for ij = 1:Max_msg
   
    JS        = Mwk_pic(y:y+8-1,x:x+8-1);
%     JS(JS<=KK)= KK*100;
 
    cs_block = JS;
%cs_block = JS;
    ll=1;
    for ii=1:8
        for jj=1:8
            if midband(jj,ii)==1
               sequence(ll) = cs_block(jj,ii);
               ll           = ll + 1;
            end
        end
    end
    
    correlation(ij) = corr2(Pn_seq,sequence);
    if (x+8) >= Nw
        x=1;
        y=y+8;
    else
        x=x+8;
    end
end

for ij=1:Max_msg
%     if correlation(ij) > 8*mean(correlation(1:Max_msg))
    if correlation(ij) > 0.2
       message_vector(ij) = 0;
    else
       message_vector(ij) = 1;
    end
end
Msg = reshape(message_vector(1:110*110),110,110);
dlmwrite('myFile.txt',Msg)

Msg1s     = Arnold(uint8(255*Msg),1,1); 

transform_mth = 'dft_compression_wk_';
folder = '/Users/user/Documents/FYP/FYP Product/DFT/jpegcompression';
imwrite(Msg1s,fullfile(folder,sprintf('%s%d.jpg',transform_mth,j)));

j = j+10;

end;

i = 8;

Marks1 = imread('Watermark_CityUHK.bmp');
Marks1 = imresize(Marks1,[110,110]);

Type_of_attacks = {'Compression Lv: 10',
    'Compression Lv: 20',
    'Compression Lv: 30',
    'Compression Lv: 40',
    'Compression Lv: 50',
    'Compression Lv: 60',
    'Compression Lv: 70',
    'Compression Lv: 80',
    'Compression Lv: 90'};

attacked_image = {'dft_compression_10.jpg',
    'dft_compression_20.jpg',
    'dft_compression_30.jpg',
    'dft_compression_40.jpg',
    'dft_compression_50.jpg',
    'dft_compression_60.jpg',
    'dft_compression_70.jpg',
    'dft_compression_80.jpg',
    'dft_compression_90.jpg'};

extracted_watermark = {'dft_compression_wk_10.jpg', 
    'dft_compression_wk_20.jpg', 
    'dft_compression_wk_30.jpg', 
    'dft_compression_wk_40.jpg', 
    'dft_compression_wk_50.jpg',
    'dft_compression_wk_60.jpg',
    'dft_compression_wk_70.jpg',
    'dft_compression_wk_80.jpg',
    'dft_compression_wk_90.jpg'};


for i=1:9;
watermarked_image = imread(extracted_watermark{i});
NC(i)    = func_nc(uint8(Marks1),uint8(watermarked_image));
end


figure;
for j = 1:9; 
    this_image = imread(attacked_image{j}); 
    ax = subplot(2,9,j); 
    imshow(this_image, 'Parent', ax); 
    title(Type_of_attacks(j));
end
i=10;
for j=1:9; 
    this_image = imread(extracted_watermark{j});
    ax = subplot(2,9,i); 
    
    Array_str =  sprintf('%s%0.5f','NCC: ', NC(j));
    J_2 = insertText(uint8(this_image), [10 90], Array_str,'FontSize',14);
    
    imshow(J_2, 'Parent', ax); 
    title(Type_of_attacks(j));
    set(gcf, 'Position', [1200, 400, 1200, 400]);
    i = i + 1;
end

% figure
% imshow(Msg1s,[]);
% title('Extracted Watermark');
% 
% Msg1 = imread('Watermark_CityUHK.bmp');
% Msg1 = imresize(Msg1,[110,110]);
% NC     = func_nc(uint8(Msg1s),uint8(Msg1));


% figure
% subplot(1,7,i)
% set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% set(gcf, 'Toolbar', 'none', 'Menu', 'none');
% imshow(Msg1s,[]);
% title(Type_of_attacks(i));


% end

% ----------
% Result
% ----------