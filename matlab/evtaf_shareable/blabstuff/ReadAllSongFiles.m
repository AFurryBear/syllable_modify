function [rawsong Fs]=ReadAllSongFiles(pathname,filename,FileType,RMS, varargin)


ChannelNo = 0;

if (strfind(FileType,'obs'))
    channel_string = strcat('obs',num2str(0),'r');
    [rawsong,Fs] = soundin_copy(pathname,filename,channel_string);
    
    % Convert to uV - 5V on the data acquisition is 32768
    rawsong = rawsong * 5/32768;
else
    if (strfind(FileType,'wav'));
        try
          [rawsong, Fs] = wavread(filename);
        catch
          [rawsong, Fs]=audioread(filename);
        end;          
    elseif(strfind(FileType,'PyStereo'));
          [rawsong, Fs]=audioread(filename);
          DigOut=rawsong(:,1);
          rawsong(:,1)=rawsong(:,2);
          rawsong(:,2)=DigOut;          
    elseif (strfind(FileType, 'okrank'));
        [rawsong, Fs] = ReadOKrankData(pathname, filename, 0);
    elseif (strfind(FileType,'mat'));
        load([pathname filename],'SongBout','Fs');
        rawsong=SongBout; clear SongBout;   
    elseif strcmp(FileType,'intan');
        [rawsong, Fs] = IntanRHDReadSong(pathname,filename,0);   
        rawsong=rawsong-mean(rawsong);
    elseif strcmp(FileType,'filt')
        [rawsong,Fs] = read_filt([pathname '/' filename]);
    else if (strfind(FileType,'evtaf'));
        [rawsong, Fs]= ReadCbinFile([pathname '/' filename]);        
        end
    end
end