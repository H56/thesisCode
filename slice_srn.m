clear; close all; clc;
load('music_data.mat');
[~, count] = size(data);
times = 100;
n = [20 40 60 80 100 120 140 160 180 200 220 240 260 280 300 320
    340 360 380 400 420 440 460 480 500 520 540 560 580 600 620 640];
num_watermark = 32;
Lpn = 1023;
a_set = [0.001 0.002 0.004 0.006];

%result = zeros(length(a_set), 5);
result = cell(1, times);
for i = 1 : times
    result{i} = zeros(4, 5);
end
% count_water = 0;
parfor t = 1 : times
    for i = 1 : count
        x = data(:, i);
        k = PNSequence(Lpn);
        w = randi(2, 1, num_watermark) - 1;
        for j = 1 : length(a_set)
            a = a_set(j);
            y1 = echo_encode(x, w, k, a, n(1 : 2));
            
            y2 = slice_encode(x, w, k, a, n(1 : 2), 2);
			
            y3 = slice_encode(x, w, k, a, n(1 : 2), 4);
			
            y4 = slice_encode(x, w, k, a, n(1 : 2), 8);
			
            y5 = slice_encode(x, w, k, a, n(1 : 2), 10);
        
            result{t}(j, :) = result{t}(j, :) + [SNR(x, y1) SNR(x, y2) SNR(x, y3) SNR(x, y4) SNR(x, y5)];
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
save('/home/wujing/hupeng/result/slice_srn.mat');
