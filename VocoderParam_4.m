clear all;

fc =44100;
sinc = 1/fc;
winsize= 1024;
binsize=fc/winsize;

A= 0;
fcos=binsize*2;
dur=1;
%t=[0:sinc:dur];
ttot=[-dur/2:sinc:dur/2-sinc];
tsize = size(ttot, 2);
t = ttot((tsize/2)-(winsize/2):(tsize/2)+(winsize/2)-1);

phi=0;
wcos=2*pi*fcos;

ampEnvSig=0.5*sin(2*2*pi*t);
ampEnv=A.+ampEnvSig;

phiEnvSig=40*sin(0.7*2*pi*t);
phiEnv=phi.+phiEnvSig;

%sig=ampEnv.*cos((wcos.*t).+phiEnv); %Coseno reale
sig=0.7*cos((wcos*t)+pi/2); %Coseno reale

F=[0:binsize:fc-binsize];

xfft=zeros(1,winsize);
xoff=zeros(1,winsize);
xh=zeros(1,winsize);
out=zeros(1,winsize);

overlap=4;
hopsize=winsize/overlap;
N=length(sig)/hopsize-1;
h=hanning(hopsize)';

for k=1:N
    xhop=(k-1)*hopsize;
    xoff=sig(xhop+1:xhop+hopsize);
    xh=xoff.*h;
    xfft=fft(xh);
    ixfft=ifft(xfft);
    out(xhop+1:xhop+hopsize)=real(ixfft) + ixfft(xhop+1:xhop+hopsize);
    %out(xhop+1:xhop+hopsize)=real(ixfft) + ixfft(xhop+1:xhop+hopsize);

end
for n=1:winsize   
    
    %x=sigfft(n);
    %w(n)=2*pi*f(n);
    
    
    %xPos(n)=exp(j*w(n));
    %xNeg=exp(-j*w(k)*t);
    
    %yPos=exp(-j*(pi/2))*exp(j*w(k)*t);
    %yNeg=exp(j*(pi/2))*exp(-j*w(k)*t);
    
    %zPos=xPos(k).+j*yPos(k);
    %zNeg=xNeg(k).+j*yNeg(k);
    
    %z=zPos;
    
    %zAt=abs(z); %AMPIEZZA ISTANTANEA - Envelope Follower - demodulazione
    %zPt=angle(z-w); %  FASE ISTANTANEA

    %zb=z*(e^(-j*w)); %Segnale "BASEBAND" centrato sul DC
    %zbDer(k)=zb(k)(2:size(angle(zb(k)),2)-1)-(zb(k)(1:size(angle(zb(k)),2)-2)); %DEVIAZIONE DI FREQUENZA
    
end


figure(1)
plot (F, xfft)
axis ([-binsize*3, binsize*10, 0, 5])
%title("FASI sig in")

%figure(2)
%plot (F, 20*log10(mag))
%axis ([-fc/2, fc/2, -70, 0])
%title("MAGNITUDINE sig in")

%figure(3)
%plot (t,sig)
%axis ([0, winsize, -1, 1])
%title("SEGNALE ANALIZZATO")

%figure(4)
%plot (t,xarr)
%axis ([0,dur, -1, 1])
%title("Z")

%tder=[1:size(t,2)-2];
%figure(5)
%plot (tder,zbDer)
%axis ([0,0.5, -pi, pi])
%title("FREQ FOLL")

%figure(6)
%plot (t,sig)
%axis ([0,0.5, -pi, pi])
%title("SEGNALE")