function jc_fndlbl(vlsorind, vlsorfn, ind, newsyll,targetsyl)
%use with jc_vlsorfn and jc_chcklbl to replace syllable labels

% displayfn = input(['display filename instead of change syllable to ',newsyll,'?:'],'s');

for i = 1:length(ind)
%     if ~exist([vlsorfn{ind(i)},'.not.mat'])
%         disp(vlsorfn{ind(i)})
%     else 
%         if displayfn == 'y'
%             disp(['check ',vlsorfn{ind(i)}]);
%         else
            load([vlsorfn{ind(i)},'.not.mat']);
%             load([vlsorfn{ind(i)},'.tinfo.mat']);
            %replace triggers in tinfo file
%             thisfiletriggers = find(labels==targetsyl);
%             ixtodelete = find(thisfiletriggers == (vlsorind(ind(i))));
%             if isempty(ixtodelete)
%                 fprintf('did not find trigger!!!!\n')
%             end
%             triginfo.ttimes(ixtodelete) = [];
%             triginfo.tfreq(ixtodelete) = [];
%             fprintf('deleted trigger %d of %d from %s \n',ixtodelete,length(thisfiletriggers),vlsorfn{ind(i)})
%             save([vlsorfn{ind(i)},'.tinfo.mat'],'triginfo');
            %replace labels in notmat
            labels(vlsorind(ind(i))) = newsyll;
            save([vlsorfn{ind(i)},'.not.mat'],'labels','-append');
%         end
%     end
end



