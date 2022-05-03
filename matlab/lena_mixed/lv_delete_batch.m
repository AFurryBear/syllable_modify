function lv_delete_batch(batch_to_delete)

fid=fopen(batch_to_delete,'r');
[~,numlines] = fscanf(fid,'%s');
frewind(fid);

for i=1:numlines
    fn = fgetl(fid);
    try

    delete(fn)
    delete([fn(1:end-4) 'rec'])
    delete([fn '.not.mat'])
end
end



