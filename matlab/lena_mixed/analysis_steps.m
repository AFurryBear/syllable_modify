% in a new folder
% make a batch file
lt_make_batch(1)

% random subsample
lv_randsample_batch('batch.keep',15,9)

%label those songs
evsonganaly('batch.keep.lvrand.keep')

%count number of patterns
patterns = {'dss' '-a' 't'};
cntpattern = lv_calctransprob('batch.keep.lvrand.keep',patterns);

figure
bar(cntpattern)
set(gca,'xtick',1:length(patterns),'xticklabel',patterns)