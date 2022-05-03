function [newseq,ppnew,newchunknames] = lv_seq_replaceallchunks(seq,pp)

ppnew = {};

chunknames = char(65:length(pp)+65-1);

%do not use chunknames that already exist (like aaaa repeat ->A)
replacecounter=0;
for i = 1:length(chunknames)
    if ~isempty(strfind(seq,chunknames(i)))
        testchunkname = char(length(pp)+65+replacecounter);
        while ~isempty(strfind(seq,testchunkname))
            replacecounter = replacecounter+1;
            testchunkname = char(length(pp)+65+replacecounter);
        end
        chunknames(i)=testchunkname;
        replacecounter = replacecounter+1;
    end
end
% replacecounter

newseq = seq;
for i = 1:length(pp)
    
    foundrepeats = cellfun(@(x) length(strfind(newseq,x)),pp);
if(sum(foundrepeats)>1)
    [~,rank] = sort(foundrepeats,'descend');
    pp = pp(rank);
%     pp{1}
pp{1}
    
    [newseq,nreplaced(i)] = lv_replacechunks(newseq,pp{1},chunknames(i));
    ppnew(end+1) = pp(1);
    pp(1)=[];
    newchunknames(i) = chunknames(i);
else
    break;
end
end
% pp = pp(nreplaced>0);
% chunknames= chunknames(nreplaced>0);