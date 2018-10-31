%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Object_Phase_Operator.m
% function call
% gen_phase_cal.m    gen_obj_trace.m
% gen_plot_traj.m    gen_usr_trace.m
% gen_plot_phase.m
% input_finctionOperator.m
%
% A detailed write-up of this example is available on the github:
% https://github.com/ChenFaHaung/RFID_Project/tree/master/Code/Simulation
%
% Copyright (c) 2018 NCTU-NSSLab - All Rights Reserved
% Distributed under the USRP License (https://files.ettus.com/manual/)
% 
% Editor: Willy ChengFa Huang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
clc;
close all;

% add the path to include the functions
addpath('./Mat_Funcs/');

%% Parameter

% time stamp
WALK_DIS = 30;
% spread -> need more data
WALK_PACE = 0.1; % cm/s
% set the plane size 
PLOT_SIZE = WALK_DIS / WALK_PACE;

% sample time
TOT_SAM = 15789;
QUERY = 6754;
RN16 = 1100;

% slope
slope = 1; 
% flag for verticle line
flag = 0; % non verticle

% setting reader initial coordinate [1 1]
while(true)
    reader = input('Origin Reader: ');

    if(isempty(reader))
        reader = [1 1];
    end

    if(length(reader) == 2)
        break;
    else
        disp('Please input [x y].')
    end

end

% setting the initial information
obj_num = input_function_Operat(1, 'Number of Object: '); % # of object = 1
user_num = input_function_Operat(1, 'Number of User: '); % # of user = 1

mod = input('Test mode(default 0(linear)): ');
if(isempty(mod))
    mod = 0;
end

direction = 1;
if(flag)
    direction = input('Direction(1 or -1): ');
    if(isempty(direction))
       direction = 1; 
    end    
end

%% Generate the initial location of the user and object

% Object initial position
% horizon
if(flag == 0)
    % Object initial place
    %obj_ini_tmp = randi([uint16(reader(1))-10 uint16(reader(1))+10], 1, 1);
    obj_ini_tmp = -1; % [2 -1] for debug
    for i=1:1:obj_num
        obj_ini(i,:) = [i (reader(1) + i) obj_ini_tmp];
    end
% vertical
else
    % Object initial place
    obj_ini_tmp = randi([uint16(reader(2))-10 uint16(reader(2))+10], 1, 1);
    for i=1:1:obj_num
        obj_ini(i,:) = [i obj_ini_tmp (reader(1) + i)];
    end
end

% user initial position
% object on the shelf besides the wall
if(obj_ini(1,3)>reader(2))
    for i=1:1:user_num
        usr_x_rdm = randi([uint16(reader(1))-10 uint16(reader(2))+10],1,1);
        usr_y_rdm = randi([uint16(reader(1))-10 obj_ini(1,3)-2],1,1);
        usr_ini(i,:) = [i, usr_x_rdm , usr_y_rdm];
    end
else
    for i=1:1:user_num
        usr_x_rdm = randi([uint16(reader(1))-10 uint16(reader(1))+10],1,1);
        usr_y_rdm = randi([obj_ini(1,3)+2 uint16(reader(1))+10],1,1);
        usr_ini(i,:) = [i, usr_x_rdm , usr_y_rdm];
    end
end

% the first user: debug[1.5 -0.5]
usr_ini(1,:) = [1 1.5 -0.5];

% transform the coordinate
ref_xi = reader(1);
ref_yi = reader(2);

% get corridinate excluded the object number
obj_or_xi = obj_ini(:,2);
obj_or_yi = obj_ini(:,3);

% get corridinate excluded the user number
usr_or_xi = usr_ini(:,2);
usr_or_yi = usr_ini(:,3);

% create the initial position vector
ini_x = [reader(1);obj_ini(:,2); usr_ini(:,2)];
ini_y = [reader(2);obj_ini(:,3); usr_ini(:,3)];
%return;
%% Tags Trace Generation

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Moving trajectory setting
% mode 0: object and hand both move linearly with adding noise and interference
% mode 1: only hand move linearly
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% random upper bound and lower bound
ran_a = -0.5; ran_b = 0.5;
noise = (ran_b-ran_a).*rand(1,PLOT_SIZE)+ran_a;

r_a = 0.9; r_b = 1.07;
interference = (r_b-r_a).*rand(1,PLOT_SIZE)+r_a;

% function for generate the trajectory (staff_number, object_initial_place_x, object_initial_place_y, pace, distance, slope, flag, noise, interference, mode)
[obj_mov_x, obj_mov_y] = gen_obj_trace(obj_num, obj_or_xi, obj_or_yi, WALK_PACE, WALK_DIS, direction, slope, flag, noise, interference, mod);
[hand_mov_x,hand_mov_y] = gen_usr_trace(user_num, usr_or_xi, usr_or_yi, WALK_PACE, WALK_DIS, direction, slope, flag, noise, interference, mod);

% append the initial position before the generated trajectory
obj_mov_x = [obj_or_xi, obj_mov_x]; 
obj_mov_y = [obj_or_yi, obj_mov_y];

hand_mov_x = [usr_or_xi, hand_mov_x]; 
hand_mov_y = [usr_or_yi, hand_mov_y];

%% Phase Calculation

% obj. do not move
if(mod == 1) 
    % last flag 1 for moving phase
    obj_phase_tmp = gen_phase_cal(obj_or_xi, obj_or_yi, reader, 0);
    obj_phase = obj_phase_tmp .* ones(1,(PLOT_SIZE+1));
% object is taken away
else
    obj_phase = gen_phase_cal(obj_mov_x, obj_mov_y, reader, 1);
end

% users always move
hand_phase = gen_phase_cal(hand_mov_x, hand_mov_y, reader, 1);

%% Trajectory and Phase Plot

gen_plot_traj(ini_x, ini_y, obj_mov_x, obj_mov_y, hand_mov_x, hand_mov_y, PLOT_SIZE, mod);

figure();
gen_plot_phase(obj_phase, hand_phase, PLOT_SIZE);

return;
%% Mask

QUERY_TIME = QUERY/(2*1e6);
TOT_SAM_TIME =  TOT_SAM/(2*1e6);
RN16_TIME =  RN16/(2*1e6);

mask_num = round(length(hand_phase) / TOT_SAM_TIME);

% count the number of tag
tag_number = obj_num + user_num;
% random which tag 
mask_tmp = randi([0,tag_number],1,mask_num).';

return
% create the mask 

