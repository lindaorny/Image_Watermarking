function [I0,I1] = func_read_images(I0,I1);


[R0,C0,K0] = size(I0);
[R1,C1,K1] = size(I1);
if K0 == 3
   I0 = (rgb2gray(I0)); 
else
   I0 = (I0);  
end
if K1 == 3
   I1 = (rgb2gray(I1)); 
else
   I1 = (I1);  
end


