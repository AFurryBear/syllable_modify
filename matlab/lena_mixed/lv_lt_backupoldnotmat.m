function i = lv_lt_backupoldnotmat()

%% make folder to save backups of old notmats
tstamp=lt_get_timestamp(0);

OldNotMatdir=['OldNotMat_moved_' tstamp];
mkdir(OldNotMatdir);
fn = dir('*not.mat');
for i = 1:length(fn)
        eval(['!cp ' fn(i).name ' ' OldNotMatdir]);
end