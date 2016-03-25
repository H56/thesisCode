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

result = cell(times, 1);
for t = 1 : times
    result{t} = zeros(3, 6);
end
% count_water = 0;
parfor t = 1 : times
    for i = 1 : count
        [x, fs] = audioread(strcat(files_root_path, all_files(i).name));
        k = PNSequence(Lpn);
        
        w1 = randi(2, 1, num_watermark) - 1;
        y11 = echo_encode(x, w, k, a, n(1 : 2));
        y12 = wav_quantize(y11, 8);
	    y13 = awgn(y11, 30, 'measured');
        w11 = echo_decode(y11, num_watermark, k, n(1 : 2));
        w12= echo_decode(y12, num_watermark, k, n(1 : 2));
        w13 = echo_decode(y13, num_watermark, k, n(1 : 2));

        w2 = [w1 randi(2, 1, num_watermark) - 1];
        y61 = echo_encode(x, w, k, a, n(1 : 2));
        y62 = wav_quantize(y61, 8);
	    y63 = awgn(y61, 30, 'measured');
        w61 = echo_decode(y61, num_watermark, k, n(1 : 2));
        w62= echo_decode(y62, num_watermark, k, n(1 : 2));
        w63 = echo_decode(y63, num_watermark, k, n(1 : 2));
        
        y21 = slice_encode(x, w, k, a, n(1 : 4), 10);
        y22 = wav_quantize(y21, 8);
	    y23 = awgn(y21, 30, 'measured');
        w21 = slice_decode(y21, num_watermark, k, n(1 : 4), 10);
        w22 = slice_decode(y22, num_watermark, k, n(1 : 4), 10);
        w23 = slice_decode(y23, num_watermark, k, n(1 : 4), 10);

        w3 = [w2 randi(2, 1, num_watermark) - 1];
        y31 = slice_encode(x, w, k, a, n(1 : 8), 10);
        y32 = wav_quantize(y31, 8);
	    y33 = awgn(y31, 30, 'measured');
        w31 = slice_decode(y31, num_watermark, k, n(1 : 8), 10);
        w32 = slice_decode(y32, num_watermark, k, n(1 : 8), 10);
        w33 = slice_decode(y33, num_watermark, k, n(1 : 8), 10);

        w4 = [w3 randi(2, 1, num_watermark) - 1];
        y41 = slice_encode(x, w, k, a, n(1 : 16), 10);
        y42 = wav_quantize(y41, 8);
	    y43 = awgn(y41, 30, 'measured');
        w41 = slice_decode(y41, num_watermark, k, n(1 : 16), 10);
        w42 = slice_decode(y42, num_watermark, k, n(1 : 16), 10);
        w43 = slice_decode(y43, num_watermark, k, n(1 : 16), 10);

        w5 = [w4 randi(2, 1, num_watermark) - 1];
        y51 = slice_encode(x, w, k, a, n(1 : 2), 32);
        y52 = wav_quantize(y51, 8);
	    y53 = awgn(y51, 30, 'measured');
        w51 = slice_decode(y51, num_watermark, k, n(1 : 32), 10);
        w52 = slice_decode(y52, num_watermark, k, n(1 : 32), 10);
        w53 = slice_decode(y53, num_watermark, k, n(1 : 32), 10);
        result{t} = result{t} + [sum(w1 == w11) sum(w2 == w61) sum(w2 == w21) sum(w3 == w31) sum(w4 == w41) sum(w5 == w51);
                                 sum(w1 == w12) sum(w2 == w62) sum(w2 == w22) sum(w3 == w32) sum(w4 == w42) sum(w5 == w52);
                                 sum(w1 == w13) sum(w2 == w63) sum(w2 == w23) sum(w3 == w33) sum(w4 == w43) sum(w5 == w53)];
        if mod(i, 50) == 0
            disp([t i]);
            disp(result{t} / (i * num_watermark) * 100);
        end
   end
end
ret = netsum(result) / (count * times * num_watermark) * 100;
disp(ret);
save('/home/wujing/hupeng/slice_test_multi_2_1.mat');

