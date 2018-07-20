 
function PSNR = func_psnr(f1,f2)

k = 8;

fmax = 2.^k - 1;
a = fmax.^2;
e = im2uint8(f1) - im2uint8(f2);
[m, n] = size(e);
b = mean(sum(sum(e.^2)));
PSNR = 10*log10(m*n*a/b);

