% intensity analysis

mainfd='220119 G1 and S phase movies ANLN-WT\';

xlsfd='';
xlsname='xypos reg.xlsx';

resoutfd=erase(xlsname,'xlsx');

directTime=0; % if the reported time frame is represent time frame (1) or sequence (0).
chnum=2; % channel number


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
     if isnan(fnum)
        continue; end
    if directTime
        fnumoff=(fnum-1)*chnum;
    else
        fnumoff=(ceil(fnum/chnum)-1)*chnum; % checking the firct channel frame id
    end
    
%     fnumoff=(fnum-1)*chnum;
%     fnumoff=(ceil(fnum/chnum)-1)*chnum; % checking the firct channel frame id
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
            Nintall={};
            
            for kc=1:chnum
            
                [NmorpProp]=get_morphprop(nbw) ;  %obtain basic morphometric                  
                [NintProp1, NintProp2]=get_intprop(nbw,double(imtmp{kc}));  % obtain intesnity   
                [NintProp3]=get_taxture(nbw,imtmp{kc});  % obtain intesnity   
                Nintall{kc}=[NintProp1,NintProp2 NintProp3];
                
%                 [CintProp1, CintProp2]=get_intprop(cbw,imtmp{kc});  % obtain intesnity   
%                 [CintProp3]=get_taxture(cbw,imtmp{kc});  % obtain intesnity 
            end
                
           %% nuclear border intensity analysis   
              rsz=3; % setting the radius mark
                nbdbw=bwmorph(nbw,'remove'); % getting nuclei boundary location
                Dnn=bwdist(nbdbw);
                bwinr=Dnn<=rsz & Dnn>0; % getting the region of interests..
                bwinrN=bwinr & nbw;
                bwinrC=bwinr & ~nbw; % cbw is removed
                
%                 resroi=zeros(max(ln(:)),4);
%                 for kll=1:max(ln(:))
                    ccn=bwinrN ;
                    ccc=bwinrC ;
                    
                    restmp=[sum(ccn(:)) sum(ccc(:)) mean(im1c(ccn)) mean(im1c(ccc)) mean(im2c(ccn)) mean(im2c(ccc))]; 
%                     resroi(kll,:)=restmp;
%                 end
                Nbdint=restmp;
                
         % outputing results matrix at individual images level..
%              dataname0=[outfdname,'_',sprintf('xy%02.0f',ki2),'.mat'];
             
%              save(fullfile(resfd0,dataname0),'Nbdint','-append');
             
             
             
%    imtmp3=imread(imfullname,fnumoff+3);            
  
             
                
                        
                        
              res=[res;[ki NmorpProp Nintall{1} Nintall{2} Nbdint]];
              % intenisty output
                        
%               intth=pns.intth;
              save(resname,'NmorpProp','Nintall','Nbdint','-append');
%               saveas(h0,figname1)
%               saveas(h0,figname2)
          end
    
end