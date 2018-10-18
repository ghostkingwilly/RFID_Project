function [phase_shift] = phase_cal(obj, reader, flag)
    
    % meter to centermeter
    LIGHT_SPEED = 3 * 1e10; 
    
    FREQ = 900 * 1e6;
    
    phase_precal = -2 * 1i * pi * FREQ;
    
    % flag 0 for origin phase(do not move)
    if(flag == 0)
        % Euclidean norm
        Read2obj = norm(abs(obj-reader));
        
        Read2obj_time = Read2obj / LIGHT_SPEED;
        
        phase_shift = angle((phase_precal * Read2obj_time));
    end
    
    % flag 1 for continue phase
    if(flag == 1)
        
        Read2obj_tra = obj - reader.';
        
        % The two-norm of each column
        Read2obj_dis = sqrt(sum(abs(Read2obj_tra).^2,1));
        
        Read2obj_dis_time = Read2obj_dis ./LIGHT_SPEED;
        
        phase_shift = angle(exp(phase_precal .* Read2obj_dis_time));
    end
    
end