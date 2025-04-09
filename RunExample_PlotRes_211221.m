
% resfd=fullfile(imfd,'MorphologyRes01');
resfd='';

xlsoutfd='';
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