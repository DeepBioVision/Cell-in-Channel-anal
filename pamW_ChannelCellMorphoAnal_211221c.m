
% this is customized for \\babyserverdw5\Pei-Hsun Wu\collaboration\petr\211221 cell cycle GFP ANNLN time series
% parameter setting
mainfd='\\babyserverdw5\Pei-Hsun Wu\collaboration\petr\210927 HT1080 P25 ANLN-WT p25 G1 30min recovery';
% xmlfd='\\babyserverdw5\Pei-Hsun Wu\collaboration\petr\211116 Nuclear morphology analysis cell in channel\Confined migration GFP-ANLN, NLS-mCherry\211021 S phase series 1 movies\clicking';
xlsfd='\\babyserverdw5\Pei-Hsun Wu\collaboration\petr\210927 HT1080 P25 ANLN-WT p25 G1 30min recovery';
xlsname='xypos_092721 HT1080 P25 ANLN-WT p25 G1 30min recovery xyt.xlsx';
resoutfd=erase(xlsname,'xlsx');

chnum=[2]; % channel number
% px=630.42/1024; % pixel size

% px=0.615;
% px=0.612;
px=1;

directTime=1; % if the reported time frame is represent time frame (1) or sequence (0).
nocheck=0; % won't check for segmetnation. but will output.

objoi=[29:56]; % if empty. running through all images.
% load library
    path(path,'\\babyserverdw3\pw cloud\MATLAB\wph toolbox\cell counting');
    path(path,'\\babyserverdw3\pw cloud\MATLAB\wph toolbox\htCPw1005\htcp image Processing');
    path(path,'\\babyserverdw3\pw cloud\MATLAB\wph toolbox\PIV WU_toolbox');
    path(path,'\\babyserverdw3\pw cloud\MATLAB\wph toolbox\htCPw1005\htcp image Processing\phenotyping estimator');

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

if ~isfolder(fullfile(resfd,'fig'))
    mkdir(fullfile(resfd,'fig')); end
% get image list
% imlist=dir(fullfile(imfd,'*.tif'));
% imnum=length(imlist);


res=[];
if isempty(objoi)
% objoi=[15 66];
    objoi=1:objnum;
end
% imoi=1;

for ki0=1:length(objoi)   
    
    ki=objoi(ki0);
    fprintf('\nworking on objID %03.0f...',ki);
    % read images info
    imfullname=fullfile(all{ki+1,col_imfd},all{ki+1,col_imname});    
    iminfo=imfinfo(imfullname);

  % read annotation locations.
%     xmlfile=['cellcounter_',erase(imlist(ki).name,'.tif'),'.xml'];
    % check if exist
%     if ~exist(fullfile(xmlfd,xmlfile),'file')
%         fprintf('\nThis xml file not exist -- %s',xmlfile);
%         continue;
%     end
        
%     [types,loc]=ReadCellCounterxmlPW(xmlfd, xmlfile);
%      fnum=loc(1,3);
    fnum=t(ki);
    
    if isnan(fnum)
        continue; end
    if directTime
        fnumoff=(fnum-1)*chnum;
    else
        fnumoff=(ceil(fnum/chnum)-1)*chnum; % checking the firct channel frame id
    end
    xyoi=round([x(ki) y(ki)]/px);
%     imname1=sprintf('t%03.0fxy%02.0fc%1.0f.tif',fnum,xy(ki),1);
%     imname2=sprintf('t%03.0fxy%02.0fc%1.0f.tif',fnum,xy(ki),2);
%     imname3=sprintf('t%03.0fxy%02.0fc%1.0f.tif',fnum,xy(ki),3);

   imtmp1=imread(imfullname,fnumoff+1);
   imtmp2=imread(imfullname,fnumoff+2);
%    imtmp3=imread(imfullname,fnumoff+3);
     


    % nuceli detection and segment
    % set segmentation parameters
      pns.PreSegSmooth=0; % pre-segmentaiont smoothing of image switch
            pns.objszr=15; % object radius. used in bpass
            pns.intth=100; % intenisty threshold
             pns.maxareaN=inf; % max allowed object size (inf)
             pns.minareaN=150; % min required object size
             pns.FindSeedMethod='invbp'; % OPTION WITH 'pkfnd', or 'gblur','invbp'
                 pns.rsf=2;         
                 pns.gblur_lb=3;
                 pns.gblur_hb=11;
                 pns.minextendsz=2;
                   pns.invbpSz=5;
                   pns.invbpthres=1;
                   pns.invbpOpenSz=3;
                   pns.invbpErodeSz=3;
                   pns.invbpExtendMinSz=2;

             pns.LocalGradientMethod='Invbpass'; % options : 'bpass','gradient','custom' 'Invbpass'
                pns.GradientLengthScale=15; 
             pns.ExtractNearBoarderGraident=0; % only use near boundary region gradienet info
                pns.Length_ENBG=5;
             pns.SegMethod='watershed'; % options: 'watershed','localflood'   
                pns.PriorSegDilateSize=5; % apply dilation to increase the signal region.    
            pns.showresim=0; % show segmented images    
            
