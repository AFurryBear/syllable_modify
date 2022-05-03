function g = seq_plot_digraph(divprob,patterncell)
% plots directed graph. works for con and div.


divprobtoplot = divprob;
divprobtoplot(abs(divprobtoplot)<=3) = 0; %eliminate tiny branches
divprobtoplot(isnan(divprobtoplot))=0;


g = digraph(divprobtoplot,patterncell);%postpatterns
width = 0.05*abs(g.Edges.Weight);
g.Edges.Weight
% width =2;
figure
% p = plot(g,'layout','circle','edgelabel',g.Edges.Weight,'linewidth',width,'arrowsize',18);%

p = plot(g,'layout','auto','edgelabel',g.Edges.Weight,'linewidth',width,'arrowsize',15,'Edgefontsize',18,'nodefontname','arial','edgefontname','arial','nodefontsize',18,'edgealpha',1,'nodecolor',[0.7 .85 1],'markersize',40,'edgefontweight','bold','nodefontweight','bold');%


% p = plot(g,'EdgeLabel',g.Edges.Weight)

% h = get(gca,'children');
% set(h,'Arrowsize',15)
axis off


