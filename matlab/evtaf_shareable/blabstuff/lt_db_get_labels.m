function [ syllables time_syl filenames onsets_syl offsets_syl] = lt_db_get_labels( batchfile, single_song )
% LT modified 1/21/14 to include 1) onset times, 2) offset times

%db_get_labels Input a batch file (either .cbin or .cbin.not.mat), and it
%will return a cell with all the labels ('-' or syllables) for each song,
%the time (serial date time) when it occured, and the filename. Will also
%work with just one cbin or cbin.not.mat file (set single_file to 'y')
%   

if nargin < 2 || strcmpi(single_song,'y') == 0
    %opens the batchfile
    
        fid = fopen(batchfile,'r');
    if fid==-1
fileempty = 1;
    else
        
        
    %gets the first line of the batchfile
    current_line = fgetl(fid);
    j = 1;
    
    
    %lena
    fileempty=1;
    
    while ischar(current_line)
        %         if ~isempty(strfind(current_line,'.not.mat')) == 1
        %             load(current_line)
        %         else
        fileempty=0;
        try %lena
            load([current_line '.not.mat'])
            %         end
            
            %gets the labels for the song
            syllables{j} = labels;
            
            %gets the timing of each syllable in the file
            %gets the time of the recorded file
            time_of_file = db_timing4_file(current_line);
            
            %gets the time of onset of each syllable (in serial date time)
            time_of_syllables = db_convert_seconds_to_serialdate(onsets./1000, 'sec');
            
            %gets serial date time of each syllable
            time_syl{j} = time_of_syllables + time_of_file;
            time_syl{j} = time_syl{j}';
            
            %gets the filename for each song
            filenames{j} = current_line;
            
            % ADDED BY LT:
            %gets onsets and offsets:
            onsets_syl{j} = onsets;
            offsets_syl{j} = offsets;
        catch
            syllables{j} = [];
            time_syl{j} =[];
            filenames{j} = [];
            onsets_syl{j} = [];
            offsets_syl{j} = [];
        end
        j = j+1;
        current_line = fgetl(fid);
    end
    fclose(fid);
    end
elseif strcmpi(single_song,'y') == 1
    if ~isempty(strfind(batchfile,'.not.mat')) == 1
        load(batchfile)
    else
        load([batchfile '.not.mat'])
    end
    
    syllables = {labels};
    
    time_of_file = db_timing4_file(batchfile);
    time_of_syllables = db_convert_seconds_to_serialdate(onsets./1000, 'sec');

    time_syl = {time_of_syllables + time_of_file};
    
    filenames = {batchfile};
    
    % ADDED BY LT:
    %gets onsets and offsets:
    onsets_syl = onsets;
    offsets_syl = offsets;

end


if fileempty
    syllables = [];
    time_syl =[];
    filenames =[];
    onsets_syl =[];
    offsets_syl=[];
end

end

