clear; close all; clc;

files_root_path = 'music_pieces/';
all_files = dir(fullfile(files_root_path, '*.wav'));
count = length(all_files);

times = 100;
n = [20 40 60 80 100 120 140 160 180 200 220 240 260 280 300 320
    340 360 380 400 420 440 460 480 500 520 540 560 580 600 620 640];
num_watermark = 16;
Lpn = 1023;
a = 0.002;
snr = 0;

result = cell(1, times);
% count_water = 0;
parfor t = 1 : times
    r = zeros(3, 5);
    for i = 1 : count
		[x, fs] = audioread(strcat(files_root_path, all_files(i).name));
        k = PNSequence(Lpn);
        w = randi(2, 1, num_watermark) - 1;
        y1 = echo_encode(x, w, k, a, n(1 : 2));
		y1_a = wav_quantize(y1, 8);
		y1_aw = awgn(y1, 30, 'measured');
        w1 = echo_decode(y1, num_watermark, k, n(1 : 2));
		r(1, 1) = r(1, 1) + sum(w == w1);
		w1 = echo_decode(y1_a, num_watermark, k, n(1 : 2));
		r(2, 1) = r(2, 1) + sum(w == w1);
		w1 = echo_decode(y1_aw, num_watermark, k, n(1 : 2));
		r(3, 1) = r(3, 1) + sum(w == w1);
        
        y2 = multi_bits_encode(x, w, k, a, n(1 : 4));
		y2_a = wav_quantize(y2, 8);
		y2_aw = awgn(y2, 30, 'measured');
        w2 = multi_bits_decode(y2, num_watermark, k, n(1 : 4));
		r(1, 2) = r(1, 2) + sum(w == w2);
		w2 = multi_bits_decode(y2_a, num_watermark, k, n(1 : 4));
		r(2, 2) = r(2, 2) + sum(w == w2);
		w2 = multi_bits_decode(y2_aw, num_watermark, k, n(1 : 4));
		r(3, 2) = r(3, 2) + sum(w == w2);
        
        y3 = multi_bits_encode(x, w, k, a, n(1 : 8));
		y3_a = wav_quantize(y3, 8);
		y3_aw = awgn(y3, 30, 'measured');
        w3 = multi_bits_decode(y3, num_watermark, k, n(1 : 8));
		r(1, 3) = r(1, 3) + sum(w == w3);
		w3 = multi_bits_decode(y3_a, num_watermark, k, n(1 : 8));
		r(2, 3) = r(2, 3) + sum(w == w3);
		w3 = multi_bits_decode(y3_aw, num_watermark, k, n(1 : 8));
		r(3, 3) = r(3, 3) + sum(w == w3);
        
        y4 = multi_bits_encode(x, w, k, a, n(1 : 16));
		y4_a = wav_quantize(y4, 8);
		y4_aw = awgn(y4, 30, 'measured');
        w4 = multi_bits_decode(y4, num_watermark, k, n(1 : 16));
        r(1, 4) = r(1, 4) + sum(w == w4); 
		w4 = multi_bits_decode(y4_a, num_watermark, k, n(1 : 16));
        r(2, 4) = r(2, 4) + sum(w == w4); 
		w4 = multi_bits_decode(y4_aw, num_watermark, k, n(1 : 16));
        r(3, 4) = r(3, 4) + sum(w == w4); 
		
		y5 = multi_bits_encode(x, w, k, a, n(1 : 32));
		y5_a = wav_quantize(y5, 8);
		y5_aw = awgn(y5, 30, 'measured');
        w5 = multi_bits_decode(y5, num_watermark, k, n(1 : 32));
        r(1, 5) = r(1, 5) + sum(w == w5); 
		w5 = multi_bits_decode(y5_a, num_watermark, k, n(1 : 32));
        r(2, 5) = r(2, 5) + sum(w == w5); 
		w5 = multi_bits_decode(y5_aw, num_watermark, k, n(1 : 32));
        r(3, 5) = r(3, 5) + sum(w == w5); 
    end
    disp([t i]);
    disp(r / (count * num_watermark) * 100);
    result{t} = r;
end
ret = netsum(result) / (count * times * num_watermark) * 100;
save('/home/wujing/hupeng/multi_test.mat');
