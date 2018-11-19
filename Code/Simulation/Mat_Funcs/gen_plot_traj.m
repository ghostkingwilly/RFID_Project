function [output] = gen_plot_traj(X_ini, Y_ini, obj_mov_x, obj_mov_y, hand_mov_x, hand_mov_y, size, mod)
    
    % start from the min point
    ax_start = [min(X_ini) - 10, min(Y_ini) - 10];
    
    % find the max from whole points
    end_x = max([max(obj_mov_x(:)) max(hand_mov_x(:))]);
    end_y = max([max(obj_mov_y(:)) max(hand_mov_y(:))]);
    ax_end   = [end_x + 10, end_y + 10];
    
    % hand and obj initial points
    plot(X_ini(2:end), Y_ini(2:end), 'o');
    hold on;
    % Reader initial position
    plot(X_ini(1), Y_ini(1), 'x');
    hold on;
    
    for i=1:length(hand_mov_x(:,1))
        % hand and obj. moving plot
        h_hand = plot(hand_mov_x(i,:), hand_mov_y(i,:));
        set(h_hand,'LineStyle', '-', 'LineWidth', 0.5, 'Color', 'blue');
        hold on;
    end
    
    for i=1:length(obj_mov_x(:,1))
        h_obj = plot(obj_mov_x(i,:), obj_mov_y(i,:));
        set(h_obj,'LineStyle', '-', 'LineWidth', 0.5, 'Color', 'red');
        hold on;
    end
    grid on;
    
    % axis setting
    axis([ax_start(1) ax_end(1) ax_start(2) ax_end(2)]);
    
    title('Trajectory');
    legend({'Start','Hand','Object'},'FontSize', 6,'Location','northwest')
    legend('boxoff');
    xlabel('Movement(cm.)', 'Color', [0 0.5 0]);
    ylabel('Movement(cm.)', 'Color', [0 0.5 0]);
   
end