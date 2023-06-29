clc;
clear all;
close all;

%%% Data
z=readmatrix("D:\K-means\kmeansdata.csv"); % Silakan sesuaikan dengan
                                           % direktori pada komputer Anda
x=double(z(:,1));
y=double(z(:,2));

%%% Kode untuk K-means
figure;
plot(x,y,'b.','linewidth',1);
xlabel('x');
ylabel('y');
title('Titik-titik Tengah Kelompok Awal menggunakan K-means');
hold on;

k=3;
pos = [];
startx = [];
starty = [];
center = zeros(3,2);
for i=1:3
    pos(i) = randi(length(x));
    startx(i)=x(pos(i));
    starty(i)=y(pos(i));
    center(i,:)=[startx(i) starty(i)];
    plot(center(i,1),center(i,2),'ko','linewidth',2);
end
grid on;
hold off;

cluster1=[];
cluster2=[];
cluster3=[];

while (~isequal(cluster1,cluster1) ...
        & ~isequal(cluster2,cluster2) ...
        & ~isequal(cluster3,cluster3)) ...
        | (isempty(cluster1) ...
        & isempty(cluster2) ...
        & isempty(cluster3))
    for i=1:length(x)
        tx = x(i);
        ty = y(i);
        jarak = sqrt((tx - center(:, 1)).^ 2 + (ty - center(:, 2)).^ 2);
        [minJarak, Index(i)] = min(jarak);
        if Index(i)==1
            cluster1=[cluster1;[tx ty]];
        elseif Index(i)==2
            cluster2=[cluster2;[tx ty]];
        else
            cluster3=[cluster3;[tx ty]];
    end
end

center(1,1)=mean(cluster1(:,1));
center(1,2)=mean(cluster1(:,2));

center(2,1)=mean(cluster2(:,1));
center(2,2)=mean(cluster2(:,2));

center(3,1)=mean(cluster3(:,1));
center(3,2)=mean(cluster3(:,2));
end

figure;
hold on;
plot(cluster1(:,1),cluster1(:,2),'r.','linewidth',1);
plot(cluster2(:,1),cluster2(:,2),'b.','linewidth',1);
plot(cluster3(:,1),cluster3(:,2),'m.','linewidth',1);
plot(center(:,1),center(:,2),'ko','linewidth',2);
legend({'Kelompok 1','Kelompok 2','Kelompok 3','Titik-titik tengah'},...
    'Location','southwest');
grid on;
xlabel('x');
ylabel('y');
title('Pengelompokan dengan K-means');

%%% Kode untuk K-means++
figure;
plot(x,y,'b.','linewidth',1);
xlabel('x');
ylabel('y');
title('Titik-titik Tengah Kelompok Awal menggunakan K-means++');
hold on;
m=[];
pos = randi(length(x));
startx=x(pos);
starty=y(pos);
center=[startx starty];
d=[];
r=1;
while(r~=k)
for i=1:length(x)
    g=[x(i) y(i)];
    ka=dsearchn(center,g);
    nearestx=center(ka,1);
    nearesty=center(ka,2);
    distance=sqrt((nearestx-g(1))^2+(nearesty-g(2))^2);
    d=[d distance];
end
[e s]=max(d);
center=[center;[x(s) y(s)]];
x(s)=[];
y(s)=[];
[r c]=size(center);
d=[];
end
disp(center);

plot(center(1,1),center(1,2),'ro','linewidth',2);
plot(center(2,1),center(2,2),'go','linewidth',2);
plot(center(3,1),center(3,2),'mo','linewidth',2);

grid on;
hold off;
x=double(z(:,1));
y=double(z(:,2));
cx=center(:,1);
cy=center(:,2);
mean_oldx=cx;
mean_newx=cx;
mean_oldy=cy;
mean_newy=cy;
outputx=cell(k,1);
outputy=cell(k,1);
temp=0;
while(temp==0)
    mean_oldx=mean_newx;
    mean_oldy=mean_newy;
    for ij=1:length(x)
        mina=[];
        mu=x(ij);
        nu=y(ij);
     for mk=1:length(cx)
         mina=[mina sqrt((mu-cx(mk))^2+(nu-cy(mk))^2)];
     end
     [gc index]=min(mina);
     outputx{index}=[outputx{index} mu];
     outputy{index}=[outputy{index} nu];
    end
    gmckx=[];
    gmcky=[];
    for i=1:k
        gmckx=[gmckx mean(outputx{i})];
        gmcky=[gmcky mean(outputy{i})];
    end
    cx=gmckx;
    cy=gmcky;
    mean_newx=cx;
        mean_newy=cy;
        gum=0;
        bum=0;
    if(mean_newx==mean_oldx)
        gum=1;
    end
    if(mean_newy==mean_oldy)
        bum=1;
    end
    if(gum==1 && bum==1)
        temp=1;
    else
            outputx=cell(k,1);
            outputy=cell(k,1);
    end
end
celldisp(outputx);
celldisp(outputy);
figure;
for i=1:k
    x=outputx{i};
    y=outputy{i};
    if(i==1)
        plot(x,y,'r.','linewidth',1);
    elseif(i==2)
        plot(x,y,'b.','linewidth',1);
    else
        plot(x,y,'m.','linewidth',1);
    end
    hold on;
    grid on;
end
plot(cx,cy,'ko','linewidth',2);
legend({'Kelompok 1','Kelompok 2','Kelompok 3','Titik-titik tengah'},...
    'Location','southwest');
xlabel('x');
ylabel('y');
title('Pengelompokan dengan K-means++');
