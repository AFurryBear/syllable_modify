function newseq = lv_seq_remove1repeat(seq,repsyl,newsyl)


    
    templabels = seq;
    templabels(seq~=repsyl) = '-';
    ons = strfind(templabels,['-' repsyl]); %ons is last - before repeat
    offs = strfind(templabels,[repsyl '-']);%offs is last repeat
    
    %deal with situation if target is last or first syllable in
    %bout
    if templabels(end)==repsyl
        offs = [offs length(templabels)];
    end
    if templabels(1) == repsyl
        ons = [0 ons];
    end
    
    repeatlength = offs-ons
    
%     if any(repeatlength>lengthcutoff) %normal 2
        seq(ons+1) = newsyl;
        seq(seq==repsyl) = [];
%     end
    
    
    

newseq = seq;