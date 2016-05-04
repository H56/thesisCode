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
    result{t} = zeros(1, 6);
end
% count_water = 0;
 parfor t = 1 : times
    for i = 1 : count
        [x, fs] = audioread(strcat(files_root_path, all_files(i).name));
        k = PNSequence(Lpn);
        
        w1 = randi(2, 1, num_watermark) - 1;
        y11 = echo_encode(x, w1, k, a, n(1 : 2));
	    audiowrite(strcat('tmp/', num2str(t), 'tmp.m4a'), y11, fs, 'BitRate',128);
        [y11, ~] = audioread(strcat('tmp/', num2str(t), 'tmp.m4a'));
        y11 = y11(1 : length(x));
        w11 = echo_decode(y11, length(w1), k, n(1 : 2));
        
        w2 = [w1 randi(2, 1, num_watermark) - 1];
        y21 = slice_encode(x, w2, k, a, n(1 : 4), 10);        
	    audiowrite(strcat('tmp/', num2str(t), 'tmp.m4a'), y21, fs, 'BitRate',128);
        [y21, ~] = audioread(strcat('tmp/', num2str(t), 'tmp.m4a'));
        y21 = y21(1 : length(x));
        w21 = slice_decode(y21, length(w2), k, n(1 : 4), 10);

        w3 = [w2 randi(2, 1, num_watermark) - 1];
        y61 = echo_encode(x, w3, k, a, n(1 : 2));
	    audiowrite(strcat('tmp/', num2str(t), 'tmp.m4a'), y61, fs, 'BitRate',128);
        [y61, ~] = audioread(strcat('tmp/', num2str(t), 'tmp.m4a'));
        y61 = y61(1 : length(x));
        w61 = echo_decode(y61, length(w3), k, n(1 : 2));
        
        
        y31 = slice_encode(x, w3, k, a, n(1 : 8), 10);
	    audiowrite(strcat('tmp/', num2str(t), 'tmp.m4a'), y31, fs, 'BitRate',128);
        [y31, ~] = audioread(strcat('tmp/', num2str(t), 'tmp.m4a'));
        y31 = y31(1 : length(x));
        w31 = slice_decode(y31, length(w3), k, n(1 : 8), 10);

        w4 = [w3 randi(2, 1, num_watermark) - 1];
        y41 = slice_encode(x, w4, k, a, n(1 : 16), 10);
	    audiowrite(strcat('tmp/', num2str(t), 'tmp.m4a'), y41, fs, 'BitRate',128);
        [y41, ~] = audioread(strcat('tmp/', num2str(t), 'tmp.m4a'));
        y41 = y41(1 : length(x));
        w41 = slice_decode(y41, length(w4), k, n(1 : 16), 10);

        w5 = [w4 randi(2, 1, num_watermark) - 1];
        y51 = slice_encode(x, w5, k, a, n(1 : 32), 10);
	    audiowrite(strcat('tmp/', num2str(t), 'tmp.m4a'), y51, fs, 'BitRate',128);
        [y51, ~] = audioread(strcat('tmp/', num2str(t), 'tmp.m4a'));
        y51 = y51(1 : length(x));
        w51 = slice_decode(y51, length(w5), k, n(1 : 32), 10);
        result{t} = result{t} + [sum(w1 == w11) sum(w3 == w61) sum(w2 == w21) sum(w3 == w31) sum(w4 == w41) sum(w5 == w51)];
        if mod(i, 50) == 0
            disp([t i]);
            disp(bsxfun(@rdivide, result{t}, [1 3 2 3 4 5] * (i * num_watermark)) * 100);
        end
   end
end
    
ret = bsxfun(@rdivide, netsum(result), [1 3 2 3 4 5] * (count * times * num_watermark)) * 100;
disp(ret);