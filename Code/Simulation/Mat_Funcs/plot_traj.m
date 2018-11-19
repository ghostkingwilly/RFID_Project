function [output] = plot_traj(X_ini, Y_ini, obj_mov, hand_mov, size, mod, fast)
    
    % subplot for the upper block
    ax2 = subplot(2,1,1);
    
    % axis setting
    % start from the min point
    ax_start = [min(X_ini) - 10, min(Y_ini) - 10];
    
    % find the max from whole points
    end_x = max([max(obj_mov(1,:)) max(hand_mov(1,:))]);
    end_y = max([max(obj_mov(2,:)) max(hand_mov(2,:))]);
    ax_end   = [end_x + 10, end_y + 10];
    axis([ax_start(1) ax_end(1) ax_start(2) ax_end(2)]);
    
    % hand and obj initial points
    plot(X_ini(2:3), Y_ini(2:3), 'o');
    hold on;
    % Reader initial position
    plot(X_ini(1), Y_ini(1), 'x');
    hold on;
    
    % hand and obj. moving plot
    h_hand = plot(hand_mov(1,:), hand_mov(2,:));
    set(h_hand,'LineStyle', '-', 'LineWidth', 0.5, 'Color', 'blue');
    hold on;
    h_obj = plot(obj_mov(1,:), obj_mov(2,:));
    set(h_obj,'LineStyle', '-', 'LineWidth', 0.5, 'Color', 'red');
    hold on;
    
    grid on;
    title('Static Trajectory');
    legend({'Start','Hand','Object'},'FontSize', 6,'Location','northwest')
    legend('boxoff');
    xlabel(ax2,'Movement(cm.)', 'Color', [0 0.5 0]);
    ylabel(ax2,'Movement(cm.)', 'Color', [0 0.5 0]);
    
    % second subplot at bottom for animate
    ax1 = subplot(2,1,2);
    grid on;
    plot(X_ini(2:3), Y_ini(2:3), 'o', 'Color', [0 0 0]);
    hold on;
    plot(X_ini(1), Y_ini(1), 'x', 'Color', [0 0 0]);
    hold on;
    
    % animatedline tool
    h = animatedline();
    h1 = animatedline();
    axis([ax_start(1) ax_end(1) ax_start(2) ax_end(2)]);
    grid on;
    
    title('Dynamic Trajectory');
    legend({'Start.O.H.', 'Start','Object','Hand'},'FontSize', 6,'Location','northwest')
    legend('boxoff');
    xlabel(ax1,'Movement(cm.)', 'Color', [0 0.5 0]);
    ylabel(ax1,'Movement(cm.)', 'Color', [0 0.5 0]);
    
    for t = 1:size+1
        addpoints(h1,hand_mov(1,t),hand_mov(2,t));
        % mod 0 for obj. moving
        if(mod ~= 2)
            addpoints(h,obj_mov(1,t),obj_mov(2,t));
        end
        h.Color = 'r';
        h1.Color = 'b';
        drawnow limitrate;
        
        % fast = 1 for plotting faster
        if(fast == 1)
            pause(5/10000);
        end
    end
   
end