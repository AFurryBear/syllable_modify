function lv_seq_withinbout(batchfile,pat1,pat2)

%within song bout distribution of two target patterns
%example lv_seq_withinbout('batch.keep','dss','-a')
%pat1 will be pink, pat2 will be blue

[labels_song]=lt_db_get_labels(batchfile);

%find indices of target patterns in song bouts
pat1ix = cellfun(@(x) strfind(x,pat1),labels_song,'Uniformoutput',false);
pat2ix = cellfun(@(x) strfind(x,pat2),labels_song,'Uniformoutput',false);

boutlength = cellfun(@(x) length(x),pat1ix)+cellfun(@(x) length(x),pat2ix);
boutmatrix = zeros(size(labels_song,2),max(boutlength));

for i = 1:size(labels_song,2)
    %write -1 for pattern1, 1 for pattern2 in correct order for each song:
    thissong = nan(size(labels_song{i}));
    thissong(pat1ix{i}) = -1;
    thissong(pat2ix{i}) = 1;
    thissong(isnan(thissong)) = [];
    boutmatrix(i,1:length(thissong)) = thissong;
end


cm = [0.8 0.2 0.4; 1 1 1; 0.2 0.6 0.8];

figure
subplot(1,2,1)
imagesc(boutmatrix)
box off
colormap(cm)
title('bouts in order')

subplot(1,2,2)
songlength = sum(boutmatrix==0,2);
[~, sortidx] = sort(songlength);
imagesc(boutmatrix(sortidx,:))
box off
colormap(cm)
title('bouts by length')
