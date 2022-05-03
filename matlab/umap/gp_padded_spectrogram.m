function spec = gp_padded_spectrogram(audioi,Fs,time_win)

filtsong=bandpass(audioi,Fs,500,10000,'hanningfir');

% calculate spectrogram
spect_win = 512; % how many frequency bins used to calculate spectrum
%changed to have better freq resolution

%number of samples per window in spectrogram:
noverlap = floor(0.8*time_win); %overlap; unit: samples in time
%real time window: time_win plus overlap
% time_win2 = time_win+noverlap-5; 
[spec,f,t] = spectrogram(filtsong,time_win,noverlap,spect_win,Fs);

% size(spec) %check that size = 32x32


%% process spectrogram
spec = abs(spec);

%prevent problems with taking the log of zero
mntmp = min(min(spec(spec>0)));
spec(spec==0) = mntmp;

% log and normalize between 0 and 1
% spec=log(spec);
spec = spec - min(min(spec));
spec = spec./max(max(spec));

% times 255
spec = 255*spec;

spec = spec(10:130,:);
% vec = spec(:);