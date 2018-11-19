function [filter_data] = gen_random_samples(phase, RN16_TIME, phase_size, chunck_candidate)

    if((chunck_candidate-1) == 0)
        start = 1;
    else
        start = (chunck_candidate-1) * RN16_TIME;
    end
    
    final = chunck_candidate * RN16_TIME;
    filter_data = [2*pi.*ones(1,start), phase(start:final), 2*pi.*ones(1,phase_size - final - 1)];
    
    figure;
    plot(filter_data);

end