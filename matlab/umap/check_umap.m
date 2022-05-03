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

%% look for nan syllables
for i = 1:size(astest,2)
cellofspecs{i} = reshape(astest(:,i),121,10);
end
figure('position',[10 10 1000 1000])
hold on
for i = 1:61
subplot(8,8,i)
imagesc(cellofspecs{i})
axis off
end


%%
% label training daTA

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
%% LABEL TEST DATA
[reduction,testumap,newclus]=run_umap(allspces_test','template_file', 'C:\Users\avani\OneDrive\Documents\Veit_lab_data\analysis\bk2bk10\bk2bk10\umaptraining1\randselect_250files\umap_template.mat')
labels_av=testumap.supervisors.nnLabels;
seq_writeclusterstonotmat(allfilenames,labels_av');


%% this only for comparing with hand labels
% % plot hand labels
[labelnames,~,handclus] = unique(labels_av);
allhandclus = unique(handclus);
figure
hold on
colos = distinguishable_colors(length(allhandclus));
for i = 1:length(allhandclus)
    plot(reduction(handclus==i,1),reduction(handclus==i,2),'*','color',colos(i,:))
%     plot3(red(handclus==i,1),red(handclus==i,2),red(handclus==i,3),'*','color',colos(i,:))

end
% legend(labelnames)
% 
% 
% figure
% for i = 1:9
%     subplot(3,3,i)
%     idx = find(handclus==i);
%     imagesc(specmtx(idx(1:20),400:500))
% end