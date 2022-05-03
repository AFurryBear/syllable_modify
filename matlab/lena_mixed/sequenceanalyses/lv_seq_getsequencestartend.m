function newseq = lv_seq_getsequencestartend(seqs,startsym,stopsym)





for i = 1:length(seqs)
%delete --- from beginning and end of file:
tempseq = seqs{i};
seq = seqs{i};
seq(seq~='-')='a';
firstix = strfind(seq,'-a');
if ~isempty(firstix)
firstix = firstix(1);
end
lastix = strfind(seq,'a-');
if ~isempty(lastix)
lastix = lastix(end);
end

seq = tempseq;

if seq(end) == '-'
    seq(lastix:end) = [];
end
if seq(1) == '-'
    seq(1:firstix) = [];
end

seqs{i}=seq;

if all(seq=='-')
    seqs{i} = [];
end
end

%delete empty sequences
seqs(cellfun(@(x) isempty(x), seqs)) = [];

%add start and stop symbols
newseq = cellfun(@(x) horzcat(startsym,x,stopsym),seqs,'uniformoutput',false);
newseq = [newseq{:}];

