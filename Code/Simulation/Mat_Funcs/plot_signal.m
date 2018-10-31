clc
%clear all
close all
% 2: old
%fi_2 = fopen('send_rn16.bin','rb');
fi_2 = fopen('txrx_out.bin','rb');
%fi_2 = fopen('filter_samples.bin','rb');
%fi_1 = fopen('filter_samples_n.bin','rb');
fi_1 = fopen('txrx_out.bin','rb');% new raw data
%fi_1 = fopen('gate.bin','rb');
fi_1 = fopen('tx_samples.bin','rb');
%fi_1 = fopen('tx_samples.bin','rb');
%fi_1 = fopen('tmp.bin','rb');
x_inter_1 = fread(fi_1, 'float32');
x_inter_2 = fread(fi_2, 'float32');

% if data is comp��ex
x_1 = x_inter_1(1:2:end) + 1i*x_inter_1(2:2:end);
%x_1 = read_complex_binary('gate.bin');
figure;
plot(abs(x_1));
%figure;plot(angle(x_1));
%figure;plot(x_1);

%x_2 = x_inter_2(1:2:end) + 1i*x_inter_2(2:2:end);
x_2 = read_complex_binary('10query_samples_ntu.bin');
%x_2 = read_complex_binary('txrx_out.bin');
figure;
plot(abs(x_2));
%figure;plot(angle(x_2));

%x = read_complex_binary('filter_samples_n.bin');
%x = read_complex_binary('10query_samples_ntu.bin');
x_out = read_complex_binary('txrx_out.bin');
figure;
subplot(2,2,[1,2]);
plot(abs(x_out));
title('Raw Amplitude');

subplot(2,2,[3,4]);
plot(abs(x_2));
%title('Filter Amplitude');
title('NTU Amplitude');

%tx = read_complex_binary('filter_all.bin');
%figure;
%plot(abs(tx));

