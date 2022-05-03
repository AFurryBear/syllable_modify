function alllabels=lv_notmat_get_labels(notmatbatch)
alllabels = {};
fid=fopen(notmatbatch,'r');
if fid~=-1
while (1)
	fn=fgetl(fid);
	if (~ischar(fn));
		break;
    end
    if any(strfind(fn,'wav'))
        continue
    end
load(fn)
alllabels{end+1}=labels;
end
fclose(fid);
return;
end