function [output] = gen_plot_phase(obj_p, hand_p, size)
    
    % Plot for static phase
    axis([0 size+50 -4 4]);
    
    for i=1:length(obj_p(:,1))
        plot(obj_p(i,:),'r');
        hold on;
    end
    for i=1:length(hand_p(:,1))
        plot(hand_p(i,:), 'bl');
    end
    
    title('Static Phase Range');
    legend({'Object','Hand'},'FontSize', 6,'Location','southeast')
    legend('boxoff');
    xlabel('Time (sec.)', 'Color', [0 0.5 0]);
    ylabel('Phase (rad.)', 'Color', [0 0.5 0]);
    
end