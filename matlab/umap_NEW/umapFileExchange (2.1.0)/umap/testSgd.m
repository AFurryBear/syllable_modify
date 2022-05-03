function testSgd(a,v,s)
if nargin<3
    s='sample30k.csv';
    if nargin<2
        v='none';
    end
end
for i=1:length(a)
    tic
    run_umap(s, 'template_file', 'ustBalbc2D.mat', 'verbose', v, 'sgd_tasks', a(i));
    tUst=toc;
    tic
    run_umap(s, 'verbose', v, 'sgd_tasks', a(i));
    tUmap=toc;
    fprintf('%d tasks:  %s secs UST, %s secs UMAP\n', a(i), ...
        num2str(round(tUst,2)), num2str(round(tUmap,2)));
end