clear; close all; clc;

files_root_path = 'music_pieces/';
all_files = dir(fullfile(files_root_path, '*.wav'));
count = length(all_files);

times = 100;
n = [20 40 60 80 100 120 140 160 180 200 220 240 260 280 300 320
    340 360 380 400 420 440 460 480 500 520 540 560 580 600 620 640];
num_watermark = 8;
Lpn = 1023;
a = 0.002;
snr = 0;

result = zeros(3, 5);
% count_water = 0;
for t = 1 : times   
    for i = 1 : count
		[x, fs] = wavread(strcat(files_root_path, all_files(i).name));
        k = PNSequence(Lpn);
        w = randi(2, 1, num_watermark) - 1;
        y1 = echo_encode(x, w, k, a, n(1 : 2));
		y1_a = 1.8 * y1;
        audiowrite('tmp.m4a', y1, fs);
        [y1_aw, ~] = audioread('tmp.m4a');
        y1_aw = y1_aw(1 : length(x));
% 		y1_aw = awgn(y1, 30, 'measured');
%         w1 = echo_decode(y1, num_watermark, k, n(1 : 2));
% 		result(1, 1) = result(1, 1) + sum(w == w1);
		w1 = echo_decode(y1_a, num_watermark, k, n(1 : 2));
		result(2, 1) = result(2, 1) + sum(w == w1);
		w1 = echo_decode(y1_aw, num_watermark, k, n(1 : 2));
		result(3, 1) = result(3, 1) + sum(w == w1);
        
        y2 = slice_encode(x, w, k, a, n(1 : 4), 2);
		y2_a = 1.8 * y2;
% 		y2_aw = awgn(y2, 30, 'measured');
%         w2 = slice_decode(y2, num_watermark, k, n(1 : 4), 2);
% 		result(1, 2) = result(1, 2) + sum(w == w2);
        audiowrite('tmp.m4a', y2, fs);
        [y2_aw, ~] = audioread('tmp.m4a');
        y2_aw = y2_aw(1 : length(x));
        w2 = slice_decode(y2_a, num_watermark, k, n(1 : 4), 2);
		result(2, 2) = result(2, 2) + sum(w == w2);
        w2 = slice_decode(y2_aw, num_watermark, k, n(1 : 4), 2);
		result(3, 2) = result(3, 2) + sum(w == w2);
        
        y3 = slice_encode(x, w, k, a, n(1 : 4), 4);
		y3_a = 1.8 * y3;
% 		y3_aw = awgn(y3, 30, 'measured');
%         w3 = slice_decode(y3, num_watermark, k, n(1 : 4), 4);
% 		result(1, 3) = result(1, 3) + sum(w == w3);
        audiowrite('tmp.m4a', y3, fs);
        [y3_aw, ~] = audioread('tmp.m4a');
        y3_aw = y3_aw(1 : length(x));
		w3 = slice_decode(y3_a, num_watermark, k, n(1 : 4), 4);
		result(2, 3) = result(2, 3) + sum(w == w3);
		w3 = slice_decode(y3_aw, num_watermark, k, n(1 : 4), 4);
		result(3, 3) = result(3, 3) + sum(w == w3);
        
        y4 = slice_encode(x, w, k, a, n(1 : 4), 8);
		y4_a = 1.8 * y4;
% 		y4_aw = awgn(y4, 30, 'measured');
%         w4 = slice_decode(y4, num_watermark, k, n(1 : 4), 8);
%         result(1, 4) = result(1, 4) + sum(w == w4); 
        audiowrite('tmp.m4a', y4, fs);
        [y4_aw, ~] = audioread('tmp.m4a');
        y4_aw = y4_aw(1 : length(x));
		w4 = slice_decode(y4_a, num_watermark, k, n(1 : 4), 8);
        result(2, 4) = result(2, 4) + sum(w == w4); 
		w4 = slice_decode(y4_aw, num_watermark, k, n(1 : 4), 8);
        result(3, 4) = result(3, 4) + sum(w == w4); 
		
		y5 = slice_encode(x, w, k, a, n(1 : 4), 10);
		y5_a = 1.8 * y5;
% 		y5_aw = awgn(y5, 30, 'measured');
%         w5 = slice_decode(y5, num_watermark, k, n(1 : 4), 10);
%         result(1, 5) = result(1, 5) + sum(w == w5); \
        audiowrite('tmp.m4a', y5, fs);
        [y5_aw, ~] = audioread('tmp.m4a');
        y5_aw = y5_aw(1 : length(x));
		w5 = slice_decode(y5_a, num_watermark, k, n(1 : 4), 10);
        result(2, 5) = result(2, 5) + sum(w == w5); 
		w5 = slice_decode(y5_aw, num_watermark, k, n(1 : 4), 10);
        result(3, 5) = result(3, 5) + sum(w == w5); 
    end
	disp(t);
    disp(result / (count * t * num_watermark) * 100);
end
result = result / (count * times * num_watermark) * 100;