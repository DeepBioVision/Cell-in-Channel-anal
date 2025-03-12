tic;
[fname,pname]=uigetfile({'*.dat';'*.*'},'pick a file');
fname=fullfile(pname,fname);
% fname='013118 Rango3 oocytes oo12_OFLIM ascii.dat';
T = readtable(fname);
dat=table2array(T);
figure(1);
cid=jet(100);
cid=[[0 0 0];cid(end:-1:1,:)];

dat(dat==0)=nan;
minT=min(dat(~isnan(dat)));
maxT=max(dat(:));
medT=median(dat(~isnan(dat)));
stdT=std(dat(~isnan(dat)));
r=[48 49];
lr=prctile(dat(~isnan(dat)),50-r(1));
hr=prctile(dat(~isnan(dat)),50+r(2));




% imagesc(dat,[medT-rr(1)*stdT medT+rr(2)*stdT]);
imagesc(dat,[lr hr]);
colormap(cid);
axis equal
axis off;
colorbar
imcontrast
toc;

