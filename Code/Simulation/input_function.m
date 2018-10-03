function [output] = input_function(ini_x, ini_y, in_msg)

    while(true)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % must input: [x y] 
        % x: initial x-coordinate
        % y: initial y-coordinate
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        output = input(in_msg);
        
        if(isempty(output))
            output = [ini_x ini_y];
        end
        
        if(length(output) == 2)
            break;
        else
            disp('Please input [x y].')
        end
        
    end
    
end