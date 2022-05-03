function lt_make_batch(input,ncross,thresh,ntime)
% If input:
% 1: autosort songs based on ampl crossings
% 2: subsample randomly, then autosort (input should be 2,0.2, for 20%)
% 3: write all songs to batch
% 4: make batch with FB hits - i.e. likely real songs
% 5: make batch of all .wav files

batchname = 'batch';
% batchname = input('What is the name of the batch file?  ', 's');

%makes a batch file
    db_write_batch(batchname)

if input==1;
    
    skipfiles = lv_checkfilesizes(400000000);
    if skipfiles

        return
    end
    
    
    
    if exist('ncross','var')
        
        if exist('thresh','var')
            
            
            if exist('ntime','var')
                lt_cleandirAuto('batch',ntime,ncross,1,thresh)%%was 6 was 4, changed because rd64;  %6 fuer wh63, sonst 4% put 10 for fastr repeats birds
            else
            lt_cleandirAuto('batch',1000,ncross,1,thresh)%%was 6 was 4, changed because rd64;  %6 fuer wh63, sonst 4% put 10 for fastr repeats birds
            end
        else
            lt_cleandirAuto('batch',1000,ncross,1)%%was 6 was 4, changed because rd64;  %6 fuer wh63, sonst 4% put 10 for fastr repeats birds
        end
    else
        lt_cleandirAuto('batch',1000,6,1)%%was 6 was 4, changed because rd64;  %6 fuer wh63, sonst 4% put 10 for fastr repeats birds
        fprintf('using six crossings \n')
    end
end

if input==2;
    randsamp('batch',fraction);
    lt_cleandirAuto('batch.rand',1000,4,4);
end

if input==3;
    db_write_batch('batch.keep') %lena changed to also name batch.keep

    disp('Batch of all songs made');
end

if input==4;
    lt_rec_files_find_FB_v3('batch');
end

if input==5;
    wavfilenames=dir('*.wav');
    fid=fopen([batchname '_wsv'],'w');
    
    for i=1:length(wavfilenames);
    fprintf(fid,'%s\n',wavfilenames(i).name);
    end
end
    

end

