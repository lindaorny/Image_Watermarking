function NC = func_nc(A,B);


A = double(A);
B = double(B);

if size(A)~=size(B)
   error('Input vectors must be the same size!')
else
   [m,n]=size(A);
   fenzi=0;
   fenmu=0;
 
   for i=1:m
       for j=1:n
           if abs(A(i,j)-B(i,j))/255 > 0.99999
              fenzi=fenzi+1; 
           end
       end
   end
   
   NC=1-fenzi/m/n;
end



% if size(A)~=size(B)
%    error('Input vectors must be the same size!')
% else
%    [m,n]=size(A);
%    fenzi=0;
%    fenmu=0;
%    for i=1:m
%        for j=1:n
%            fenzi = fenzi+A(i,j)*B(i,j);
%            fenmu = fenmu+B(i,j)*B(i,j);
%        end
%    end
%    NC=min(fenzi/fenmu,fenmu/fenzi);
% end