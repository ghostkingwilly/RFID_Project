function [output] = plot_traj(X_ini, Y_ini, plot_size, obj_mov, hand_mov)
    
    xlim([0 length(plot_size)]);
    ylim([0 length(plot_size)]);
    
    plot(X_ini, Y_ini, 'o');
    hold on;
    plot(obj_mov(1,:), obj_mov(2,:), '.');
    hold on;
    plot(hand_mov(1,:), hand_mov(2,:), '.');
    hold on;
    
    grid on;
    title('Trajectory');
    legend({'start','Object','Hand'},'Location','southwest')

end