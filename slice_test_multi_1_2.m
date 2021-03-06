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
    result{t} = zeros(2, 5);
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
        mp3write(y11, fs, strcat('tmp/', num2str(t), 'tmp.mp3')); [y12, fs] = mp3read(strcat('tmp/', num2str(t), 'tmp.mp3'));
        y11 = 1.8 * y11;
        w11 = echo_decode(y11, length(w1), k, n(1 : 2));
        w12= echo_decode(y12, length(w1), k, n(1 : 2));

%         w2 = [w1 randi(2, 1, num_watermark) - 1];
        w2 = w1;
        y21 = ep_encode(x, w2, k, a3, n(1 : 2));
        mp3write(y21, fs, strcat('tmp/', num2str(t), 'tmp.mp3')); [y22, fs] = mp3read(strcat('tmp/', num2str(t), 'tmp.mp3'));
        y21 = 1.8 * y21;
        w21 = ep_decode(y21, num_watermark, k, n(1 : 2));
        w22 = ep_decode(y22, num_watermark, k, n(1 : 2));

        
%         w3 = [w2 randi(2, 1, num_watermark) - 1];
%         y61 = echo_encode(x, w3, k, a, n(1 : 2));
%         mp3write(y61, fs, strcat('tmp/', num2str(t), 'tmp.mp3')); [y62, fs] = mp3read(strcat('tmp/', num2str(t), 'tmp.mp3'));
%         y61 = 1.8 * y61;
%         w61 = echo_decode(y61, length(w3), k, n(1 : 2));
%         w62= echo_decode(y62, length(w3), k, n(1 : 2));
        
        w3 = w1; 
        y31 = slice_encode(x, w3, k, a, n(1 : 4), 2);
        mp3write(y31, fs, strcat('tmp/', num2str(t), 'tmp.mp3')); [y32, fs] = mp3read(strcat('tmp/', num2str(t), 'tmp.mp3'));
        y31 = 1.8 * y31;
        w31 = slice_decode(y31, length(w3), k, n(1 : 4), 2);
        w32 = slice_decode(y32, length(w3), k, n(1 : 4), 2);

%         w4 = [w3 randi(2, 1, num_watermark) - 1];
        w4 = w1;
        y41 = slice_encode(x, w4, k, a, n(1 : 4), 4);
        mp3write(y41, fs, strcat('tmp/', num2str(t), 'tmp.mp3')); [y42, fs] = mp3read(strcat('tmp/', num2str(t), 'tmp.mp3'));
        y41 = 1.8 * y41;
        w41 = slice_decode(y41, length(w4), k, n(1 : 4), 4);
        w42 = slice_decode(y42, length(w4), k, n(1 : 4), 4);

%         w5 = [w4 randi(2, 1, 10) - 1];
        w5 = w1;
        y51 = slice_encode(x, w5, k, a, n(1 : 4), 8);
        mp3write(y51, fs, strcat('tmp/', num2str(t), 'tmp.mp3')); [y52, fs] = mp3read(strcat('tmp/', num2str(t), 'tmp.mp3'));
        y51 = 1.8 * y51;
        w51 = slice_decode(y51, length(w5), k, n(1 : 4), 8);
        w52 = slice_decode(y52, length(w5), k, n(1 : 4), 8);
        result{t} = result{t} + [sum(w1 == w11) sum(w2 == w21) sum(w3 == w31) sum(w4 == w41) sum(w5 == w51);
                                 sum(w1 == w12) sum(w2 == w22) sum(w3 == w32) sum(w4 == w42) sum(w5 == w52)];
        if mod(i, 50) == 0
            disp([t i]);
%             disp(bsxfun(@rdivide, result{t},[num_watermark, num_watermark, num_watermark, num_watermark, num_watermark] * i) * 100);
            disp(result{t} / (i * num_watermark) * 100);
        end
   end
end
ret = netsum(result) / (count * times * num_watermark) * 100;
disp(ret);
save('/home/wujing/hupeng/slice_test_multi_1_2.mat');

