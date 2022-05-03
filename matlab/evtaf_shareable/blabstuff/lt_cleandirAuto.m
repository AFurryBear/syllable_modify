%% LT 12/6/15 - modified to work even if have a lot of noise files (low noise)
% PROBLEM was that ampl threshold would be low, so would have many long
% notes (i.e. duration over threshold). Only notes >10, <150ms are kept, so
% program would think there ar eno notes, and discard song. (see line 56
% for mod)

function cleandirAuto(batch,wind,numwind,numnote,thresh)
% cleandirAuto(batch,wind,numwind,numnote,CHANSPEC)
% 
% wind is the window size in MS
% numwind is the number of notes in a window
% numnote is the numer of times numwind has to be observed in 1 file
%
% Threshold is calculated by mbatchamphist() based on distributiuon of 
% amplitude values across files in batch.

if (~exist('TH'))
    TH=5;
end

if (~exist('wind'))
    wind=1000;
end

wind = wind*1e-3; % convert to ms

if (~exist('numwind'))
    numwind=6;
end

if (~exist('numnote'))
    numnote=4;
end


if (~exist('thresh'))
    lenaskip = 1;
    threshold = 10000;
else
    threshold = thresh;
    lenaskip = 1;
end
% here: not done but do eventually add option in inputs again to do
% mbatchampdist



% 
% if (~exist('CHANSPEC'))
%     CHANSPEC='obs0';
% end

% if (exist([batch '.keep']));
%     ans=input('.keep file exists, are you sure you want to proceed?  ','s');
%     if (ans=='y')
%     else
%         return;
%     end
% end

fid=fopen(batch,'r');
fkeep=fopen([batch,'.keep'],'w');
fdcrd=fopen([batch,'.dcrd'],'w');
disp(['working...']);

%calculate distribution of amplitudes in all songs in batch
% [batchbins batchhist] = lt_mbatchampdist(batch);

% lenaskip = 1;
if lenaskip
% threshold = 10000;
else
[batchbins batchhist] = mbatchampdist(batch);

[pks,pksloc] = findpeaks(batchhist,'SORTSTR','descend');

%lena off
figure; 
bar(batchbins, batchhist);

minind=find(batchbins>=3.2,1,'first'); % LT, thresh should be greater than 3
PeakToUse=find(pksloc>=minind,1,'first');

if PeakToUse~=2
    % 2 is default, if not 2, then tell user
    disp(['NOTE: Using peak loc of ' num2str(PeakToUse) ' isntead of 2 as in original code (LT) - prob due to many noise files']);
end

% if PeakToUse==1 %LV added: in sooyoon's box noise level not at 0 but everything over 3...
%     PeakToUse=2;
% end


threshold = 10^(batchbins(pksloc(PeakToUse)));
threshold = 10000;
end
disp(['threshold = ' num2str(threshold)]);
cntr = 0;
while (1)
    cntr = cntr+1;
    fn=fgetl(fid);
    if (~ischar(fn))
        break;
    end
    if (~exist(fn,'file'))
        continue;
    end

   %disp(fn);

    [pth,nm,ext]=fileparts(fn);
    if (strcmp(ext,'.ebin'))
        [dat,fs]=readevtaf(fn,'0r');
        sm=evsmooth(dat,fs,0.01);
    elseif(strcmp(ext,'.cbin'))
        [dat,fs]=ReadCbinFile(fn);
        %lena if no rec file
        if size(dat,2)>1
            warning(['skipping this file - rec file missing? ' fn])
            continue;
        end
        %end lena
        sm=mquicksmooth(dat,fs);
    elseif(strcmp(ext,'.wav'))
        [dat,fs]=wavread(fn);
        sm=mquicksmooth(dat,fs);
    end
    %[ons,offs]=evsegment(sm,fs,5.0,30.0,TH);
    
    %threshold = mautothresh(fn,TH);
   
    
    [ons offs] = msegment(sm,fs,5,30,threshold); %LENA! was 15 20
    %filter vocalizations that are between 10 and 150ms
    durs = offs-ons;
    kills = find(durs>0.15);
    ons(kills)=[];
    offs(kills)=[];
    durs = offs-ons;
    kills = find(durs<0.01);
    ons(kills)=[];
    offs(kills)=[];
    
    keepit=0;
    if (length(ons) > numwind)
        for ii = 1:length(ons)
            p = find(abs(ons(ii:length(ons))-ons(ii))<=wind);
            if (length(p)>=numwind)
                keepit=keepit+1;
            end
        end
        if (keepit>=numnote)
            fprintf(fkeep,'%s\n',fn);
            %disp('keeping...');
        else
            fprintf(fdcrd,'%s\n',fn);
            %disp('discarding...');
        end
    else
        fprintf(fdcrd,'%s\n',fn);
        %disp('discarding...');
    end
end





fclose(fid);fclose(fkeep);fclose(fdcrd);

fkeep=fopen('batch.keep','r');
[~,numlines] = fscanf(fkeep,'%s');
fprintf('batch.keep %d \n',numlines)
fdcrd=fopen('batch.dcrd','r');
[~,numlines] = fscanf(fdcrd,'%s');
fprintf('batch.dcrd %d \n',numlines)


disp(['done.']);
return
