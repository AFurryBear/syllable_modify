clear
close all


dates = dir;
%find those folders that start with 18
names = {dates.name};
datefolderix = cellfun(@(x) ~isempty(strfind(x,'1')),names);
dates = dates(datefolderix);


thisdir = cd;
ixix = strfind(thisdir,filesep);
% birdname = thisdir(ixix(end-1)+1:ixix(end)-1);
% exptname = thisdir(ixix(end)+1:end);


% batch = 'batch.keep';

for i = 1:length(dates)
    date = dates(i).name;
    
    cd(date)
    
    lv_lt_backupoldnotmat()
    
    cd ..
end

    