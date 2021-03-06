function PlotDataFileStim(hObject,handles);
%function [onsets,offsets]=PlotDataFile(hObject,handles);
% EVSONGANAL Main plotting function
% pulls the filename out of the handdles structure
% smooths and segments uses not.mat file it it exists
% calculates the spectragram plots it
% plots smoothed noise level as well as 

set(hObject,'Interruptible','off');
set(hObject,'BusyAction','Cancel');
%tempvar = handles.INPUTFILES;
%save temp.mat tempvar
FNAME=handles.INPUTFILES(handles.NFILE).fname;
chanspec=handles.ChanSpec;
[dat,Fs,DOFILT,ext]=ReadDataFile(FNAME,chanspec);
if ((get(handles.UseSpectBox,'Value')==get(handles.UseSpectBox,'Max'))&(exist([FNAME,'.spect'],'file')))    
    eval(['load -mat ',FNAME,'.spect']);
else
    [sm,sp,t,f]=SmoothData(dat,Fs,DOFILT,handles.filter_type);
end
%TAKE OUT THE TOP FREQ HALF OF SPECTROGRAM (IT HAS LITTLE POWER DUE TO
%FILTERING)
%sp = sp(1:128,:);f=f(1:128);
%for problems with taking the log of zero
pp=find(sp>0);
mntmp = min(min(sp(pp)));
pp=find(sp==0);
sp(pp) = mntmp;

handles.FILEEXT  = ext;
handles.MinSpVal = log(min(min(sp)));
handles.MaxSpVal = log(max(max(sp)));
guidata(hObject,handles);
handles=guidata(hObject);

vtmp = get(handles.MinSpecValSlider,'Value');
%handles.SPECTH=exp(handles.MinSpVal+vtmp*(handles.MaxSpVal-handles.MinSpVal));
handles.SPECTH=vtmp*((2^8)-1);

vtmp = get(handles.MaxSpecValSlider,'Value');
%handles.MAXSPECTH=exp(handles.MinSpVal+vtmp*(handles.MaxSpVal-handles.MinSpVal));
handles.MAXSPECTH=vtmp*((2^8)-1);

if (handles.MAXSPECTH<=handles.SPECTH)
    %handles.MAXSPECTH = exp(handles.MaxSpVal);
    set(handles.MaxSpecValSlider,'Value',get(handles.MaxSpecValSlider,'Max'));
end

%handles.MinSpVal = min(min(sp));
%handles.MaxSpVal = max(max(sp));
%guidata(hObject,handles);
%handles=guidata(hObject);
%vtmp=(handles.SPECTH-handles.MinSpVal)./(handles.MaxSpVal-handles.MinSpVal);
%if (vtmp>1)
%    vtmp = 1.0;
%end
%if (vtmp<0)
%    vtmp=0.0;
%end
%set(handles.MinSpecValSlider,'Value',vtmp);

%look for .not.mat file
[tmp1,tmp2,tmpext]=fileparts(FNAME);
if (exist([FNAME,'.not.mat'],'file'))
    load([FNAME,'.not.mat']);
    onsets=onsets*1e-3;
    offsets=offsets*1e-3;
elseif ((strcmp(tmpext,'.filt')) & (exist([FNAME(1:end-4),'not.mat'],'file')))
		load([FNAME(1:end-4),'not.mat']);
		onsets=onsets*1e-3;
		offsets=offsets*1e-3;
else
    %recdata=readrecf(FNAME);
    %if (isfield(recdata,'adfreq'))
    %	    Fs = recdata.adfreq;
    %end
    min_int=handles.MININT;
    min_dur=handles.MINDUR;
    threshold=handles.SEGTH;
    sm_win=handles.SM_WIN;
    sm(1)=0.0;sm(end)=0.0;
    [onsets,offsets]=SegmentNotesJC(sm,Fs,min_int,min_dur,threshold);
    labels = char(ones([1,length(onsets)])*fix('-'));
    %ONSETS AND OFFSETS COME IN SECONDS NOT MS!
end
handles.SMOOTHDATA = sm;
handles.ONSETS=onsets;
handles.OFFSETS=offsets;
handles.SEGTH=threshold;
handles.MININT=min_int;
handles.MINDUR=min_dur;
handles.LABELS=labels;
handles.SM_WIN=sm_win;
handles.FS = Fs;
guidata(hObject,handles);
handles=guidata(hObject);

if (length(onsets)==0)
    onsets=[t(1)];offsets=[t(end)];labels=['-'];
end

% image the spectrogram
axes(handles.SpecGramAxes);hold off;

