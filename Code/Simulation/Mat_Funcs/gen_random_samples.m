function [filter_data_final] = gen_random_samples(phase, RN16_TIME, phase_size, user, GAP, pplot)

    % user: order of this user
    start = user-1;
    
    if(start ~= 0)
        for i=1:start
            filter_data(i,:) = 2*pi.*ones(1,i * GAP);
        end
        s = start * GAP;
    else
        s = 1;
    end
    
    % 16000 - 1250
    remain = GAP - RN16_TIME;
    % calculate the repeat time
    k = floor(length(phase) / GAP);

    
    for i=user:k
        filter_data(i,:) = [phase(s:s+1250-1), 2*pi.*ones(1,remain)];
        s = s+GAP;
    end

    % merge the rows of the filter data
    filter_data_d = reshape(filter_data.', 1, k*GAP);
    
    if(mod(length(phase), GAP) ~= 0)
        remain_sample = phase_size - length(filter_data_d);
        filter_data_final = [filter_data_d, 2*pi.*ones(1,remain_sample)];
    end
    
    
    if(pplot)
        figure();
        plot(filter_data_final);
    end
end