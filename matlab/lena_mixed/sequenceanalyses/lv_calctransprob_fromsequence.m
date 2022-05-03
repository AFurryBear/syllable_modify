function [divprob,conprob,patterncell,postpatterns] = lv_calctransprob_fromsequence(labels,patterns,chunkpatterns,chunknames,eliminaterare)

% patterns = unique(labels);
conprob = nan;

    for p = 1:length(patterns)
        clear postpattern
        
        cntpattern(p) = length(strfind(labels,patterns{p}));
        for pp = 1:length(patterns)
        postpatterns(p,pp) = length(strfind(labels,[patterns{p} patterns{pp}]));
        prepatterns(p,pp) = length(strfind(labels,[patterns{pp} patterns{p}]));
        end
        
        patterncell{p} = patterns{p};
    end

    if eliminaterare
    %eliminate rare notes
    rarenodes = cntpattern./sum(cntpattern)<0.025;%0.01
cntpattern(rarenodes)=0;
postpatterns(rarenodes,:)=0;
postpatterns(:,rarenodes)=0;
prepatterns(rarenodes,:)=0;
prepatterns(:,rarenodes)=0;
patterncell(rarenodes)={'nan'};
    end
    
divprob = postpatterns./repmat(cntpattern',1,size(postpatterns,2));
divprob = round(divprob*100);
divprobtoplot = divprob;
% divprobtoplot(divprobtoplot<=5) = 0; %eliminate tiny branches
divprobtoplot(isnan(divprobtoplot))=0;

% conprob = prepatterns./repmat(cntpattern',1,size(prepatterns,2));
% conprob = round(conprob*100);
% conprobtoplot = conprob;
% % conprobtoplot(conprobtoplot<=5) = 0;
% conprobtoplot(isnan(conprobtoplot))=0;


if exist('chunkpatterns','var')
    for k = 1:length(chunknames)
        ix = find(cellfun(@(x) strcmp(x,chunknames(k)),patterncell));
        patterncell(ix) = chunkpatterns(k);
    end
end

if eliminaterare
divprobtoplot(rarenodes,:)=[];
divprobtoplot(:,rarenodes)=[];
patterncell = patterncell(~cellfun(@(x) strcmp(x,'nan'),patterncell));
end
divprob = divprobtoplot;

% g = digraph(divprobtoplot,patterncell);%postpatterns
% width = 0.05*g.Edges.Weight;
% % g.Edges.Weight
% % width =2;
% figure
% plot(g,'layout','circle','edgelabel',g.Edges.Weight,'linewidth',width,'arrowsize',18);
% % h = get(gca,'children');
% % set(h,'Arrowsize',15)
% axis off
% title('divergent')
% 
% g = digraph(conprobtoplot',patterncell);%postpatterns
% width = 0.05*g.Edges.Weight;
% % g.Edges.Weight
% % width =2;
% figure
% plot(g,'layout','circle','edgelabel',g.Edges.Weight,'linewidth',width,'arrowsize',18);
% % h = get(gca,'children');
% % set(h,'Arrowsize',15)
% axis off
% title('convergent')