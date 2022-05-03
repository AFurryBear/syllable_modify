function newseq = lv_seq_removerepeats(seq,lengthcutoff)

uns = unique(seq);

for i = 1:length(unique(seq))
    
    templabels = seq;
    templabels(seq~=uns(i)) = '-';
    ons = strfind(templabels,['-' uns(i)]); %ons is last - before repeat
    offs = strfind(templabels,[uns(i) '-']);%offs is last repeat
    
    %deal with situation if target is last or first syllable in
    %bout
    if templabels(end)==uns(i)
        offs = [offs length(templabels)];
    end
    if templabels(1) == uns(i)
        ons = [0 ons];
    end
    
    repeatlength = offs-ons;
    
    if any(repeatlength>lengthcutoff) %normal 2
        seq(ons+1) = upper(uns(i));
        seq(seq==uns(i)) = [];
    end
    
    
    
end
newseq = seq;