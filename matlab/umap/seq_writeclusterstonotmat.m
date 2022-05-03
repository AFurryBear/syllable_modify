function seq_writeclusterstonotmat(allfilenames,clus)
% ! have not tested this yet

% convert matrix of clusters from umap back into notmat files
% has: allfilenames array of filenames
% allonsets, allofsets
% clus: vector of clusters

ufns = unique(allfilenames);

alllabels = char(clus+97); %convert to letters;

for i = 1:length(ufns)
    fileix = cellfun(@(x) strcmp(x,ufns{i}),allfilenames);
    load([ufns{i} '.not.mat']) % get threshold and min dur min int Fs sm_win from old file
    
%     onsets = allonsets(fileix);
%     offsets = alloffsets(fileix);
    labels = alllabels(fileix);
    
    
    save([ufns{i} '.not.mat'],'min_int','Fs','min_dur','sm_win','onsets','offsets','threshold','labels');
    
end