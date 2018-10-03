function [time_shift] = time_shift(obj, reader)
    
    LIGHT_SPEED = 3 * 1e10; % meter to centermeter

    Obj2Read = norm(abs(obj - reader));
    
    time_shift = Obj2Read ./ LIGHT_SPEED;
end