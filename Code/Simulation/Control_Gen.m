clear;
clc;
close all;

Sim_Time = 2;
debug = 0;
% number of random rn16 samples
RAN_TIM = 2;
% slope
slope = 1;
% flag for verticle line
flag = 0; % non verticle
pplot = 0;

reader = [1,1];

% Need to be Random?
obj_num = 1;
usr_num = 1;
direction = 1;
phase_num = obj_num + usr_num;

mode = randi([1,3], 1, Sim_Time);
mode = mode - 1;
result = [];
for i=1:Sim_Time
    [obj_tmp, usr_tmp] = Object_Phase_Operator(mode(i), RAN_TIM, slope, flag, reader, obj_num, usr_num, direction, debug, pplot);
    result = [result ; obj_tmp; usr_tmp];
end

name = [];
for i=1:Sim_Time
    for j=1:RAN_TIM
        for k=1:phase_num
            n_tmp = [num2str(i), num2str(j), num2str(k)];
            name = [name; n_tmp];
        end
    end
end

%{
name = name.';

name = reshape(name, 1, numel(name));

name = strsplit(name);

name = name(1:length(name)-1);
%}
%cellstr(name);
%name_new = sprintf('%s', name{:});
name = str2num(name).';

%return;
result_tmp = result.';

%result_d = [result_tmp result(:,end)];
return
csvwrite('out.csv', name);
dlmwrite('out.csv', result, '-append');
%return;
%result = [name; result];