%%%%%%%%%% change for caxis version %%%%%%%%%%
%pp = find(sp<=handles.SPECTH);
%sptemp = sp;sptemp(pp) = handles.SPECTH;
%pp = find(sptemp>=handles.MAXSPECTH);
%sptemp(pp) = handles.MAXSPECTH;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sptemp=log(sp);sptemp = sptemp - min(min(sptemp));
sptemp = uint8(((2^8) - 1)*(sptemp./max(max(sptemp)))); % SAVE SOME MEMORY 8X less than 64 bit double

SPECT_HNDL=image(t,f,sptemp);set(gca,'YD','n');m=colormap;
set(SPECT_HNDL,'CDataMapping','Scaled');
axis([t(1) t(end) 0 1e4]);vv=axis;

vtmpmin = get(handles.MinSpecValSlider,'Value');
vtmpmax = get(handles.MaxSpecValSlider,'Value');

caxis(((2^8)-1)*[vtmpmin,vtmpmax]);
    
handles.OrigAxis = vv;
clear sptemp;
spectitle=FNAME;
title(RemoveUnderScore(spectitle));

%plot the smooth power
dsamp=handles.SMUNDERSAMPLE;
axes(handles.SmoothAxes);hold off;
semilogy([1:length(sm(1:dsamp:end))]*dsamp/Fs,sm(1:dsamp:end),'b-');hold on;
segs=zeros([length(onsets),3]);
for ii = 1:length(onsets)
    segs(ii,1)=plot(onsets(ii),threshold,'k+');
    segs(ii,2)=plot(offsets(ii),threshold,'k+');
    segs(ii,3)=line([onsets(ii),offsets(ii)],[1,1]*threshold,'Color',[0,0,0]);
end
lltmp = length(sm);
inds = [fix(0.1*lltmp):fix(0.9*lltmp)];
inds=find(sm>0);
mntmp = 10^floor(log10(min(sm(inds))));
mxtmp = 10^ceil(log10(max(sm(inds))));
axis([vv(1:2) mntmp mxtmp]);

%axes(handles.LabelAxes);hold off;
%text(onsets.',ones(size(onsets)),labels.');
%axis([min(t) max(t) -1 1]);

meantimes=(onsets+offsets).*0.5;
axes(handles.LabelAxes);cla;
handles.LABELTAGS=text(meantimes,zeros([length(meantimes),1]),labels.');
axis([vv(1:2),-2,1]);
set(gca,'XTick',[],'YTick',[]);
if (get(handles.HighLightBtn,'Value')==get(handles.HighLightBtn,'Max'))
    pp=findstr(labels,get(handles.HighLightNoteBox,'string'));
    for ii=1:length(pp)
        set(handles.LABELTAGS(pp(ii)),'Color','b');
    end
end
drawnow;

%if it is a catch trial put that in the box
rdata=readrecf(FNAME);
if (~isfield(rdata,'ttimes'))
    rdata.ttimes=[];
end
if (length(rdata)>0)
    if (isfield(rdata,'iscatch'))
        if (rdata.iscatch)
            set(handles.CatchTrialBox,'Value',get(handles.CatchTrialBox,'Max'));
        else
            set(handles.CatchTrialBox,'Value',get(handles.CatchTrialBox,'Min'));
        end
    end
    
    % put marker at trigger times
    if (get(handles.ShowTrigBox,'Value')==get(handles.ShowTrigBox,'Max'))
        axes(handles.LabelAxes);hold on;
        
        for ii=1:length(rdata.ttimes)
            triginfo=char(rdata.pbname(ii));
            if ~isempty(findstr(triginfo,'TrigPulse')) && ~isempty(findstr(triginfo,'FB')) 
                plot(rdata.ttimes(ii)*1e-3,-1.5,'r+'); % if StimTrig & notcatch
            else
                if ~isempty(findstr(triginfo,'TrigPulse')) && isempty(findstr(triginfo,'FB'))
                    plot(rdata.ttimes(ii)*1e-3,-1.5,'k^'); % if StimTrig & catch
                else 
                  
                        plot(rdata.ttimes(ii)*1e-3,-1.5,'b^'); % if WNtrig - notcatch
                end
            end
            %
        end
        hold off;drawnow;
    end
else
    rdata.ttimes=[];
end

set(hObject,'Interruptible','on');
set(hObject,'BusyAction','Queue');

%save sp, fs, labels
handles.SPECGRAMVALS = sp;
handles.SPECT_HNDL=SPECT_HNDL;
handles.SEG_HNDL=reshape(segs,[numel(segs),1]);
handles.TIMEVALS = t;
handles.FREQVALS = f;
handles.FS = Fs;
handles.LABELS = labels;
handles.ONSETS = onsets;
handles.OFFSETS = offsets;
handles.MININT=min_int;
handles.MINDUR=min_dur;
handles.SEGTH=threshold;
handles.SM_WIN=sm_win;
handles.TRIGTIMES=rdata.ttimes*1e-3;   
guidata(hObject,handles);
return;