%              msk0=imerode(msk0,ones(31));
% 

   figure(55); clf;
     fh=scrsz(4)*0.3; 
     fw= fh*3; % set size of figure
     fh=round(fh); fw=round(fw);
     offh=scrsz(4)*0.0;
     offw=scrsz(3)*0;
     ra=100;
    set(gcf,'position',[(scrsz(3)-fw)/2+offw (scrsz(4)-fh)/2+offh fw fh])
    
    subplot(1,3,1);
        imagesc(imtmp1); hold on;
        plot(xyoi(1),xyoi(2),'g+','markersize',8);     
        axis equal; axis off;
        xlim([xyoi(1)-ra xyoi(1)+ra]);
        ylim([xyoi(2)-ra xyoi(2)+ra]);
        titletag=sprintf('poi%03.0f-ch1',ki);
%         titletag=strrep(titletag,'_','\_');
%             titletag=strrep(titletag,'_','\_');
%            titletag=strjoin({titletag,ch2use},'-');
        title(titletag);
    subplot(1,3,2);
        imagesc(imtmp2); hold on;
        plot(xyoi(1),xyoi(2),'g+','markersize',8);     
        axis equal; axis off;
        xlim([xyoi(1)-ra xyoi(1)+ra]);
        ylim([xyoi(2)-ra xyoi(2)+ra]);
        titletag=sprintf('poi%03.0f-ch2',ki);
%         titletag=strrep(titletag,'_','\_');
        title(titletag);
       imtemp=single(imtmp2); % set default channel 2 use. 
       ch2use='ch2';
% maybe deciding segmentation channel...
    if ~nocheck 
       ch2use=[];
       ch2use = questdlg('which channel to use?', ...
                    'set seg channel', ...
                    'ch1','ch2','ch1');
    %             set(gcf,'position',[50 600 100 100])
    %     ch2use=uiconfirm(gcf,'which channel to use?', ...
    %                 'set seg channel', ...
    %                 'ch1','ch2','ch1');
    
    end
       
           if isempty(ch2use)
               return; end
       switch ch2use
            case('ch1')
                imtemp=single(imtmp1);
            case('ch2')
                imtemp=single(imtmp2);            
       end
       
    
%     imtemp=single(imtemp1);
      while 1>0 % while loop for segmentaiton nucleus. selection the yes or no to get out.
        isgood=0;    
         disp(pns.intth)
           nbw0=SegNucleiW_v21_211018(imtemp,[],pns);
%              nbw0=imopen(nbw0,mskcircle(11));
 
          ln=bwlabel(nbw0); 
          ind=sub2ind(size(nbw0),xyoi(2),xyoi(1));
          nid=ln(ind);
          
          
          figure(55);
          subplot(1,3,3);
          imagesc(imtemp); hold on;
          
%           fh=scrsz(4)*0.25; 
%           fw= fh*1.0; % set size of figure
%           fh=round(fh); fw=round(fw);
%           offh=scrsz(4)*0.1;
%           offw=scrsz(3)*0.1;
%           set(gcf,'position',[(scrsz(3)-fw)/2+offw (scrsz(4)-fh)/2+offh fw fh])
    
           plot(xyoi(1),xyoi(2),'g+','markersize',8);            
           axis equal; axis off;
           xlim([xyoi(1)-ra xyoi(1)+ra]);
           ylim([xyoi(2)-ra xyoi(2)+ra]);
%            titletag=erase(imlist(ki).name,'.tif');
           titletag=sprintf('poi%03.0f',ki);
           titletag=strrep(titletag,'_','\_');
           titletag=strjoin({titletag,ch2use},'-');
           title(titletag)
          
           if nid>0
              nbw=ln==nid;
              bd=bwboundaries(nbw);
              plot(bd{1}(:,2),bd{1}(:,1),'m-','linewidth',1.0)
           end
            h0=gcf;
              
            if nocheck
                break
            end
           % decide good or bad..
           answer=[];
           answer = questdlg('Thuning threshold?', ...
                'check', ...
                'No need','Upthreshold','Downthreshold','No need');
            if isempty(answer)
                return; end
            
              switch answer
                  case 'No need'
                      break
                  case 'Upthreshold'                    
                     pns.intth= pns.intth*1.1;
                  case 'Downthreshold'                    
                     pns.intth= pns.intth*0.9;
              end
              
      end  
      if nocheck
          isgood=9;
      else
            answer = questdlg('Is result good?', ...
                'check', ...
                'yes','No','not sure','yes');
            
            if isempty(answer)
                disp('run end...');
                return; end
            % Handle response
            switch answer
                case 'yes'                    
                    isgood=1;
%                     break
                case 'No'                    
                    isgood=0;
%                     break
                case 'not sure'                                         
                    isgood=9;                
            end
      end
         
          if nid>0
              nbw=ln==nid;
              [NmorpProp]=get_morphprop(nbw) ;  %obtain basic morphometric    
              res=[res;[ki NmorpProp]];
              
              % write results;
              resnametag=sprintf('poi%03.0f',ki);
%               resnametag=erase(imlist(ki).name,'.tif');
              resname=fullfile(resfd,[resnametag,'.mat']);
              figname1=fullfile(resfd,'fig',[resnametag,'.fig']);
              figname2=fullfile(resfd,'fig',[resnametag,'.png']);
%               intth=pns.intth;
              save(resname,'nbw','NmorpProp','ki','imfullname','isgood','ch2use','xyoi','fnum','pns');
              saveas(h0,figname1)
              saveas(h0,figname2)
          end
    
end