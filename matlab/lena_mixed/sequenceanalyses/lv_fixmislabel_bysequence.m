function nrep = lv_fixmislabel_bysequence(batchname,oldsequence,newsequence)

% lv_lt_backupoldnotmat();

fid = fopen(batchname,'r');
[~,numlines] = fscanf(fid,'%s');
frewind(fid);

assert(length(oldsequence)==length(newsequence))
nseq = length(oldsequence);
nrep = 0;
for i=1:numlines
    fn{i}=fgetl(fid);

    try
    load([fn{i} '.not.mat'])
    catch
        labels = [];
    end
    ons = strfind(labels,oldsequence);
    if ~isempty(ons)
    nrep = nrep+length(ons);
    for o = 1:length(ons)
        labels(ons(o):ons(o)+nseq-1) = newsequence;
    end
    fprintf('%s replaced %d sequences \n',fn{i},length(ons))
    save([fn{i} '.not.mat'],'Fs','labels','min_dur','min_int','offsets','onsets','sm_win','threshold')
    end

end
