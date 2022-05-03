function skipfiles = lv_checkfilesizes(maxsize)
%check if file is too large for analysis

a = dir;
toobigfiles = cellfun(@(x) x>maxsize, {a.bytes});
fix = find(toobigfiles);
for i = 1:sum(toobigfiles)
    
    fprintf('file %s is too big %d',a(fix(i)).name,a(fix(i)).bytes)
end
skipfiles = sum(toobigfiles);