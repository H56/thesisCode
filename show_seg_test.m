clear; close all; clc;

files_root_path = 'music_pieces/';
all_files = dir(fullfile(files_root_path, '*.wav'));
count = length(all_files);

times = 100;
n = [44 88];
num_watermark = 10;
num_slice = 10;
Lpn = 1023;
a = 0.002;
snr = 0;

count1 = 0;
count2 = 0;
srn1 = 0;
srn2 = 0;
% count_water = 0;
[x, fs] = wavread(strcat(files_root_path, all_files(randi(count, 1, 1)).name));
Lseg = floor(length(x) / 10);
index = randi(10, 1, 1);
x_seg = x((index - 1) * Lseg + 1 : index * Lseg);
key = PNSequence(1023);
kernel = echo_kernel(key, 0.002, 44);

y1 = conv(x_seg, kernel);
y1 = y1(1 : length(x_seg));

d1 = xcorr(ifft(log(abs(fft(y1)))), key);
d1 = d1(length(y1) + 1 : end - length(key));
d2 = xcorr(ifft(log(abs(fft(y1(1 : 4410))))), key);
d2 = d2(4410 + 1 : end - length(key));

figure; 
subplot(2, 1, 1);
plot(d1);
subplot(2, 1, 2);
plot(d2);
