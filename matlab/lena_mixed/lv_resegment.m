function lv_resegment(batchname,filetype,birdname)

fid = fopen(batchname,'r');
[~,numlines] = fscanf(fid,'%s');
frewind(fid);

for i=1:numlines
    fn{i}=fgetl(fid);
end

    


%wh09
if strcmp(birdname,'wh09')
    sylmin = 25;
    sylmax = 600
    gapmin = 25
    gapmax = 150;
elseif strcmp(birdname,'rd82')
    sylmin = 25;
    sylmax = 400;
    gapmin = 2;
    gapmax = 150;
elseif strcmp(birdname,'wh08')
    sylmin = 25;
    sylmax = 600;
    gapmin = 25;
    gapmax = 150;
    elseif strcmp(birdname,'or34')
    sylmin = 25;
    sylmax = 150;
    gapmin = 5;
    gapmax = 150;
else
        sylmin = 25;
    sylmax = 400;
    gapmin = 1;
    gapmax = 150;
end
%changed smooth from 5 to 20;

SegmentFiles(fn,sylmin,sylmax,gapmin,gapmax,filetype); %Minimum + Maximum syl lengths; gap lengtha; gap wqar 3, syl 150;
% SegmentFiles(fn,30,400,20,150,filetype); %Minimum + Maximum syl lengths;
% gap lengtha; gap wqar 3, syl 150; 23
