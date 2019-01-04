clear;
clc;
close all;

Sim_Time = 50; % 400
debug = 0;
% number of random rn16 samples
RAN_TIM = 1;
% slope for random 
slp = 5;
%ran_a = -slp; ran_b = slp;

% reader random size
ran_X_a = -30; ran_X_b = 30;
ran_Y_a = -40; ran_Y_b = 40;

% flag for verticle line
flag = 0; % non verticle
pplot = 0;

% reader for matching score
reader = [15,20];

obj_num = 1;
usr_num = 1;
direction = 1;
phase_num = obj_num + usr_num;

num = 0;
% mode for matching score
mode = zeros(1,Sim_Time);
mode = mode + num;

% initial 
obj = [];
hand = [];
slp = 1;
for i=1:Sim_Time
    if (i<5)
        slp = slp + 1;
    else
        slp = slp - 3;
    end
    [obj_tmp, usr_tmp] = Object_Phase_Operator(mode(i), RAN_TIM, slp, flag, reader, obj_num, usr_num, direction, debug, pplot);
    obj = [obj ; obj_tmp];
    % zeros for the appending obj
    hand = [hand ; zeros(1,length(usr_tmp(:))); usr_tmp];
end


name = [];
cnt = Sim_Time * RAN_TIM * usr_num * 2;

for i=1:cnt
    name = [name;i];
end

name_o = [];
cnt = Sim_Time * RAN_TIM * obj_num;

for i=1:cnt
    name_o = [name_o;i];
end

%return
csvwrite('/home/nss-willy/Downloads/ML_Data/obj.csv', name_o.');
dlmwrite('/home/nss-willy/Downloads/ML_Data/obj.csv', obj.', '-append');

csvwrite('/home/nss-willy/Downloads/ML_Data/hand.csv', name.');
dlmwrite('/home/nss-willy/Downloads/ML_Data/hand.csv', hand.', '-append');

%csvwrite('/home/nss-willy/Downloads/ML_Data/label_asrt.csv', 'm');
%dlmwrite('/home/nss-willy/Downloads/ML_Data/label_asrt.csv', lab.', '-append');

