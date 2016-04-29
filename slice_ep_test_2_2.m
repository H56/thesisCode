clear; close all; clc;

files_root_path = 'music_pieces/';
all_files = dir(fullfile(files_root_path, '*.wav'));
count = length(all_files);

times = 100;
n = [20 40 60 80 100 120 140 160 180 200 220 240 260 280 300 320
    340 360 380 400 420 440 460 480 500 520 540 560 580 600 620 640];
num_watermark = 10;
Lpn = 1023;
a = 0.002;
snr = 0;

result = cell(times, 1);
for t = 1 : times
    result{t} = zeros(2, 5);
end
% count_water = 0;
parfor i = 1 : count
    [x, fs] = audioread(strcat(files_root_path, all_files(i).name));
    for t = 1 : times        
        k = PNSequence(Lpn);
        w = randi(2, 1, num_watermark) - 1;

        y11 = echo_encode(x, w, k, a, n(1 : 2));
        mp3write(y11, fs, strcat('tmp/', num2str(t), 'tmp.mp3')); [y12, fs] = mp3read(strcat('tmp/', num2str(t), 'tmp.mp3'));
        y11 = 1.8 * y11;
        w11 = echo_decode(y11, num_watermark, k, n(1 : 2));
        w12= echo_decode(y12, num_watermark, k, n(1 : 2));

        y21 = slice_encode(x, w, k, a, n(1 : 2), 2);
        mp3write(y21, fs, strcat('tmp/', num2str(t), 'tmp.mp3')); [y22, fs] = mp3read(strcat('tmp/', num2str(t), 'tmp.mp3'));
        y21 = 1.8 * y21;
        w21 = slice_decode(y21, num_watermark, k, n(1 : 2), 2);
        w22 = slice_decode(y22, num_watermark, k, n(1 : 2), 2);

        y31 = slice_encode(x, w, k, a, n(1 : 2), 4);
        mp3write(y31, fs, strcat('tmp/', num2str(t), 'tmp.mp3')); [y32, fs] = mp3read(strcat('tmp/', num2str(t), 'tmp.mp3'));
        y31 = 1.8 * y31;
        w31 = slice_decode(y31, num_watermark, k, n(1 : 2), 4);
        w32 = slice_decode(y32, num_watermark, k, n(1 : 2), 4);

        y41 = slice_encode(x, w, k, a, n(1 : 2), 8);
        mp3write(y41, fs, strcat('tmp/', num2str(t), 'tmp.mp3')); [y42, fs] = mp3read(strcat('tmp/', num2str(t), 'tmp.mp3'));
        y41 = 1.8 * y41;
        w41 = slice_decode(y41, num_watermark, k, n(1 : 2), 8);
        w42 = slice_decode(y42, num_watermark, k, n(1 : 2), 8);

        y51 = ep_encode(x, w, k, a3, n(1 : 2));
        mp3write(y51, fs, strcat('tmp/', num2str(t), 'tmp.mp3')); [y52, fs] = mp3read(strcat('tmp/', num2str(t), 'tmp.mp3'));
        y51 = 1.8 * y51;
        w51 = ep_decode(y51, num_watermark, k, n(1 : 2));
        w52 = ep_decode(y52, num_watermark, k, n(1 : 2));
        result{t} = result{t} + [sum(w == w11) sum(w == w21) sum(w == w31) sum(w == w41) sum(w == w51);
                                 sum(w == w12) sum(w == w22) sum(w == w32) sum(w == w42) sum(w == w52)];
        if mod(i, 50) == 0
            disp([t i]);
            disp(result{t} / (i * num_watermark) * 100);
        end
   end
end
ret = netsum(result) / (count * times * num_watermark) * 100;
disp(ret);
save('/home/wujing/hupeng/slice_ep_test_2_2.mat');