clear all
dates = dir;
names = {dates.name};
datefolderix = cellfun(@(x) ~isempty(regexp(x,'^\d')),names); %starts with a digit
dates = dates(datefolderix);
isdir=[dates.isdir];
dates=dates(isdir);

for i=1:length(dates)
    datefol=dates(i).name;
    cd(datefol);
    files=dir;
    dirFlags = [files.isdir] & ~strcmp({files.name},'.') & ~strcmp({files.name},'..')& ~regexpcmp({files.name},'OldNotMat*');
    %check if there are subfolders
    if any(dirFlags)
        SubFol={files(dirFlags).name};
        for j=1:length(SubFol)
            cd(SubFol{j})
            try
            %lt_make_batch(1) %can change parameters here
            %lv_resegment_fixed('batch.keep','evtaf',4000,20,2);
            [allfilenames,allspecs_test]=gp_prepare_sylmtx('batch.keep'); 
            save('allfilenames')
            save('allspecs_test')
%             load('allfilenames.mat')
%             load('allspecs_test.mat')
%             [reduction,testumap,newclus]=run_umap(allspces_test','template_file', 'C:\Users\avani\OneDrive\Documents\Veit_lab_data\analysis\bk2bk10\bk2bk10\umaptraining1\randselect_250files\umap_template.mat')
%             labels_av=testumap.supervisors.nnLabels;
%             seq_writeclusterstonotmat(allfilenames,labels_av');
%             close all
            catch
                %todo write error log
            end
            cd ..
        end
        cd ..
    else
        try
        %lt_make_batch(1) %can change parameters here
        %lv_resegment_fixed('batch.keep','evtaf',4000,20,2);
        [allfilenames,allspecs_test]=gp_prepare_sylmtx('batch.keep'); 
        save('allfilenames')
        save('allspecs_test')
%         load('allfilenames.mat')
%         load('allspecs_test.mat')
%         [reduction,testumap,newclus]=run_umap(allspces_test','template_file', 'C:\Users\avani\OneDrive\Documents\Veit_lab_data\analysis\bk2bk10\bk2bk10\umaptraining1\randselect_250files\umap_template.mat')
%         labels_av=testumap.supervisors.nnLabels;
%         seq_writeclusterstonotmat(allfilenames,labels_av');
%         close all
        catch
%             errormsg=datefol;
%             fullFileName = 'Error_Log.txt';
%             fid = fopen(fullFileName, 'at');
%             fprint(fid, '%s\n', errorMessage); % To file
%             fclose(fid);                  %todo write error log

        end
        cd ..
    end
    
end
    
        
        
    