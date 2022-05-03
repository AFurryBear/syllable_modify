% read all names in batch.keep and make one filename per label cell array

allspecdurs = [];

allfilenames = {};
alllabels = [];
allspecs_test = [];
specmtx = [];
cnt = 0; %check: how manu syllables too long
allonsets = [];
alloffsets = [];
% go through all date folders
% for i = 1:length(dates)
%     fprintf('working on %d \n',dates(i))
%     cd(num2str(dates(i)))
    filenames = lv_readbatch('batch.keep');
    filenames = {filenames(:).fname};
    
    % load all notmat files in batch
    for j = 1:length(filenames)
        allpsds = [];

        load([filenames{j} '.not.mat'])
            fprintf('working on %s \n',filenames{j})

    
         
            
        %load each syllable
        for k = 1:length(labels)
            allfilenames = [allfilenames; filenames(j)];
           
        end
    end
    

