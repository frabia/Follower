fc =44100;
sinc = 1/fc;
winsize= 1024;
binsize=fc/winsize;


A= 0;
f=binsize*1;
dur=0.5;
t=[0:sinc:dur];

ampEnvSig=0.5+(0.5*cos(2*pi*0.5*t));
ampEnv=A.+ampEnvSig; %Modulante per l'ampiezza

phiEnvSig=5*sin(2*pi*5*t);
phiEnv=f.+phiEnvSig; %Modulante per la fase

w=f*2*pi;
phi=0;
F=[-fc/2:binsize:fc/2-binsize];

x= ampEnv.*cos(w*t.+phiEnv); %Coseno reale
y= ampEnv.*sin(w*t.+phiEnv); %Trasformata di Hilbert
z=x+j*y; %segnale analitico

zAt=abs(z); %AMPIEZZA ISTANTANEA
zPt=angle(z-w*t); %  FASE ISTANTANEA
zb=z.*(exp(-j.*w.*t)); %Segnale "BASEBAND" centrato sul DC
zbDer=zb(2:size(angle(zb),2)-1)-(zb(1:size(angle(zb),2)-2));%DEVIAZIONE DI FREQUENZA
    


%pWrap = unwrap(zbDer);

for n=1:winsize
    c1=exp(-i*(2*pi*F(n)*t)); 
    output1=sum(x.*c1);
    mag1(n)=20*log10(2*(abs(output1)/winsize));
    fasitot1(n)=arg(output1);
    fasi1(n)=0;
    if mag1(n) > 0.05
        fasi1(n)=fasitot1(n);
    end    
end
for k=1:winsize
    c=exp(-i*(2*pi*F(k)*t)); 
    output=sum(z.*c);
    mag(k)=20*log10(2*(abs(output)/winsize));
    fasitot(k)=arg(output);
    fasi(k)=0;
    if mag(k) > 0.05
        fasi(k)=fasitot(k);
    end    
end


figure(1)
plot (F, fasi)
axis ([-(f*10),f*10, -pi, pi])
title("FASE di z")

figure(2)
plot (F, mag)
axis([-(f*10),f*10, -100, 20])
title("MAGNITUDINE di z")

figure(3)
plot (t,z)
axis ([0,0.5, -1, 1])
title("Z=SEGNALE ANALITICO")

figure(4)
plot (t,zAt)
axis ([0,1, -1, 1])
title("INV AMP di z")

tder=[1:size(t,2)-2];
figure(5)
plot (tder,zbDer)
%axis ([0,0.5, -pi, pi])
title("INV FREQ di z")

figure(6)
plot (F, fasi1)
axis ([-(f*10),f*10, -pi, pi])
title("FASE DI x")

figure(7)
plot (F, mag1)
axis ([-(f*10),f*10, -100, 20])
title("MAGNITUDINE DI x")
