function [cntpattern divprob] = lv_calctransprob(batchfile,patterns,plotit)
%transition matrix between multi-syllable patterns

fid = fopen(batchfile,'r');
fn=fgetl(fid); % song name, line by line
if fn~=-1

[labels_song]=lt_db_get_labels(batchfile);   %returns cell array of labels from batch file
    
    

nsongs = length(labels_song);


if nsongs==0
    cntpattern = zeros(size(patterns));
else

for i = 1:nsongs
    labels = labels_song{i};
    
    for p = 1:length(patterns)
        clear postpattern
        
        cntpattern(p,i) = length(strfind(labels,patterns{p}));
        for pp = 1:length(patterns)
        postpatterns(p,pp,i) = length(strfind(labels,[patterns{p} patterns{pp}]));
        end
        
        
    end
end
cntpattern = sum(cntpattern,2);
postpatterns = sum(postpatterns,3);

divprob = postpatterns./repmat(cntpattern,1,size(postpatterns,2));

divprob(divprob<0.05) = 0;
divprob = ceil(divprob*100);


if plotit
g = digraph(divprob,patterns);
width = 0.05*g.Edges.Weight;

figure
plot(g,'layout','circle','edgelabel',g.Edges.Weight,'linewidth',width);

axis off
end
end
cntpattern = cntpattern';

else
    cntpattern = nan(size(patterns));
    divprob = nan(size(patterns));
end