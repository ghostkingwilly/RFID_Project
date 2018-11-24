clear;
clc;
close all;

Sim_Time = 1;
debug = 1;
% number of random rn16 samples
RAN_TIM = 1;
% slope
slope = 1;
% flag for verticle line
flag = 0; % non verticle
pplot = 1;

reader = [1,1];

% Need to be Random?
obj_num = 1;
usr_num = 1;
direction = 1;
phase_num = obj_num + usr_num;

mode = randi([1,3], 1, Sim_Time);
mode = mode - 1;

% initial 
result = [];
for i=1:Sim_Time
    [obj_tmp, usr_tmp] = Object_Phase_Operator(mode(i), RAN_TIM, slope, flag, reader, obj_num, usr_num, direction, debug, pplot);
    result = [result ; obj_tmp; usr_tmp];
end

name = [];

lab = [];

for i=1:Sim_Time
    if(mode(i) == 0)
        lab = [lab, 1];
    else
        lab = [lab, 0];
    end
end

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

%result = [1:length(result);result];
result_tmp = result.';

%return
csvwrite('../RNN_Model/out.csv', name_tmp);
%csvwrite('../RNN_Model/out.csv', result_tmp);
dlmwrite('../RNN_Model/out.csv', result_tmp, '-append');

csvwrite('../RNN_Model/label.csv', 'm');
dlmwrite('../RNN_Model/label.csv', lab.', '-append');

