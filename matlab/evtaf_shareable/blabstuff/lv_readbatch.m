function filenames = lv_readbatch(batchkeep)

fid=fopen(batchkeep,'r');
[~,numlines] = fscanf(fid,'%s');
frewind(fid);

for i=1:numlines
    filenames(i).fname=fgetl(fid);
end

if numlines==0
    filenames = [];
end
