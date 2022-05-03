%% training data for vak using umap
allspecs=allspecs_test;
%% check spectrograms
for i = 1:size(allspecs,2)
cellofspecs{i} = reshape(allspecs(:,i),121,10);
end
figure('position',[10 10 1000 1000])
hold on
for i = 1:64
subplot(8,8,i)
imagesc(cellofspecs{i})
axis off
end

%% label vak training data
[red,umap,clus]=run_umap(allspecs','min_dist',0.08,'cluster_detail','low')
% plot umap clusters
allclus = unique(clus);
figure
hold on
cols = distinguishable_colors(length(allclus)+1);
for i = 1:length(allclus)+1
    % clusters count from 0
    plot(red(clus==i-1,1),red(clus==i-1,2),'o','color',cols(i,:))
    
end

% MAKE ADJUSTMENTS TO CLUSTERS AS NEEDED
% ...clus(clus==0)=3
clus = double(clus);

% add clusters to allspecs
allspecs_label = [allspecs; clus];
[red_train,~,clus_train] = run_umap(allspecs_label','save_template_file','umap_template.mat','label_column','end')

%% label data
seq_writeclusterstonotmat(allfilenames,clus);