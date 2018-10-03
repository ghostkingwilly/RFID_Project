%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Traj_sim.m
% function call: time_shift.m, plot_traj.m
%
% A detailed write-up of this example is available on the github:
% http://warpproject.org/trac/wiki/WARPLab/Examples/OFDM
%
% Copyright (c) 2015 Mango Communications - All Rights Reserved
% Distributed under the WARP License (http://warpproject.org/license)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
clc;
close all;

%% parameter

% time stamp
walk_dis = 300;
% spread -> need more data
walk_des = 0.1; % cm/s
% set the plane size 
PLOT_SIZE = 1000;

% setting the initial information
reader = input_function(0, 0, 'Origin Reader (default [0 0]): ');
obj_ini = input_function(10, 5, 'Origin Object (default [10 5]): ');
hand_ini = input_function(5, -7, 'Origin Hand (default [5 -7]): ');

mod = input('Test mode(default 0(linear)): ');
if(isempty(mod))
    mod = 0;
end

%% Transfer the coordinate from input

% reference point
ref_xi = reader(1);
ref_yi = reader(2);
% subject initial point
obj_or_xi = obj_ini(1);
obj_or_yi = obj_ini(2);
% hand initial point
hand_or_xi = hand_ini(1);
hand_or_yi = hand_ini(2);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Moving trajectory setting
% mode 0: object and hand both linear move
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(mod == 0) % linear: y = ax + b 
    
    slope = 2; % slope
    
    % find b
    y_shift_obj = obj_or_yi - slope * obj_or_xi;
    y_shift_hand = hand_or_yi - slope * hand_or_xi; 

    % generate x
    xi_1 = (obj_or_xi : walk_des : (obj_or_xi + walk_dis));
    xi_2 = (hand_or_xi : walk_des : (hand_or_xi + walk_dis));
    
    % generate y
    yi_1 = slope .* xi_1 + y_shift_obj;
    yi_2 = slope .* xi_2 + y_shift_hand;
    
elseif(mod == 1) % random
    ran_1 = 4;
    ran_2 = 4;
    yi_1 = rand(1,ts/walk_dis)*ran_1 + (obj_or_yi-ran_1/2);
    yi_2 = rand(1,ts/walk_dis)*ran_2 + (hand_or_yi-ran_2/2);
    
end

obj_mov = [xi_1; yi_1];
hand_mov = [xi_2; yi_2];

%% calculate the phase

obj_phase = phase_cal(obj_mov, reader, 1);
hand_phase = phase_cal(hand_mov, reader, 1);

%% plot the trajectory

ini_x = [ref_xi, obj_or_xi, hand_or_xi];
ini_y = [ref_yi, obj_or_yi, hand_or_yi];

plot_traj(ini_x, ini_y, PLOT_SIZE, obj_mov, hand_mov);

figure();
plot(obj_phase,'r');
hold on;
plot(hand_phase, 'bl');
title('Phase change');



