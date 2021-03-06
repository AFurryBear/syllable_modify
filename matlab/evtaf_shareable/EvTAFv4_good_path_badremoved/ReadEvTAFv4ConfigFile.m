function [NoteDet,OtherParams]=ReadEvTAFv4ConfigFile(fn,OLDVERSION);
%[NoteDet,OtherParams]=ReadEvTAFv4ConfigFile(fn,OLDVERSION);
%

if (~exist('OLDVERSION','var'))
	OLDVERSION = 0;
end

fid = fopen(fn,'r','b');

%Raw Sound Threshold I32
RawSndTH=fread(fid,1,'int32');
disp(['Raw Sound Threshold (to open file) : ',num2str(RawSndTH)]);

SilenceT=fread(fid,1,'double');
disp(['Silence time required before flie closes : ',num2str(SilenceT),' sec']);

%analog input info
AIChans=ReadStringFromLVBinFile(fid);
disp(['Analog Input channels : ',AIChans]);

FS=fread(fid,1,'double');
disp(['Requested Analog Input sampling rate : ',num2str(FS),' kHz (actual rate may differ slightly)']);

MinInVoltage=fread(fid,1,'double');
MaxInVoltage=fread(fid,1,'double');
disp(['Analog input range is from : ',num2str(MinInVoltage),' to ',...
    num2str(MaxInVoltage),' Volts']);

%below is unimportant parameter - channel name
TEMP=ReadStringFromLVBinFile(fid);

% analog output info
MinOutVoltage=fread(fid,1,'double');
MaxOutVoltage=fread(fid,1,'double');
disp(['Analog output range is from : ',num2str(MinOutVoltage),' to ',...
    num2str(MaxOutVoltage),' Volts']);

AOChans=ReadStringFromLVBinFile(fid);
disp(['Analog Output channels : ',AOChans]);

%below is unimportant parameter - channel name
TEMP=ReadStringFromLVBinFile(fid);

TriggerSource=ReadStringFromLVBinFile(fid);

