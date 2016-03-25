clear; close all; clc;

files_root_path = 'music_pieces/';
all_files = dir(fullfile(files_root_path, '*.wav'));
count = length(all_files);

times = 100;
n = [20 40 60 80 100 120 140 160 180 200 220 240 260 280 300 320
    340 360 380 400 420 440 460 480 500 520 540 560 580 600 620 640];
num_watermark = 32;
Lpn = 1023;
a = 0.002;
snr = 0;

result = zeros(3, 5);
% count_water = 0;
for t = 1 : times
    for i = 1 : count
		[x, fs] = audioread(strcat(files_root_path, all_files(i).name));
        k = PNSequence(Lpn);
        w = randi(2, 1, num_watermark) - 1;
        y1 = echo_encode(x, w, k, a, n(1 : 2));
		y1_a = wav_quantize(y1, 8);
		y1_aw = awgn(y1, 30, 'measured');
        w1 = echo_decode(y1, num_watermark, k, n(1 : 2));
		result(1, 1) = result(1, 1) + sum(w == w1);
		w1 = echo_decode(y1_a, num_watermark, k, n(1 : 2));
		result(2, 1) = result(2, 1) + sum(w == w1);
		w1 = echo_decode(y1_aw, num_watermark, k, n(1 : 2));
		result(3, 1) = result(3, 1) + sum(w == w1);
        
        y2 = multi_bits_encode(x, w, k, a, n(1 : 4));
		y2_a = wav_quantize(y2, 8);
		y2_aw = awgn(y2, 30, 'measured');
        w2 = multi_bits_decode(y2, num_watermark, k, n(1 : 4));
		result(1, 2) = result(1, 2) + sum(w == w2);
		w2 = multi_bits_decode(y2_a, num_watermark, k, n(1 : 4));
		result(2, 2) = result(2, 2) + sum(w == w2);
		w2 = multi_bits_decode(y2_aw, num_watermark, k, n(1 : 4));
		result(3, 2) = result(3, 2) + sum(w == w2);
        
        y3 = multi_bits_encode(x, w, k, a, n(1 : 8));
		y3_a = wav_quantize(y3, 8);
		y3_aw = awgn(y3, 30, 'measured');
        w3 = multi_bits_decode(y3, num_watermark, k, n(1 : 8));
		result(1, 3) = result(1, 3) + sum(w == w3);
		w3 = multi_bits_decode(y3_a, num_watermark, k, n(1 : 8));
		result(2, 3) = result(2, 3) + sum(w == w3);
		w3 = multi_bits_decode(y3_aw, num_watermark, k, n(1 : 8));
		result(3, 3) = result(3, 3) + sum(w == w3);
        
        y4 = multi_bits_encode(x, w, k, a, n(1 : 16));
		y4_a = wav_quantize(y4, 8);
		y4_aw = awgn(y4, 30, 'measured');
        w4 = multi_bits_decode(y4, num_watermark, k, n(1 : 16));
        result(1, 4) = result(1, 4) + sum(w == w4); 
		w4 = multi_bits_decode(y4_a, num_watermark, k, n(1 : 16));
        result(2, 4) = result(2, 4) + sum(w == w4); 
		w4 = multi_bits_decode(y4_aw, num_watermark, k, n(1 : 16));
        result(3, 4) = result(3, 4) + sum(w == w4); 
		
		y5 = multi_bits_encode(x, w, k, a, n(1 : 32));
		y5_a = wav_quantize(y5, 8);
		y5_aw = awgn(y5, 30, 'measured');
        w5 = multi_bits_decode(y5, num_watermark, k, n(1 : 32));
        result(1, 5) = result(1, 5) + sum(w == w5); 
		w5 = multi_bits_decode(y5_a, num_watermark, k, n(1 : 32));
        result(2, 5) = result(2, 5) + sum(w == w5); 
		w5 = multi_bits_decode(y5_aw, num_watermark, k, n(1 : 32));
        result(3, 5) = result(3, 5) + sum(w == w5); 
        if mod(i, 50) == 0
            disp([t i]);
            disp(result / (((t - 1) * count + i) * num_watermark) * 100);
        end
    end
    disp(t);
	disp(result / (count * t * num_watermark) * 100);
end
result = result / (count * times * num_watermark) * 100;
disp(result);
save('/home/wujing/hupeng/result/multi_test_for1.mat');
