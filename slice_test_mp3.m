clear; close all; clc;

files_root_path = 'music_pieces1/';
all_files = dir(fullfile(files_root_path, '*.wav'));
count = length(all_files);

times = 100;
n = [20 40 60 80 100 120 140 160 180 200 220 240 260 280 300 320
    340 360 380 400 420 440 460 480 500 520 540 560 580 600 620 640];
num_watermark = 8;
Lpn = 1023;
a = 0.002;
snr = 0;

result = cell(times, 1);
for t = 1 : times
    result{t} = zeros(1, 5);
end
% count_water = 0;
parfor t = 1 : times
    for i = 1 : count
        [x, fs] = audioread(strcat(files_root_path, all_files(i).name));
        k = PNSequence(Lpn);
        w = randi(2, 1, num_watermark) - 1;
        
        y1 = echo_encode(x, w, k, a, n(1 : 2));
        mp3write(y1, fs, strcat('tmp/', num2str(t), 'tmp.mp3')); [y1, fs] = mp3read(strcat('tmp/', num2str(t), 'tmp.mp3'));
        w1 = echo_decode(y1, num_watermark, k, n(1 : 2));
        
        y2 = slice_encode(x, w, k, a, n(1 : 4), 2);
        mp3write(y2, fs, strcat('tmp/', num2str(t), 'tmp.mp3')); [y2, fs] = mp3read(strcat('tmp/', num2str(t), 'tmp.mp3'));
        w2 = slice_decode(y2, num_watermark, k, n(1 : 4), 2);
        
        y3 = slice_encode(x, w, k, a, n(1 : 4), 4);
        mp3write(y3, fs, strcat('tmp/', num2str(t), 'tmp.mp3')); [y3, fs] = mp3read(strcat('tmp/', num2str(t), 'tmp.mp3'));
        w3 = slice_decode(y3, num_watermark, k, n(1 : 4), 4);
        
        y4 = slice_encode(x, w, k, a, n(1 : 4), 8);
        mp3write(y4, fs, strcat('tmp/', num2str(t), 'tmp.mp3')); [y4, fs] = mp3read(strcat('tmp/', num2str(t), 'tmp.mp3'));
        w4 = slice_decode(y4, num_watermark, k, n(1 : 4), 8);
		
	y5 = slice_encode(x, w, k, a, n(1 : 4), 10);
        mp3write(y5, fs, strcat('tmp/', num2str(t), 'tmp.mp3')); [y5, fs] = mp3read(strcat('tmp/', num2str(t), 'tmp.mp3'));
        w5 = slice_decode(y5, num_watermark, k, n(1 : 4), 10);
        result{t} = result{t} + [sum(w == w1) sum(w == w2) sum(w == w3) sum(w == w4) sum(w == w5)];
        if mod(i, 50) == 0
            disp([t i]);
            disp(result{t} / (i * num_watermark) * 100);
        end 
   end
end
ret = netsum(result) / (count * times * num_watermark) * 100;
disp(ret);
save('/home/wujing/hupeng/slice_test_mp3.mat');