%minimum file length for file to be kept - also will keep any file which
%had a trigger detect (even if playback was not triggered due to freq or
%amp contingency
MinFileLength=fread(fid,1,'double');
disp(['Minimum File Length : ',num2str(MinFileLength),' sec']);

CatchSongFraction=fread(fid,1,'double');
disp(['Catch song fraction = ',num2str(CatchSongFraction)]);

OutputSoundFileDir=ReadPathFromLVBinFile(fid);
disp(['Output sounds played from dir : ',OutputSoundFileDir]);

%%%%%%%%%%%%%%%%%%%%%%%%%%
% BIG PART
% Note Detection Info
%%%%%%%%%%%%%%%%%%%%%%%%%%%
NDIArraySize=fread(fid,1,'int32');

NoteDet=[];
for ii=1:NDIArraySize
    %template file path
    NoteDet(ii).TemplFile=ReadPathFromLVBinFile(fid);
    
    % counter range array of clusters
    CntRngSz=fread(fid,1,'int32');
    CntRng=[];
    for jj=1:CntRngSz
        CntRng(jj).Min=fread(fid,1,'int16');
        CntRng(jj).Max=fread(fid,1,'int16');
        CntRng(jj).Not=fix(fread(fid,1,'char'));
        CntRng(jj).Mode=fix(fread(fid,1,'char'));
        CntRng(jj).BTAFmin=fread(fid,1,'int16');
        CntRng(jj).VarName=ReadStringFromLVBinFile(fid);
    end
    NoteDet(ii).CntRng=CntRng;

    %FFT thresholds array of double
    ArrSz=fread(fid,1,'int32');
    fftth=fread(fid,ArrSz,'double');
    if (length(fftth)~=length(CntRng))
        disp(['FFT Thresholds not the same size as Counter Ranges']);
        disp(['Need to check this!!!!']);
    end
    for jj=1:ArrSz
        NoteDet(ii).CntRng(jj).TH=fftth(jj);
    end
    % Counter Values array of U32
    %this is not needed - output not input
    ArrSz=fread(fid,1,'int32');
    fread(fid,ArrSz,'uint32');
    
    %  amp bound is a cluster
    AmpRng=[];
    AmpRng.MinFreq=fread(fid,1,'double');
    AmpRng.MaxFreq=fread(fid,1,'double');
    AmpRng.AmpThresh=fread(fid,1,'double');
    AmpRng.AmpMode=fread(fid,1,'uint16'); % 0 - below hits 1- above hits
    NoteDet(ii).AmpRng=AmpRng;
    
    % templates 2-d array SNGL
    % this input may or may not be full if it is it may have the templates
    ArrSz=fread(fid,2,'int32').';
    tempread=fread(fid,ArrSz(1)*ArrSz(2),'single');
    Templates=zeros(ArrSz);
    for jj=1:ArrSz(2)
        Templates(:,jj)=tempread(jj:ArrSz(2):end);
    end
    NoteDet(ii).Templ=Templates;
   
    % catch trial  frac double
    NoteDet(ii).CatchTrialFrac=fread(fid,1,'double');
    
    % catch trial BOOL - indicator no reason to read
    fread(fid,1,'char');
    
    % FreqBounds Cluster
    FreqRng=[];
    FreqRng.MinFreq=fread(fid,1,'double');
    FreqRng.MaxFreq=fread(fid,1,'double');
    FreqRng.FreqTHMin=fread(fid,1,'double');
    FreqRng.FreqTHMax=fread(fid,1,'double');
    FreqRng.NBins=fread(fid,1,'int32');
    FreqRng.FreqMode=fread(fid,1,'uint16'); % 0 - below hits, 1 - above hits 2 - between hits 3 - outside range hits
    NoteDet(ii).FreqRng=FreqRng; % below hits use the FreqTHMAx, above hits use FREQTHMin

    % NDetect U32  - indicator just throw away this data
    % NTrig U32 - indicator justthrow away
    fread(fid,2,'uint32');
    % Detection times array of double - indicator throw away
    ArrSz=fread(fid,1,'int32');
    fread(fid,ArrSz,'double');
    
    % Delay double in secs
    NoteDet(ii).DelayToContingen=fread(fid,1,'double');
    
    % Detect BOOL - indicator
    % TRIG BOOL - indicator
    fread(fid,2,'char');
    
    % Trigger refrac (double)
    NoteDet(ii).TrigRefrac=fread(fid,1,'double');
    
    %  Trigger times (arry of dbl) - indicator [16]
    ArrSz=fread(fid,1,'int32');
    fread(fid,ArrSz,'double');
    
    %  T Since detect dbl - indicator
    fread(fid,1,'double');
    
    %  Output Trig Chan I32 [18]
    NoteDet(ii).TrigChan=fread(fid,1,'int32');
    
    %  T since trig double - indicator [19]
    fread(fid,1,'double');
    
    %  Playbacks array of strings - indicator  [20]
    ArrSz=fread(fid,1,'int32');
    for jj=1:ArrSz
        tmp=ReadStringFromLVBinFile(fid);
    end
    
    %  Counter Logic string [21]
    NoteDet(ii).CntLog=ReadStringFromLVBinFile(fid);

    if (OLDVERSION == 0)
    	% repeat stuff was added later -> should only effect
	% me and tim everyone else should set this == 0
    	%Repeat Count Range [22]
    	RepCntRng=[];
    	RepCntRng.MinRepeat=fread(fid,1,'int32');
    	RepCntRng.MaxRepeat=fread(fid,1,'int32');
    	RepCntRng.RepRefrac=fread(fid,1,'double');
    	RepCntRng.RepReset=fread(fid,1,'double');
    	NoteDet(ii).RepCntRng=RepCntRng;
    
    	%Repeat Count [23] - indicator toss
    	fread(fid,1,'int32');
    end
end
%%%%%%%%%% end Note detection info %%%%%

OutputDataDir=ReadPathFromLVBinFile(fid);
BirdName=ReadStringFromLVBinFile(fid);
DIOTriggerPins=ReadStringFromLVBinFile(fid);
FileBufferLeng=fread(fid,1,'double');
PBOrdering=fread(fid,1,'char');
BaselinePBDir=ReadPathFromLVBinFile(fid);
MinBLPBTime=fread(fid,1,'double');
MaxBLPBTime=fread(fid,1,'double');
BLPBOrdering=fread(fid,1,'char');
PBAmp=fread(fid,1,'double');

OtherParams.PBOrdering=PBOrdering;
OtherParams.BaselinePBDir=BaselinePBDir;
OtherParams.MinBLPBTime=MinBLPBTime;
OtherParams.MaxBLPBTime=MaxBLPBTime;
OtherParams.BLPBOrdering=BLPBOrdering;
OtherParams.PBAmp=PBAmp;


OtherParams.RawSndTH=RawSndTH;
OtherParams.FileBufferLeng=FileBufferLeng;
OtherParams.BirdName=BirdName;
OtherParams.DIOTriggerPins=DIOTriggerPins;
OtherParams.OutputDataDir=OutputDataDir;
OtherParams.SilenceT=SilenceT;
OtherParams.AIChans=AIChans;
OtherParams.AOChans=AOChans;
OtherParams.FS=FS;
OtherParams.MinInVoltage=MinInVoltage;
OtherParams.MaxInVoltage=MaxInVoltage;
OtherParams.MinOutVoltage=MinOutVoltage;
OtherParams.MaxOutVoltage=MaxOutVoltage;
OtherParams.OutputSoundFileDir=OutputSoundFileDir;
OtherParams.TriggerSource=TriggerSource;
OtherParams.MinFileLength=MinFileLength;
OtherParams.CatchSongFraction=CatchSongFraction;
OtherParams.OutputSoundFileDir=OutputSoundFileDir;

fclose(fid);
return
