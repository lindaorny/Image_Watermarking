function Marks = func_im2bw(I0);

[R,C] = size(I0);
Marks = I0;

for i = 1:R
    for j = 1:C
        if I0(i,j)>=230
           Marks(i,j) = 1; 
        else
           Marks(i,j) = 0;   
        end
    end
end




