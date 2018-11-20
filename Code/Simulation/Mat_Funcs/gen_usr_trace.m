function [out1, out2] = gen_usr_trace(num, xi, yi, pace, dis, dir, slope, flag, noise, inter, mod)
    
    PLOT_SIZE = dis / pace;
    
    for i = 1:num
        if(flag == 1) % vertical line
            out1(i,:) = xi(i) .* ones(1,(PLOT_SIZE)) + inter;
            yi_1_r = (yi(i)+pace * dir : pace * dir : (yi(i) + dis * dir));
            out2(i,:) = yi_1_r;
        elseif(mod == 3)
            out1(i,:) = (xi(i) : 0 : (xi(i) + dis));
            out2 = out1;
        else            
            y_shift_obj = yi(i) - slope .* xi(i);
            out1_tmp = (xi(i)+pace : pace : (xi(i) + dis));
            %out2(i,:) = (slope + inter) .* out1_tmp + y_shift_obj + noise;
            out2(i,:) = slope .* out1_tmp + y_shift_obj;
            out1(i,:) = out1_tmp;
        end
    end
end