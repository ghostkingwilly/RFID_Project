clear;
clc;
close all;

debug = 1;

if(debug)
    Sim_Time = 1;
else
    Sim_Time = 2;
end

% number of random rn16 samples
RAN_TIM = 4;
% slope
slope = 1;
% flag for verticle line
flag = 0; % non verticle

reader = [1,1];

% Need to be Random?
obj_num = 1;
usr_num = 1;
direction = 1;

if(debug)
    mod = 3;
else
    mode = randi([1,3], 1, Sim_Time);
    mode = mode - 1;
end

for i=1:Sim_Time
    Object_Phase_Operator(mode(i), RAN_TIM, slope, flag, reader, obj_num, usr_num, direction, debug);
end

%csvwrite();