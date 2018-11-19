function [output] = input_function_Operat(num, in_msg)

    while(true)
        
        output = input(in_msg);
        if(isempty(output))
            output = num;
        end
        
        if(length(output) == 1)
            break;
        else
            disp('Please input in correct form.')
        end
        
    end
    
end