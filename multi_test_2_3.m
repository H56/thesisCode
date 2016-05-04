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
a3 = 0.006;
snr = 0;

result = cell(count, 1);
for t = 1 : count
    result{t} = zeros(1, 5);
end
% count_water = 0;
parfor t = 1 : count
    [x, fs] = audioread(strcat(files_root_path, all_files(t).name));
    for i = 1 : times        
        k = PNSequence(Lpn);
        w = randi(2, 1, num_watermark) - 1;

        y11 = echo_encode(x, w, k, a, n(1 : 2));
	    audiowrite(strcat('tmp/', num2str(t), 'tmp.m4a'), y11, fs, 'BitRate',128);
        [y11, ~] = audioread(strcat('tmp/', num2str(t), 'tmp.m4a'));
        y11 = y11(1 : length(x));
        w11 = echo_decode(y11, num_watermark, k, n(1 : 2));

        y21 = multi_bits_encode(x, w, k, a, n(1 : 4));   
	    audiowrite(strcat('tmp/', num2str(t), 'tmp.m4a'), y21, fs, 'BitRate',128);
        [y21, ~] = audioread(strcat('tmp/', num2str(t), 'tmp.m4a'));
        y21 = y21(1 : length(x));
        w21 = multi_bits_decode(y21, num_watermark, k, n(1 : 4));

        y31 = multi_bits_encode(x, w, k, a, n(1 : 8));
	    audiowrite(strcat('tmp/', num2str(t), 'tmp.m4a'), y31, fs, 'BitRate',128);
        [y31, ~] = audioread(strcat('tmp/', num2str(t), 'tmp.m4a'));
        y31 = y31(1 : length(x));
        w31 = multi_bits_decode(y31, num_watermark, k, n(1 : 8));

        y41 = multi_bits_encode(x, w, k, a, n(1 : 16));
	    audiowrite(strcat('tmp/', num2str(t), 'tmp.m4a'), y41, fs, 'BitRate',128);
        [y41, ~] = audioread(strcat('tmp/', num2str(t), 'tmp.m4a'));
        y41 = y41(1 : length(x));
        w41 = multi_bits_decode(y41, num_watermark, k, n(1 : 16));
        
        y51 = multi_bits_encode(x, w, k, a, n(1 : 16));
	    audiowrite(strcat('tmp/', num2str(t), 'tmp.m4a'), y51, fs, 'BitRate',128);
        [y51, ~] = audioread(strcat('tmp/', num2str(t), 'tmp.m4a'));
        y51 = y51(1 : length(x));
        w51 = multi_bits_decode(y51, num_watermark, k, n(1 : 16));

        y61 = ep_encode(x, w, k, a3, n(1 : 2));
	    audiowrite(strcat('tmp/', num2str(t), 'tmp.m4a'), y61, fs, 'BitRate',128);
        [y61, ~] = audioread(strcat('tmp/', num2str(t), 'tmp.m4a'));
        y61 = y61(1 : length(x));
        w61 = ep_decode(y61, num_watermark, k, n(1 : 2));
        
        result{t} = result{t} + [sum(w == w11) sum(w == w21) sum(w == w31) sum(w == w41) sum(w == w51) sum(w == w61)];
        if mod(i, 50) == 0
            disp([t i]);
            disp(result{t} / (i * num_watermark) * 100);
        end
   end
end
ret = netsum(result) / (count * times * num_watermark) * 100;
disp(ret);
