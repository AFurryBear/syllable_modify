function [syllables, onsets, offsets] = lv_seq_get_labels_mult(batchfile,dates,mode)

% dates = dir;
% %find those folders that start with 18
% names ={dates.name};
% datefolderix = cellfun(@(x) ~isempty(strfind(x,'1')),names);
% dates=dates(datefolderix);


switch mode

    case 'combine'
    
        syllables = {};
        onsets = {};
        offsets = {};
        
        
        for i = 1:length(dates)
            
            cd(dates{i})
            
            
            [ seq, ~, ~, onset, offset] = lt_db_get_labels(batchfile);
            
            syllables = [syllables seq];
            onsets = [onsets onset];
            offsets = [offsets offset];
            
            
            cd ..
        end

    case 'day'
        
        syllables = {};
        onsets = {};
        offsets = {};
        
        for i = 1:length(dates)
            
            cd(dates{i})
            
            
            [ seq, ~, ~, onset, offset] = lt_db_get_labels(batchfile);
            
            syllables{i} = seq;
            onsets{i} = onset;
            offsets{i} = offset;
            
            
            cd ..
        end
end