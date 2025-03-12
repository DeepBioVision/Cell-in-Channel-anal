% imfd='\\babyserverdw5\Pei-Hsun Wu\collaboration\petr\211116 Nuclear morphology analysis cell in channel\Confined migration GFP-ANLN, NLS-mCherry\211021 S phase series 1 movies';
% xmlfd='\\babyserverdw5\Pei-Hsun Wu\collaboration\petr\211116 Nuclear morphology analysis cell in channel\Confined migration GFP-ANLN, NLS-mCherry\211021 S phase series 1 movies\clicking';

% resfd=fullfile(imfd,'MorphologyRes01');
resfd='\\babyserverdw5\Pei-Hsun Wu\collaboration\petr\211207 Nuclear morphology analysis cell in channel set 2\MorphRes\xypos_102121 nuclear entry HT1080 P19 ANLN-WT hydroxyurea S-sync';

xlsoutfd='\\babyserverdw5\Pei-Hsun Wu\collaboration\petr\211207 Nuclear morphology analysis cell in channel set 2';
xlsname2='result tmp3.xlsx';

reslist=dir(fullfile(resfd,'*.mat'));
resnum=length(reslist);
res=[];
rescheck=[];
reski=[];
for kr=1:resnum
    r=load(fullfile(reslist(kr).folder,reslist(kr).name));
    rescheck(kr)=r.isgood;
    res(kr,:)=r.NmorpProp;
    reski(kr)=r.ki;
end

xlswrite(fullfile(xlsoutfd,xlsname2),reski(:),'res','A2')
xlswrite(fullfile(xlsoutfd,xlsname2),rescheck(:),'res','B2')
xlswrite(fullfile(xlsoutfd,xlsname2),res,'res','C2')

rescheck=rescheck(:)==1;
figure; 
plot(res(rescheck,3),res(rescheck,10),'bs')