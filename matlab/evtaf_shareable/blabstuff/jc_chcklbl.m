function jc_chcklbl(bt, NT, PRETIME, POSTTIME, PRENT, POSTNT, repsyl, CS)
%creates wav file containing all labelled syllables from cbin files
%when splicing together the wav file:
%PRETIME: number of seconds to put as buffer before syllable
%POSTTIME: number of seconds to put as buffer after syllable


if (~exist('CS'))
	CS='obs0';
elseif (length(CS)==0)
	CS='obs0';
end

if (~exist('PRENT'))
	PRENT='';
elseif (length(PRENT)==0)
	PRENT='';
end

if (~exist('POSTNT'))
	POSTNT='';
elseif (length(POSTNT)==0)
	POSTNT='';
end


%open batch file and get file names
fid=fopen(bt,'r');
files=[];cnt=0;
while (1)
	fn=fgetl(fid);
	if (~ischar(fn))
		break;
	end
	cnt=cnt+1;
	files(cnt).fn=fn;
end
fclose(fid);

%find labelled syllables in each sound file, cut out bit that corresponds
%to label and splice together into one vector
syllwv1 = [];
    
    for ii=1:length(files)
        fn=files(ii).fn;
        if strfind(fn,'filt') > 0
            load([fn(1:end-5),'.not.mat'])

            elseif (exist([fn,'.not.mat'],'file'))
                load([fn,'.not.mat']);
        else
            labels=[];
        end
        labels(findstr(labels,'0'))='-';

        if (ii==1)
            [dat,fs]=evsoundin('',fn,CS);

            NPRE=ceil(PRETIME*fs);%time before syllable in samples
            NPOST=ceil(POSTTIME*fs);%time after syllable in samples
        end

%         disp(fn);
        srchstr=[PRENT,NT,POSTNT];
        pp=findstr(labels,srchstr)+length(PRENT);
        if (length(pp)>0)

            [filepath,filename,fileext] = fileparts(fn);
            if(strcmpi(fileext,'.wav'))
                [dat,fs] = wavread(fn);
                dat = dat *10e3; % boost amplitude to cbin levels
            else
                [dat,fs]=evsoundin('',fn,CS);
                dat = dat *1e-4;
            end
            for jj=1:length(pp)
                try
                    onind=fix(round(onsets(pp(jj))*1e-3*fs));%onset time into samples
                catch
                    error(['check ' fn])
                end
                enind = fix(round(offsets(pp(jj))*1e-3*fs));%offset time into samples
                st=onind;%onset time - pretime in samples
                en=enind;%offset time + posttime in samples
                if (st<1)
                    st=1;
                end

                if (en>length(dat))
                    en=length(dat);
                end

                dat_tmp=dat(st:en);
                dat_tmp = [zeros(NPRE,1); dat_tmp; zeros(NPOST,1)];

                syllwv1 = cat(1,syllwv1, dat_tmp);
            end
        end
    end

audiowrite(['syllwv_' NT '.wav'], syllwv1,fs);%lena changed to by like lt_jc...



!ls *.wav > wav
evsonganaly(['syllwv_' NT '.wav'])
load(['syllwv_' NT '.wav.not.mat']);
[vlsorfn vlsorind] = jc_vlsorfn(bt,NT,PRENT,POSTNT);
 if size(vlsorfn) == size(labels)
     if ~exist(repsyl)
         ind = regexp(labels,'[^-]');
         repsyl = unique(labels(ind));
         numrepsyl = length(repsyl);
         for k = 1:numrepsyl    
            repsyllind = strfind(labels,repsyl(k));
%             lv_fndtinfo(vlsorind,vlsorfn,repsyllind,NT); %lena added to delete false pos from tinfo files
            jc_fndlbl(vlsorind,vlsorfn,repsyllind,repsyl(k),NT);
         end
     else
         ind = strfind(labels,repsyl);
        jc_fndlbl(vlsorind,vlsorfn,ind,repsyl);
     end
else
    disp('size vlsorfn ~= size labels')
    disp(['vlsorn size = ',num2str(length(vlsorfn)),' labels size = ',num2str(length(labels))])
end
    
            