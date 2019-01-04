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

%clear;
%clc;
%close all;

function[obj_final, hand_final] = Object_Phase_Operator(mod, RAN_TIM, slope, flag, reader, obj_num, user_num, direction, debug, pplot)

    % add the path to include the functions
    addpath('./Mat_Funcs/');

    %% Parameter
    %debug = 1; 
    % time stamp
    %WALK_DIS = 55;
    WALK_DIS = 1000;
    % spread -> need more data
    %WALK_PACE = 0.02; % cm/s
    WALK_PACE = 0.02; % cm/s
    % set the plane size 
    PLOT_SIZE = WALK_DIS / WALK_PACE;
    
    if(debug)
        pplot = 0;
        % number of random rn16 samples
        RAN_TIM = 1;
        slope = 5;
        % flag for verticle line
        flag = 0; % non verticle
    end

    % sample time
    TOT_SAM = 15789;
    QUERY = 6754;
    RN16 = 1250;

    %% Input Setting
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Reader
    % setting reader initial coordinate [1 1]
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
    if(debug)
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
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Setting the initial information
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Object number
        obj_num = input_function_Operat(1, 'Number of Object: '); % # of object = 1
        % User number
        user_num = input_function_Operat(1, 'Number of User: '); % # of user = 1

        % Mode dicision
        mod = input('Test mode(default 0(linear)): ');
        if(isempty(mod))
            mod = 0;
        end

        % Flag for control the vertical and horizontal line
        % direction for the direction of vertical line
        direction = 1;
        if(flag)
            direction = input('Direction(1 or -1): ');
            if(isempty(direction))
               direction = 1; 
            end    
        end
    end
    %% Generate the initial location of the user and object

    % Most Random
    for i=1:1:obj_num
        s = rng;
        obj_x_rdm = randi([uint16(reader(1))-5, uint16(reader(1))+5],1,1);
        obj_y_rdm = randi([uint16(reader(2))-5, uint16(reader(2))+5],1,1);
        obj_ini(i,:) = [i, obj_x_rdm , obj_y_rdm];
    end

    for i=1:1:user_num
        usr_x_rdm = randi([uint16(reader(1))-5 uint16(reader(1))+5],1,1);
        usr_y_rdm = randi([uint16(reader(2))-5 uint16(reader(2))+5],1,1);
        usr_ini(i,:) = [i, usr_x_rdm , usr_y_rdm];
    end

    %{
    % Object initial position
    % horizon
    if(flag == 0)
        % Object initial place
        %obj_ini_tmp = randi([uint16(reader(1))-10 uint16(reader(1))+10], 1, 1);
        obj_ini_tmp = -1; % [2 -1] for debug
        for i=1:1:obj_num
            % Start from 
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
    %}

    % debugging: the first user: debug[1.5 -0.5]
    obj_ini(1,:) = [1 2 -1];
    usr_ini(1,:) = [1 1.5 -3.5];

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
    % mode 2: two unknown tags move along different direction
    % mode 3: two tags freeze
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % random upper bound and lower bound
    ran_a = -0.5; ran_b = 0.5;
    noise = (ran_b-ran_a).*rand(1,PLOT_SIZE)+ran_a;

    r_a = 0.9; r_b = 1.07;
    interference = (r_b-r_a).*rand(1,PLOT_SIZE)+r_a;

    ran_aa = -slope; ran_bb = slope;
    slope_f = (ran_bb-ran_aa).*rand(1,1)+ran_aa;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  01/03 debug
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %slope_f = slope;
    
    % function for generate the trajectory (staff_number, object_initial_place_x, object_initial_place_y, pace, distance, slope, flag, noise, interference, mode)
    [obj_mov_x, obj_mov_y] = gen_obj_trace(obj_num, obj_or_xi, obj_or_yi, WALK_PACE, WALK_DIS, direction, slope_f, flag, noise, interference, mod);
    [hand_mov_x,hand_mov_y] = gen_usr_trace(user_num,usr_or_xi,usr_or_yi, WALK_PACE, WALK_DIS, direction, slope_f, flag, noise, interference, mod);

    % append the initial position before the generated trajectory
    obj_mov_x = [obj_or_xi, obj_mov_x]; 
    obj_mov_y = [obj_or_yi, obj_mov_y];

    hand_mov_x = [usr_or_xi, hand_mov_x]; 
    hand_mov_y = [usr_or_yi, hand_mov_y];

    %% Phase Calculation

    % obj. do not move
    if(mod == 1 || mod == 3) 
        % last flag 1 for moving phase
        obj_phase_tmp = gen_phase_cal(obj_or_xi, obj_or_yi, reader, 0);
        obj_phase = obj_phase_tmp .* ones(1,(PLOT_SIZE+1));
    % object is taken away
    else
        obj_phase = gen_phase_cal(obj_mov_x, obj_mov_y, reader, 1);
    end
    
    if(mod == 3) % hand don't move
        % last flag 1 for moving phase
        usr_phase_tmp = gen_phase_cal(usr_or_xi, hand_mov_x, reader, 0);
        hand_phase = usr_phase_tmp .* ones(1,(PLOT_SIZE+1));
    else
        hand_phase = gen_phase_cal(hand_mov_x, hand_mov_y, reader, 1);
    end
    
    %% AoA Calculation
    
    % AoA error
    s = rng;
    aoa_error = normrnd(0,3.8,[1,PLOT_SIZE+1]);  % error 10
    %aoa_error = normrnd(0,5,[1,PLOT_SIZE+1]);    % error 15
    %aoa_error = normrnd(0,6.1,[1,PLOT_SIZE+1]); % error 20
    for k=1:obj_num
        % don't move
        if (mod == 1 || mod == 3)
            % obj coordinate combine
            obj = [obj_or_xi;obj_or_yi];
            % reader to obj
            Read2obj = norm(abs(obj-reader));
            %x lam
            x_lam = obj_or_xi - reader(1);
            if (obj_or_yi >= reader)    
                obj_aoa_tmp = abs(acos(x_lam/Read2obj)*180/pi);
            else
                obj_aoa_tmp = 360 - abs(acos(x_lam/Read2obj)*180/pi);
            end
            obj_final = obj_aoa_tmp.* ones(1,(PLOT_SIZE+1)) + aoa_error;
        % move 
        else
            obj = [obj_mov_x(k,:); obj_mov_y(k,:)];
            Read2obj_tra = obj - reader.';

            % The two-norm of each column
            Read2obj_dis = sqrt(sum(abs(Read2obj_tra).^2,1));
            x_lam = obj_mov_x(k,:) - reader(1);

            for i=1:length(obj_mov_x)
                if (obj_mov_y(k,i) >= reader(2))
                    obj_final(k,i) = abs(acos(x_lam(i)/Read2obj_dis(i))*180/pi) + aoa_error(i);
                else
                    obj_final(k,i) = 360 - abs(acos(x_lam(i)/Read2obj_dis(i))*180/pi) + aoa_error(i);
                end
            end

        end
    end

    % General Version
    for k=1:user_num
        if (k ~= 1)
            aoa_error = normrnd(0,3.8,[1,PLOT_SIZE+1]);
        end
        % hand don't move
        if (mod == 3)
            % obj coordinate combine
            hand = [usr_or_xi;usr_or_yi];
            % reader to obj
            Read2hand = norm(abs(hand-reader));
            %x lam
            x_lamh = usr_or_xi - reader(1);
            if (usr_or_yi >= reader)    
                hand_aoa_tmp = abs(acos(x_lamh/Read2obj)*180/pi);
            else
                hand_aoa_tmp = 360 - abs(acos(x_lamh/Read2hand)*180/pi);
            end
            hand_final = hand_aoa_tmp.* ones(1,(PLOT_SIZE+1)) + aoa_error;
        % move 
        else
            hand = [hand_mov_x(k,:);hand_mov_y(k,:)];
            Read2hand_tra = hand - reader.';

            % The two-norm of each column
            Read2hand_dis = sqrt(sum(abs(Read2hand_tra).^2,1));
            x_lamh = hand_mov_x(k,:) - reader(1);

            for i=1:length(hand_mov_x)
                if (hand_mov_y(k,i) >= reader(2))
                    hand_final(k,i) = abs(acos(x_lamh(i)/Read2hand_dis(i))*180/pi) + aoa_error(i);
                else
                    hand_final(k,i) = 360 - abs(acos(x_lamh(i)/Read2hand_dis(i))*180/pi) + aoa_error(i);
                end
            end

        end
    end
    %gen_plot_traj(ini_x, ini_y, obj_mov_x, obj_mov_y, hand_mov_x, hand_mov_y, PLOT_SIZE, mod);
    %hold on;
    %figure();
    %gen_plot_phase(obj_final, hand_final, PLOT_SIZE);
    %figure();
    %% Trajectory and Phase Plot
%{
    gen_plot_traj(ini_x, ini_y, obj_mov_x, obj_mov_y, hand_mov_x, hand_mov_y, PLOT_SIZE, mod);

    figure();
    gen_plot_phase(obj_phase, hand_phase, PLOT_SIZE);
%}

%{
    %% Mask
    % phase size
    obj_phase_size = length(obj_phase);
    hand_phase_size = length(hand_phase);

    % received samples
    RN16_TIME =  1250;
    % total received samples
    GAP = 1260;

    % count the number of tag
    tag_number = obj_num + user_num;

    for i=1:RAN_TIM
        % decide the tag order
        ran_user = randperm(tag_number);
        
        obj_final(i,:) = [gen_random_samples(obj_phase, RN16_TIME, obj_phase_size, ran_user(1), GAP, pplot)];
        hand_final(i,:) = [gen_random_samples(hand_phase, RN16_TIME, hand_phase_size, ran_user(2), GAP, pplot)];
    end

    QUERY_TIME = round(QUERY/(2*1e6)*10000);
    TOT_SAM_TIME = round(TOT_SAM/(2*1e6)*10000);
%}
end
