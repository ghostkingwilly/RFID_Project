clc;clear;close all;

A = csvread('/home/nss-willy/Downloads/Score.csv');
addpath('./gaimc/');
A = A(2:end,2:end);

% Hungarian Algorithm
[a,b]=munkres(A);

good=0;bad = 0;
for i=1:length(a(:))
    if(a(i) == i)
        good = good + 1;
    else
        bad = bad + 1;
    end
end

hung_acc = good / (good + bad);

% bipartite matching algorithm
[val mi mj] = bipartite_matching(A); % figure out the rule

