% clear; close all; clc;
% 
% files_root_path = 'music_pieces/';
% all_files = dir(fullfile(files_root_path, '*.wav'));
% count = length(all_files);
[~, count] = size(data);

times = 100;
n = [20 40 60 80 100 120 140 160 180 200 220 240 260 280 300 320
    340 360 380 400 420 440 460 480 500 520 540 560 580 600 620 640];
num_watermark = 40;
Lpn = 1023;
a = 0.002;
a3 = 0.006;

result = cell(times, 1);
for t = 1 : times
    result{t} = zeros(3, 5);
end
% count_water = 0;
parfor t = 1 : times
    for i = 1 : count
%         [x, fs] = audioread(strcat(files_root_path, all_files(i).name));
        fs = 44100;
        x = data(:, i);
        k = PNSequence(Lpn);
        
        w1 = randi(2, 1, num_watermark) - 1;
        y11 = echo_encode(x, w1, k, a, n(1 : 2));
        y12 = wav_quantize(y11, 8);
        y13 = awgn(y11, 30, 'measured');
        w11 = echo_decode(y11, length(w1), k, n(1 : 2));
        w12= echo_decode(y12, length(w1), k, n(1 : 2));
        w13 = echo_decode(y13, length(w1), k, n(1 : 2));

%         w2 = [w1 randi(2, 1, num_watermark) - 1];
        w2 = w1;
        y21 = ep_encode(x, w2, k, a3, n(1 : 2));
        y22 = wav_quantize(y21, 8);
        y23 = awgn(y21, 30, 'measured');
        w21 = ep_decode(y21, num_watermark, k, n(1 : 2));
        w22 = ep_decode(y22, num_watermark, k, n(1 : 2));
        w23 = ep_decode(y23, num_watermark, k, n(1 : 2));

%         w3 = [w2 randi(2, 1, num_watermark) - 1];
%         w3 = w1;
%         y61 = echo_encode(x, w3, k, a, n(1 : 2));
%         y62 = wav_quantize(y61, 8);
%         y63 = awgn(y61, 30, 'measured');
%         w61 = echo_decode(y61, length(w3), k, n(1 : 2));
%         w62= echo_decode(y62, length(w3), k, n(1 : 2));
%         w63 = echo_decode(y63, length(w3), k, n(1 : 2));
       
        w3 = w1; 
        y31 = slice_encode(x, w3, k, a, n(1 : 4), 2);
        y32 = wav_quantize(y31, 8);
        y33 = awgn(y31, 30, 'measured');
        w31 = slice_decode(y31, length(w3), k, n(1 : 4), 2);
        w32 = slice_decode(y32, length(w3), k, n(1 : 4), 2);
        w33 = slice_decode(y33, length(w3), k, n(1 : 4), 2);

%         w4 = [w3 randi(2, 1, num_watermark) - 1];
        w4 = w1;
        y41 = slice_encode(x, w4, k, a, n(1 : 4), 4);
        y42 = wav_quantize(y41, 8);
        y43 = awgn(y41, 30, 'measured');
        w41 = slice_decode(y41, length(w4), k, n(1 : 4), 4);
        w42 = slice_decode(y42, length(w4), k, n(1 : 4), 4);
        w43 = slice_decode(y43, length(w4), k, n(1 : 4), 4);

%         w5 = [w4 randi(2, 1, 10) - 1];
        w5 = w1;
        y51 = slice_encode(x, w5, k, a, n(1 : 4), 8);
        y52 = wav_quantize(y51, 8);
        y53 = awgn(y51, 30, 'measured');
        w51 = slice_decode(y51, length(w5), k, n(1 : 4), 8);
        w52 = slice_decode(y52, length(w5), k, n(1 : 4), 8);
        w53 = slice_decode(y53, length(w5), k, n(1 : 4), 8);
        result{t} = result{t} + [sum(w1 == w11) sum(w2 == w21) sum(w3 == w31) sum(w4 == w41) sum(w5 == w51);
                                 sum(w1 == w12) sum(w2 == w22) sum(w3 == w32) sum(w4 == w42) sum(w5 == w52);
                                 sum(w1 == w13) sum(w2 == w23) sum(w3 == w33) sum(w4 == w43) sum(w5 == w53)];
        if mod(i, 50) == 0
            disp([t i]);
            disp(bsxfun(@rdivide, result{t}, [1 3 2 3 4 5] * (i * num_watermark)) * 100);
        end
   end
end
ret = bsxfun(@rdivide, netsum(result), [1 3 2 3 4 5] * (count * times * num_watermark)) * 100;
disp(ret);
save('/home/wujing/hupeng/slice_test_multi_1_1.mat');
