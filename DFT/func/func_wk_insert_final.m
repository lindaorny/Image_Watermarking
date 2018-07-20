function [mwk_image2,mwk_image3] = func_wk_insert_final(I0,Marks1,Power,Blksize,RR,CC);

global H;
midband=[   0,0,0,1,1,1,1,0;
            0,0,1,1,1,1,0,0;
            0,1,1,1,1,0,0,0;
            1,1,1,1,0,0,0,0;
            1,1,1,0,0,0,0,0;
            1,1,0,0,0,0,0,0;
            1,0,0,0,0,0,0,0;
            0,0,0,0,0,0,0,0;];
        
Images0 = double(I0);
Mc      = size(Images0,1);	        
Nc      = size(Images0,2);	        

Max_wk  = Mc*Nc/(Blksize^2);
Marks1  = imresize(double(255*Marks1),[RR,CC]); 

message = func_im2bw(Marks1);

Mm      = size(message,1);	                
Nm      = size(message,2);	                
message = reshape(message,1,Mm*Nm);
msg_vect                    = ones(1,Max_wk);
msg_vect(1:length(message)) = message;
mwk_image                   = Images0;
rand('state',0);

PNseq0                      = round(2*(rand(1, sum(sum(midband)))-1/2));  
LEN                         = length(PNseq0);
Ns                          = randperm(LEN);
PNseq                       = PNseq0;
for i = 1:LEN
    PNseq(i) = PNseq0(Ns(i)); 
end
 
Theta            = sign(PNseq);

x                           = 1;
y                           = 1;
% alpha                       = 100;
alpha                       = 1;
% alpha = 5;
% KK = 100;
KK = 5; 
% H=hadamard(Blksize);
for ij = 1:length(msg_vect)
    
    JS        = Images0(y:y+Blksize-1,x:x+Blksize-1);
    JS(JS<=KK)= KK;
    
    %cs_block = H*JS*H/Blksize; 
    cs_block = conj(H).*JS.*conj(H');
    Ker       = 1;
   
    if msg_vect(ij)==0
       for ii=1:Blksize
           for jj=1:Blksize
               if midband(jj,ii)==1
                  JND = Power;
                  if Theta(Ker) > 0
                     cs_block(jj,ii) = cs_block(jj,ii)+alpha*JND;
                  end
                  if Theta(Ker) == 0
                     cs_block(jj,ii) = alpha*cs_block(jj,ii);
                  end                  
                  if Theta(Ker) < 0
                     cs_block(jj,ii) = cs_block(jj,ii)-alpha*JND;
                  end                  
                  Ker              = Ker + 1;
               end
           end
       end
    end
      
%     mwk_image(y:y+Blksize-1,x:x+Blksize-1) = H'*cs_block*H'/Blksize;
      
    mwk_image(y:y+Blksize-1,x:x+Blksize-1)  = JS;
    mwk_images(y:y+Blksize-1,x:x+Blksize-1) = abs(conj(H').*cs_block.*conj(H));
    
    if (x+Blksize) >= Nc
        x=1;
        y=y+Blksize;
    else
        x=x+Blksize;
    end
end
%  mwk_image2 = uint8(mwk_image);

noise0     = 1e-8*randn(size(mwk_image));
% mwk_image2 = double(mwk_image2) + noise0;
mwk_image2 = uint8(mwk_image);
mwk_image2 = double(mwk_image2)+noise0;

% mwk_image3 = uint8(mwk_images);
mwk_image3 = (mwk_images)+noise0;
