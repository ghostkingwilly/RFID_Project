clear;
clc;
close all;

Sim_Time = 10; % 400
debug = 0;
% number of random rn16 samples
RAN_TIM = 1;
% slope for random 
slp = 5;
ran_a = -slp; ran_b = slp;

% reader random size
ran_X_a = -30; ran_X_b = 30;
ran_Y_a = -40; ran_Y_b = 40;

% flag for verticle line
flag = 0; % non verticle
pplot = 0;

%reader = [5,0];

% Need to be Random?
obj_num = 1;
usr_num = 1;
direction = 1;
phase_num = obj_num + usr_num;

%debug
mode = randi([1,4], 1, Sim_Time);
%mode = randi([1,3], 1, Sim_Time);
mode = mode - 1;

% initial 
result = [];
DTW = [];
croscorr = [];
for i=1:Sim_Time
    slope = (ran_b-ran_a).*rand(1,1)+ran_a;
    reader = [(ran_X_b-ran_X_a).*rand(1,1)+ran_X_a, (ran_Y_b-ran_Y_a).*rand(1,1)+ran_Y_a];
    [obj_tmp, usr_tmp] = Object_Phase_Operator(mode(i), RAN_TIM, slope, flag, reader, obj_num, usr_num, direction, debug, pplot);
    %DTW = [DTW; dtw(obj_tmp(1:1250), usr_tmp(4001:5250))];
    %croscorr = [croscorr; xcorr(obj_tmp(1:1250), usr_tmp(4001:5250))];
    result = [result ; obj_tmp; usr_tmp];
end


name = [];
%{
for i=1:Sim_Time
    for j=1:RAN_TIM
        for k=1:phase_num
            if(mod(k,2) == 0)
                name = [name; 'o'];
            else
                name = [name; 'h'];
            end
        end
    end
end

%name = [num2str(length(name));name];
name_tmp = name.';
%}
cnt = Sim_Time * RAN_TIM * phase_num;

for i=1:cnt
    name = [name;i];
end

lab = [];

for i=1:Sim_Time
    if(mode(i) == 0)
        lab = [lab, 1];
    else
        lab = [lab, 0];
    end
end

%result = [1:length(result);result];

return
csvwrite('/home/nss-willy/Downloads/ML_Data/out.csv', name.');
dlmwrite('/home/nss-willy/Downloads/ML_Data/out.csv', result.', '-append');

%csvwrite('../RNN_Model/out.csv', name_tmp);
%csvwrite('../RNN_Model/out.csv', result_tmp);
%dlmwrite('../RNN_Model/out.csv', result_tmp, '-append');

csvwrite('/home/nss-willy/Downloads/ML_Data/label.csv', 'm');
dlmwrite('/home/nss-willy/Downloads/ML_Data/label.csv', lab.', '-append');

%csvwrite('../RNN_Model/label.csv', 'm');
%dlmwrite('../RNN_Model/label.csv', lab.', '-append');



