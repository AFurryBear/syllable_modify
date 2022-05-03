function xyr_prepare_csv(inpath,outpath)
 cd(inpath);
 Sylmtx=gp_prepare_sylmtx('batch.keep');
 writematrix(Sylmtx,[outpath '/sylmtx.csv']);
 [red, ~, clus] =run_umap(Sylmtx','min_dist',0.08,'cluster_detail','low');
 index = 1:length(red);
 data = [red,double(clus'),index'];
 writematrix(data,[outpath '/umap.csv']);
end