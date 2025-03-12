% intensity analysis
% this is customized for \\babyserverdw5\Pei-Hsun Wu\collaboration\petr\211221 cell cycle GFP ANNLN time series
% parameter setting
mainfd='\\babyserverdw5\Pei-Hsun Wu\collaboration\petr\211221 cell cycle GFP ANNLN time series\';
% xmlfd='\\babyserverdw5\Pei-Hsun Wu\collaboration\petr\211116 Nuclear morphology analysis cell in channel\Confined migration GFP-ANLN, NLS-mCherry\211021 S phase series 1 movies\clicking';
xlsfd='\\babyserverdw5\Pei-Hsun Wu\collaboration\petr\211221 cell cycle GFP ANNLN time series\';
xlsname='location registeration 101921 S1C1.xlsx';
resoutfd=erase(xlsname,'xlsx');

chnum=2; % channel number
% px=630.42/1024; % pixel size
% px=0.612;
px=1;
nocheck=0; % won't check for segmetnation. but will output.



% read xls file
%     xlsfd=fullfile(imfd,xlsfd);
    [num,~,all]=xlsread(fullfile(xlsfd,xlsname));
        xcol=strcmpi(all(1,:),'x');   
        x=cell2mat(all(2:end,xcol));
        xcol=strcmpi(all(1,:),'y');   
        y=cell2mat(all(2:end,xcol));
        xcol=strcmpi(all(1,:),'t');   
        t=cell2mat(all(2:end,xcol));
        xcol=strcmpi(all(1,:),'xy');   
        xy=cell2mat(all(2:end,xcol));
        col_imfd=strcmpi(all(1,:),'imfd'); 
        col_imname=strcmpi(all(1,:),'imname'); 
        xyt=[x(:) y(:) t(:)];
    objnum=length(x);
% initializatino

resfd=fullfile(mainfd,'MorphRes',resoutfd);

% get dispaly screen pixel.
set(0,'units','pixels') ;
scrsz = get(0,'screensize');

% get image list
% imlist=dir(fullfile(imfd,'*.tif'));
% imnum=length(imlist);


res=[];

% objoi=[15 66];
objoi=1:objnum;
% imoi=1;

for ki0=1:length(objoi)   
    
    ki=objoi(ki0);
     resnametag=sprintf('poi%03.0f',ki);
%     resnametag=erase(imlist(ki).name,'.tif');
    resname=fullfile(resfd,[resnametag,'.mat']);
    if ~exist(resname,'file')
        continue; end
%     load(resname,'nbw','NmorpProp','ki','imfullname','isgood','ch2use','xyoi','fnum','pns');
    load(resname);
    
    fprintf('\nworking on objID %03.0f...',ki);
    % read images info
    imfullname=fullfile(all{ki+1,col_imfd},all{ki+1,col_imname});    
    iminfo=imfinfo(imfullname);


    fnum=t(ki);
    
    if isnan(fnum)
        continue; end
%     fnumoff=(fnum-1)*chnum;
    fnumoff=(ceil(fnum/chnum)-1)*chnum; % checking the firct channel frame id
    xyoi=round([x(ki) y(ki)]/px);

      if sum(nbw(:)>0)
           imtmp1=imread(imfullname,fnumoff+1);
           imtmp2=imread(imfullname,fnumoff+2);

           % background correct
             BkgMorpSz=31;
                bkg1=imopen(imresize(imtmp1,0.1),mskcircle(BkgMorpSz));
                bkg1=medfilt2(bkg1,[BkgMorpSz BkgMorpSz],'symmetric');
                bkg1=imresize(bkg1,size(imtmp1));

                bkg2=imopen(imresize(imtmp2,0.1),mskcircle(BkgMorpSz));
                bkg2=medfilt2(bkg2,[BkgMorpSz BkgMorpSz],'symmetric');
                bkg2=imresize(bkg2,size(imtmp2));
        
        
            im1c=single(imtmp1)-single(bkg1);
%             imC=single(im1s);
            im2c=single(imtmp2)-single(bkg2);          
      
            imtmp{1}=im1c;
            imtmp{2}=im2c;
%             Nintall={};
            
                                   
                        
              res=[res;[ki NmorpProp Nintall{1}(:,[1 10]) Nintall{2}(:,[1 10]) Nbdint]];
              % intenisty output
                        
%               intth=pns.intth;
%               save(resname,'NmorpProp','Nintall','Nbdint','-append');
%               saveas(h0,figname1)
%               saveas(h0,figname2)
          end
    
end
xlswrite('tmpres.xlsx',res)