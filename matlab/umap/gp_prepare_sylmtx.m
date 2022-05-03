function[allspecs_test,allfilenames]=gp_prepare_sylmtx(batchfile)
%clear all
allspecdurs = [];

allfilenames = {};
alllabels = [];
allspecs_test = [];
specmtx = [];
cnt = 0; %check: how manu syllables too long
allonsets = [];
alloffsets = [];

    filenames = lv_readbatch(batchfile);
    filenames = {filenames(:).fname};
    
    % load all notmat files in batch
    for j = 1:length(filenames)
        allpsds = [];

        load([filenames{j} '.not.mat'])
            fprintf('working on %s \n',filenames{j})

            songdata = ReadCbinFile(filenames{j});
    
            allonsets = [allonsets; onsets];
            alloffsets = [alloffsets; offsets];
            
        %load each syllable
        for k = 1:length(labels)
            allfilenames = [allfilenames; filenames(j)];
            try
            syllable = songdata(floor(onsets(k)/1000*Fs):floor(offsets(k)/1000*Fs));
            alllabels = [alllabels; labels(k)];

            catch
                onsets(k)=[];
                offsets(k)=[];
                fprintf('deleting last segment, number %d, %s \n',k,filenames{j})
            end
                

% 
zeropad=zeros(1024,1);

% 
        spec = gp_padded_spectrogram([zeropad; syllable; zeropad],Fs,512);
        spec = spec(:,10:end-3);


%subsample spec in 10 time points
binwidth = size(spec,2)/10;
samplepoints = linspace(binwidth,size(spec,2)-binwidth,10);
newspec = interp1(1:size(spec,2),spec',samplepoints);
newspec = newspec';
% figure
% subplot(1,2,1)
% imagesc(spec)
% subplot(1,2,2)
% imagesc(newspec)
allspecs_test = [allspecs_test newspec(:)];
        end
        fprintf('saved  %s \n',filenames{j})
        
    end
    
%save sylmtx and save allfilenames


