function M = Arnold(Image,Frequency,crypt) 

Q=Image; 
M = Q ; 
Size_Q   = size(Q); 

   n = 0; 
   K = Size_Q(1); 
    
   M1_t = Q; 
   M2_t = Q; 
    
   if crypt==1   
       Frequency=ArnoldPeriod( Size_Q(1) )-Frequency; 
   end 
   disp(ArnoldPeriod( Size_Q(1) ));     
   for s = 1:Frequency 
       n = n + 1; 
       if mod(n,2) == 0 
            for i = 1:K 
               for j = 1:K 
                  c = M2_t(i,j); 
                  M1_t(mod(i+j-2,K)+1,mod(i+2*j-3,K)+1) = c; 
               end 
            end 
       else 
            for i = 1:K 
               for j = 1:K 
                   c = M1_t(i,j); 
                   M2_t(mod(i+j-2,K)+1,mod(i+2*j-3,K)+1) = c; 
               end 
            end 
       end 
   end 
    
   if mod(Frequency,2) == 0 
      M = M1_t; 
   else 
      M = M2_t; 
   end 
 
    
function Period=ArnoldPeriod(N) 
if ( N<2 ) 
    Period=0; 
    return; 
end 
 
n=1; 
x=1; 
y=1; 
while n~=0 
    xn=x+y; 
    yn=x+2*y; 
    if ( mod(xn,N)==1 && mod(yn,N)==1 ) 
        Period=n; 
        return; 
    end 
    x=mod(xn,N); 
    y=mod(yn,N); 
    n=n+1; 
end