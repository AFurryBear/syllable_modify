function [vlsorfn vlsorind] = jc_vlsorfn(batch,NOTE,PRENOTE,POSTNOTE)
%use with jc_chcklbl and jc_findlbl
%for each labelled syllable, finds the corresponding cbin file name and
%index into that file; this is so that jc_fndlbl can go back to that file and change the
%label for that corresponding syllable

ff=load_batchf(batch);
note_cnt = 0;
for ifn=1:length(ff)
    fn=ff(ifn).name;
    fnn=[fn,'.not.mat'];
    
    if (~exist(fnn,'file'))
        continue;
    end
    disp(fn);
    load(fnn);

    p=findstr(labels,[PRENOTE,NOTE,POSTNOTE]);

    for ii = 1:length(p)
         note_cnt = note_cnt +1;       
         vlsorfn{note_cnt} = fn;
         vlsorind(note_cnt) = p(ii)+length(PRENOTE);
                
    end
     
end