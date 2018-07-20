function Msg = func_wk_desert_final(Mwk_1st,Blksize,RR,CC,lel);

global H;
midband=[   0,0,0,1,1,1,1,0;
            0,0,1,1,1,1,0,0;
            0,1,1,1,1,0,0,0;
            1,1,1,1,0,0,0,0;
            1,1,1,0,0,0,0,0;
            1,1,0,0,0,0,0,0;
            1,0,0,0,0,0,0,0;
            0,0,0,0,0,0,0,0;];

Mwk_pic = double(Mwk_1st);
Mw      = size(Mwk_pic,1);	         
Nw      = size(Mwk_pic,2);	         
Max_msg = Mw*Nw/(Blksize^2);
Mo      = RR;	
No      = CC;	
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


for ij = 1:Max_msg
    JS        = Mwk_pic(y:y+Blksize-1,x:x+Blksize-1);
    JS(JS<=KK)= KK;
    cs_block = JS;
    ll=1;
    for ii=1:Blksize
        for jj=1:Blksize
            if midband(jj,ii)==1
               sequence(ll) = cs_block(jj,ii);
               ll           = ll + 1;
            end
        end
    end
    
    correlation(ij) = corr2(Pn_seq,sequence);
    if (x+Blksize) >= Nw
        x=1;
        y=y+Blksize;
    else
        x=x+Blksize;
    end
end

for ij=1:Max_msg
    if correlation(ij) > 2*mean(correlation(1:Max_msg))
       message_vector(ij) = 0;
    else
       message_vector(ij) = 1;
    end
end
Msg = reshape(message_vector(1:RR*CC),RR,CC);
