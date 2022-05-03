function [songfilenames] = lv_plotallsongs_quick(dobatch,namestr,filetype,display_nonsongs,fixscale)
%plots all songs for visual inspection. select all songs in a figure by
%pressing any key, or specific songs by clicking on them. do not close
%figures until everything is done.

%same as plotallsongs but does simply plot, does not do additional checks
%over lt_make_batch


% flagfilestoremove funktioniert noch nicht.
% flagfilestoremove = 0;

if dobatch
    fid=fopen(namestr,'r');
    [~,numlines] = fscanf(fid,'%s');
    frewind(fid);
    
    for i=1:numlines
        a(i).name=fgetl(fid);
    end
else
    
    a = dir(namestr);
end
pathi = cd;
figure('position',[200,200,300,700])
figcnt = 1;
cnt = 1;
cntpotsongs = 1;
% display_nonsongs = 0;
length(a)
%     if flagfilestoremove
%         is_really_song = ones(1,length(a));
%     else
is_really_song = zeros(1,length(a));
%     end
for i = 1:length(a)
    fn = a(i).name;
    [audioi,Fs] = ReadAllSongFiles([pathi filesep],fn,filetype);
    %     [audioi,Fs] = IntanRHDReadSong([pathi filesep],fn,0);
%     bandpasshigh = 6499; %haette gerne 15k
%     sm_win = 10;
%     [sm]=evsmooth(audioi,Fs,0.01,512,0.8, sm_win,500,bandpasshigh); %
%     
%     %Otsu method
%     imagesm = log(sm);
%     minim = min(imagesm);
%     maxim = max(imagesm);
%     imla = (imagesm-minim)./(maxim-minim);
%     [th, thresheffective] = graythresh(imla);
%     th = th.*(maxim-minim) + minim;
%     th = exp(th);
%     threshold = th;
%     
%     sylmin = 20;
%     sylmax = 200;
%     gapmin = 3;
%     gapmax = 150;
    %war .7
%     if thresheffective<0 %bad separation is usually noise file; TODO: check if any missed files
%         onsets=[];
%         offsets=[];
%     else
%         [onsets,offsets]=SegmentNotes(sm,Fs,gapmin,sylmin,threshold);
%         onsets=onsets*1000; % in S for EVSONGANALY
%         offsets=offsets*1000; % in S for EVSONGANALY
%         syllength=(offsets)-(onsets); % in ms.
%         
%         %             keyboard
%         shortkillidx=find(syllength < sylmin);
%         longkillidx=find(syllength > sylmax);
%         killidx=[shortkillidx; longkillidx];
%         onsets(killidx)=[];
%         offsets(killidx)=[];
%         
%         if ~isempty(onsets)
%             gaplength = [500; onsets(2:end)-offsets(1:end-1); 500];
%             gapkillidx = find(gaplength(1:end-1)>gapmax & gaplength(2:end)>gapmax);
%             onsets(gapkillidx)=[];
%             offsets(gapkillidx)=[];
%         end
%     end
%     if length(onsets)>0;%war 10
        is_song(i) = 1;
        
        if ~(display_nonsongs)
            if cnt == 11
                
                figure('position',[100+rem(figcnt,6)*300,100,300,700])
                cnt =1;
                figcnt = figcnt+1;
            end
            
            h(cntpotsongs) = subplot(10,1,cnt);
            cntpotsongs = cntpotsongs+1;
            plot(audioi)
            if fixscale
                set(gca,'ylim',[-1500 2000],'xlim',[0 max([10*Fs,length(audioi)])])
            else
                set(gca,'ylim',[-1.5 2.5],'xlim',[0 max([10*Fs,length(audioi)])])
            end
            set(gca,'UserData',{i,is_really_song})
            set(get(gca,'Children'),'ButtonDownFcn',@flagthissong)
            set(gcf,'KeyPressFcn',@flagallsongs)
            %             text(0,1000,sprintf('%.2f',thresheffective),'color','r')

            %         axis tight
            axis off
            
            cnt = cnt+1;
            
        end
%     else
%         is_song(i) = 0;
%         if display_nonsongs
%             subplot(10,1,cnt)
%             plot(audioi)
%             axis tight
%             axis off
%             
%             cnt = cnt+1;
%             if cnt == 11
%                 figure('position',[200,200,300,700])
%                 cnt =1;
%             end
%         end
%     end
    
end
fprintf('found %d potential songs in %d files \n',sum(is_song),length(a))
pause
for figline = 1:cntpotsongs-1
    ud = get(h(figline),'UserData');
    irs = ud{2};
    %     if flagfilestoremove
    %         irs = ~irs;
    %     end
    is_really_song = or(is_really_song>0,irs>0);
end
fprintf('manually selected %d songs in %d files \n',sum(is_really_song),length(a))

songfilenames = {a(is_really_song==1).name};
% first_onsets = first_onsets(is_really_song);
% last_offsets = last_offsets(is_really_song);

lv_write_batch(['batch.' namestr '.handselect'],songfilenames)

deletefilenames = {a(is_really_song==0).name};
lv_write_batch(['batch.' namestr '.nothandselect'],deletefilenames)

% lv_movebatch([namestr '.nothandselect'],'noisefiles handselect')

close all
end


function flagthissong(ploth,~)
ax = get(ploth,'parent');
set(ploth,'color','g')
ud = get(ax,'UserData');
lh = ud{1};
flagformoving = ud{2};
flagformoving(lh) = 1;
ud{2} = flagformoving;
set(ax,'UserData',ud)
end


function flagallsongs(figh,~)
ax = get(figh,'children');
for i = 1:length(ax)
    plots = get(ax(i),'children');
    set(plots,'color','g')
    ud = get(ax(i),'UserData');
    lh = ud{1};
    flagformoving = ud{2};
    flagformoving(lh) = 1;
    ud{2} = flagformoving;
    set(ax(i),'UserData',ud)
end
end