function [output] = gen_plot_phase(obj_p, hand_p, size)
    
    % Plot for static phase
    axis([0 size+50 -4 4]);
    title_name = ' Phase';
    for i=1:length(obj_p(:,1))
        plot(obj_p(i,:),'r');
        title(['Object ',int2str(i),title_name]);
        xlabel('Time (sec.)', 'Color', [0 0.5 0]);
        ylabel('Phase (rad.)', 'Color', [0 0.5 0]);
        figure();
    end
    
    for i=1:length(hand_p(:,1))
        plot(hand_p(i,:), 'bl');
        title(['User ',int2str(i),title_name]);
        xlabel('Time (sec.)', 'Color', [0 0.5 0]);
        ylabel('Phase (rad.)', 'Color', [0 0.5 0]);
        if(i == length(hand_p(:,1)))
            break;
        end
        figure();
    end
end