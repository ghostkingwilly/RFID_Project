function [filter_data] = gen_random_samples(phase, RN16_TIME, phase_size, user, gap)

    if((user-1) == 0)
        start = 1;
    else
        start = (user-1) * gap;
    end
    
    % RN!6 1250  gap 16000
    % ------phase---16000---phase---16000---
    % phase--16000---phase--16000---phase---
    remain = gap - RN16_TIME;
    for i=start:gap:length(phase)
        filter_data = [phase(i:i+1250), 2*pi.*ones(1,remain)];
    end
    
    final = chunck_candidate * RN16_TIME;
    filter_data = [2*pi.*ones(1,start), phase(start:final), 2*pi.*ones(1,phase_size - final - 1)];
    
    figure;
    plot(filter_data);

end