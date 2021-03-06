%X=a+(b-a)R
%R is a random number from the uniform dist. [0 1]
%X is going to be / [-1 1]
%X should be Weibull according to the paper of He. not uniform

DOIv=0.1;
%a=-1*ones(360,1);
%b=ones(360,1);
%RAND=a+((b-a).*rand(360,1)); %Generates uniform dist [-1 1]
%a=beta=1.01, b=alfa=0.17
%a=0.67 b=0.16
beta=1.01*ones(360,1); 
alfa=0.17*ones(360,1); 
RANDt=rand(360,1);
RAND=alfa.*((-log(RANDt)).^(1./beta));

%We are going to generate 360 values which belong to the different 360 i
%directions
K=zeros(360,1);
for i=1:360
    if i==1
        K(i,1)=1; %Ki=1, i=1
    else
        if mod(i,2)==0
            K(i,1)=K(i-1,1)+(RAND(i,1)*DOIv); %Ki, for i~=1
        else
            K(i,1)=K(i-1,1)-(RAND(i,1)*DOIv); %Ki, for i~=1
        end
   end
end
K(i+1,1)=1;
t=0:pi/180:2*pi; %pi/180 equals to 1 degree
%polar(t,K');
%hold on;

X(1,:)=[0 0];
X(2,:)=[4 1.2]; %if [+ +] then nothing
X(3,:)=[-1 0.6]; %if [- +] then 180-(abs(res))
X(4,:)=[-3 -3]; %if [- -] then 180 + res
X(5,:)=[0.5 -2]; %if [+ -] then 360-(abs(res))

%Reference distance
do=1; %[m]
%Reference power at do
P0=-37.466; %[dBm]
%Propagation exponent
np=2.3;

%for i=1:360
%    RSS(i)=P0-((10*np*log10(4.57/1)).*K(i,1));
%end
%RSS(i+1)=RSS(1);
%t=0:pi/180:2*pi;
%figure(2);
%polar(t,RSS);

%With a received power of -50 dBm, how it varies the communication range
RSSf1=-39;
RSSf2=-40;
RSSf3=-42;
for i=1:360
    if i==1
        d1(i)=do.*(10.^((P0-RSSf1)/(10*np)));
        d2(i)=do.*(10.^((P0-RSSf2)/(10*np)));
        d3(i)=do.*(10.^((P0-RSSf3)/(10*np)));
    else
        d1(i)=do.*(10.^((P0-RSSf1)/(K(i,1)*10*np)));
        d2(i)=do.*(10.^((P0-RSSf2)/(K(i,1)*10*np)));
        d3(i)=do.*(10.^((P0-RSSf3)/(K(i,1)*10*np)));
    end
end
%DMIN=min(d1)
%DMAX=max(d1)
for i=1:360
        r1(i)=do.*(10.^((P0-RSSf1)/(10*np)));
        r2(i)=do.*(10.^((P0-RSSf2)/(10*np)));
        r3(i)=do.*(10.^((P0-RSSf3)/(10*np)));
end
d1(i+1)=d1(1);
d2(i+1)=d2(1);
d3(i+1)=d3(1);
r1(i+1)=r1(i);
r2(i+1)=r2(i);
r3(i+1)=r3(i);
t=0:pi/180:2*pi; %pi/180 equals to 1 degree
figure(2);
polar(t,d1,'-r');
hold on;
polar(t,r1,'-r');
hold on;
polar(t,d2,'-b');
hold on;
polar(t,r2,'-b');
hold on;
polar(t,d3,'-g');
hold on;
polar(t,r3,'-g');

