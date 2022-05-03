function [  ] = lv_relabel_misses(check, old_syllable, new_syllable, presyllable)
%takes input from modified function check_stuff=lt_check_hit_templ_freq_v2_EvTAFv4Sim(batchf, syl, syl_pre, syl_post, get_WN_hits, get_offline_match, get_FF, config, NoteNum)
% will go through check_stuff.misses and relabel all missed syllables by
% new letter

for k = 1:size(check.misses,2)
    
    load([check.misses(k).fn '.not.mat'])
    ren = check.misses(k).renditions;
    if isempty(presyllable)
    syll_idx = findstr(labels,old_syllable);
    else
    syll_idx = strfind(labels,[presyllable old_syllable])+1;

    end
    labels(syll_idx(ren)) = new_syllable;                
    save([check.misses(k).fn '.not.mat'], 'labels', '-append')
    display([check.misses(k).fn '.not.mat has been changed'])

end

