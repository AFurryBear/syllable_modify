function WriteEvTAFv4ConfigFile(fn,ND,OtherParams);
% WriteEvTAFv4ConfigFile(fn,ND,OtherParams);

fid = fopen(fn,'w','b');

%Raw Sound Threshold I32
fwrite(fid,OtherParams.RawSndTH,'int32');

fwrite(fid,OtherParams.SilenceT,'double');

%analog input info
WriteStringToLVBinFile(fid,OtherParams.AIChans);

%Analog Input sampling freq
fwrite(fid,OtherParams.FS,'double');

% min in and out voltage use defaults here:
fwrite(fid,OtherParams.MinInVoltage,'double');
fwrite(fid,OtherParams.MaxInVoltage,'double');

%below is unimportant parameter - channel name
WriteStringToLVBinFile(fid,'AI');

% analog output info
fwrite(fid,OtherParams.MinOutVoltage,'double');
fwrite(fid,OtherParams.MaxOutVoltage,'double');

% analog output chans
WriteStringToLVBinFile(fid,OtherParams.AOChans);
disp(['Writing default Analog Output chan : Dev1/ao0 - change in evtaf if needed']);

%below is unimportant parameter - channel name
WriteStringToLVBinFile(fid,'AO');

% trigger source
WriteStringToLVBinFile(fid,OtherParams.TriggerSource);

%minimum file length
fwrite(fid,OtherParams.MinFileLength,'double');
%disp(['Using bad min file length, change in evtaf']);

fwrite(fid,OtherParams.CatchSongFraction,'double');
%disp(['verify catch song frac in evatf']);

WritePathToLVBinFile(fid,OtherParams.OutputSoundFileDir);

%%%%%%%%%%%%%%%%%%%%%%%%%%
% BIG PART
% Note Detection Info
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%size of the ND array
fwrite(fid,length(ND),'int32');

for iND=1:length(ND)
    %template file path
    WritePathToLVBinFile(fid,ND(iND).TemplFile);

    % counter range array of clusters
    CntRngSz=length(ND(iND).CntRng);
    CntRng=ND(iND).CntRng;
    fwrite(fid,CntRngSz,'int32');
    for jj=1:CntRngSz
        fwrite(fid,CntRng(jj).Min,'int16');
        fwrite(fid,CntRng(jj).Max,'int16');
        fix(fwrite(fid,CntRng(jj).Not,'char'));
        fix(fwrite(fid,CntRng(jj).Mode,'char'));
        fwrite(fid,CntRng(jj).BTAFmin,'int16');
        WriteStringToLVBinFile(fid,CntRng(jj).VarName);
    end

    %FFT thresholds array of double
    ArrSz=length(ND(iND).CntRng);
    fwrite(fid,ArrSz,'int32');
    for jj=1:ArrSz
        fwrite(fid,ND(iND).CntRng(jj).TH,'double');
    end

    % Counter Values array of U32
    %this is not needed - output not input
    fwrite(fid,1,'int32');
    fwrite(fid,0,'uint32');

    %  amp bound is a cluster
    AmpRng=ND(iND).AmpRng;
    fwrite(fid,AmpRng.MinFreq,'double');
    fwrite(fid,AmpRng.MaxFreq,'double');
    fwrite(fid,AmpRng.AmpThresh,'double');
    fwrite(fid,AmpRng.AmpMode,'uint16');

    % templates 2-d array SNGL
    % this input may or may not be full if it is it may have the templates
    Templ=ND(iND).Templ;
    fwrite(fid,size(Templ,1),'int32');
    fwrite(fid,size(Templ,2),'int32');
    for jj=1:size(Templ,1)
        for kk=1:size(Templ,2)
            fwrite(fid,Templ(jj,kk),'single');
        end
    end


    % catch trial  frac double
    fwrite(fid,ND(iND).CatchTrialFrac,'double');

    % catch trial BOOL - indicator no reason to read
    fwrite(fid,0,'char');

    % FreqBounds Cluster
    FreqRng=ND(iND).FreqRng;
    fwrite(fid,FreqRng.MinFreq,'double');
    fwrite(fid,FreqRng.MaxFreq,'double');
    fwrite(fid,FreqRng.FreqTHMin,'double');
    fwrite(fid,FreqRng.FreqTHMax,'double');
    fwrite(fid,FreqRng.NBins,'int32');
    fwrite(fid,FreqRng.FreqMode,'uint16');

    % NDetect U32  - indicator just throw away this data
    % NTrig U32 - indicator justthrow away
    fwrite(fid,0,'uint32');
    fwrite(fid,0,'uint32');
    % Detection times array of double - indicator throw away
    fwrite(fid,1,'int32');
    fwrite(fid,0,'double');

    % Delay double in secs
    fwrite(fid,ND(iND).DelayToContingen,'double');

    % Detect BOOL - indicator
    % TRIG BOOL - indicator
    fwrite(fid,0,'char');
    fwrite(fid,0,'char');

    % Trigger refrac (double)
    fwrite(fid,ND(iND).TrigRefrac,'double');

    %  Trigger times (arry of dbl) - indicator [16]
    fwrite(fid,1,'int32');
    fwrite(fid,0,'double');

    %  T Since detect dbl - indicator
    fwrite(fid,0,'double');

    %  Output Trig Chan I32 [18]
    fwrite(fid,ND(iND).TrigChan,'int32');

    %  T since trig double - indicator [19]
    fwrite(fid,0,'double');

    %  Playbacks array of strings - indicator  [20]
    ArrSz=fwrite(fid,1,'int32');
    WriteStringToLVBinFile(fid,'empty');

    %  Counter Logic string [21]
    WriteStringToLVBinFile(fid,ND(iND).CntLog);

    %Repeat Count Range [22]
    RepCntRng=ND(iND).RepCntRng;
    fwrite(fid,RepCntRng.MinRepeat,'int32');
    fwrite(fid,RepCntRng.MaxRepeat,'int32');
    fwrite(fid,RepCntRng.RepRefrac,'double');
    fwrite(fid,RepCntRng.RepReset,'double');

    %Repeat Count [23] - indicator toss
    fwrite(fid,0,'int32');

end
%%%%%%%%%% end Note detection info %%%%%
WritePathToLVBinFile(fid,OtherParams.OutputDataDir);
WriteStringToLVBinFile(fid,OtherParams.BirdName);
WriteStringToLVBinFile(fid,OtherParams.DIOTriggerPins);
FileBufferLeng=fwrite(fid,OtherParams.FileBufferLeng,'double');

fwrite(fid,OtherParams.PBOrdering,'char');
WritePathToLVBinFile(fid,OtherParams.BaselinePBDir);
fwrite(fid,OtherParams.MinBLPBTime,'double');
fwrite(fid,OtherParams.MaxBLPBTime,'double');
fwrite(fid,OtherParams.BLPBOrdering,'char');
fwrite(fid,OtherParams.PBAmp,'double');

fclose(fid);
return
