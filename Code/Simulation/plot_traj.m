function [output] = plot_traj(X_ini, Y_ini, plot_size, obj_mov, hand_mov)
    
    xlim([0 length(plot_size)]);
    ylim([0 length(plot_size)]);

    figure()
    plot(X_ini, Y_ini, 'o');
    hold on;

    plot(xi_1, yi_1, '.');
    hold on;
    plot(xi_2, yi_2, '.');
    hold on;
    grid on;
    title('Trajectory');

end