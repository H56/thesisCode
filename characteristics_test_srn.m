clear; close all; clc;

files_root_path = 'music_pieces1/';
all_files = dir(fullfile(files_root_path, '*.wav'));
count = length(all_files);

times = 100;
n = [20 40 60 80 100 120 140 160 180 200 220 240 260 280 300 320
    340 360 380 400 420 440 460 480 500 520 540 560 580 600 620 640];
num_watermark = 10;
Lpn = 1023;
a_set = [0.001 0.002 0.004 0.006];
result = cell(1, times);
for i = 1 : times
    result{i} = zeros(4, 2);
end
for t = 1 : times
    for i = 1 : count
        [x, fs] = audioread(strcat(files_root_path, all_files(i).name));
        k = PNSequence(Lpn);
        w = randi(2, 1, num_watermark) - 1;
        for j = 1 : length(a_set)
            a = a_set(j);
            y1 = echo_encode(x, w, k, a, n(1 : 2));
            
            y2 = new_embed_echo_watermarking(x, w, a, n(1 : 2), -1, k);
            result{t}(j, :) = result{t}(j, :) + [SNR(x, y1) SNR(x, y2)];
        end
        if mod(i, 50) == 0
            disp([t i]);
            disp(result{t} / i);
        end
    end
    disp(t);
    disp(result{t} / (count));
end
ret = netsum(result) / (count * times);
disp(ret);
save('/home/wujing/hupeng/result/multi_bits_srn.mat');
