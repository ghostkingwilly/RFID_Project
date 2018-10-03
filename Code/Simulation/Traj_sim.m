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

%% parameter

% frequency(900MHz)
FREQ = 900 * 10^6; % meter
% light speed
LS = 3 * 10^10;%(cm/s)

% mode (0 : linear; 1 : random)
mod = 0;
% time stamp
ts = 300;
% spread -> need more data
walk_des = 0.1;
% set the plane size 
PLOT_SIZE = 1000;

% reference point: reader
ref_xi = 0;
ref_yi = 0;

% setting starting index of obj and hand
obj_or_xi = 10;
obj_or_yi = 5;

hand_or_xi = 5;
hand_or_yi = -7;

%% plane with straight line

% reference point
reader = [ref_xi, ref_yi];
% subject initial point
obj_ini = [obj_or_xi, obj_or_yi];
% hand initial point
hand_ini = [hand_or_xi, hand_or_yi];

%% calculate the time shift

obj_origin_Tshift = time_shift(obj_ini, reader)
hand_origin_Tshift = time_shift(hand_ini, reader)



%% calculate the phase

obj_phase_origin = angle()
hand_phase_origin



%% plot the trajectory

ini_x = [ref_xi, obj_or_xi, hand_or_xi];
ini_y = [ref_yi, obj_or_yi, hand_or_yi];





