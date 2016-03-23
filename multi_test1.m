clear; close all; clc;

files_root_path = 'music_pieces/';
all_files = dir(fullfile(files_root_path, '*.wav'));
count = length(all_files);

times = 100;
n = [20 40 60 80 100 120 140 160 180 200 220 240 260 280 300 320
    340 360 380 400 420 440 460 480 500 520 540 560 580 600 620 640];
num_watermark = 32;
Lpn = 1023;
a = 0.002;
snr = 0;

result = cell(times);
% count_water = 0;
for t = 1 : times
    result{t} = zeros(2, 5);
end
disp('start..');
for t = 1 : times
    disp([t 'start']);
    for i = 1 : count
	[x, fs] = wavread(strcat(files_root_path, all_files(i).name));
        k = PNSequence(Lpn);
        w = randi(2, 1, num_watermark) - 1;
        y1 = echo_encode(x, w, k, a, n(1 : 2));
        mp3write(y1, fs, strcat('tmp/', num2str(t), 'tmp.mp3'),  '--quiet -h -b 128'); y1_a = mp3read(strcat('tmp/', num2str(t), 'tmp.mp3'));
        %audiowrite(strcat('tmp/', num2str(t), 'tmp.m4a'),  y1, fs); [y1_aw fs] = audioread(strcat('tmp/', num2str(t), 'tmp.m4a')); y1_aw = y1_aw(1 : 441000, 1);
        y1 = 1.8 * y1;
        w11 = echo_decode(y1, num_watermark, k, n(1 : 2));
	w12 = echo_decode(y1_a, num_watermark, k, n(1 : 2));
	%w13 = echo_decode(y1_aw, num_watermark, k, n(1 : 2));
        
        y2 = multi_bits_encode(x, w, k, a, n(1 : 4));
	mp3write(y2, fs, strcat('tmp/', num2str(t), 'tmp.mp3'),  '--quiet -h -b 128'); y2_a = mp3read(strcat('tmp/', num2str(t), 'tmp.mp3'));
        %audiowrite(strcat('tmp/', num2str(t), 'tmp.m4a'), y2, fs); [y2_aw fs] = audioread(strcat('tmp/', num2str(t), 'tmp.m4a')); y2_aw = y2_aw(1 : 441000, 1);
        y2 = 1.8 * y2;
        w21 = multi_bits_decode(y2, num_watermark, k, n(1 : 4));
	w22 = multi_bits_decode(y2_a, num_watermark, k, n(1 : 4));
	%w23 = multi_bits_decode(y2_aw, num_watermark, k, n(1 : 4));
        
        y3 = multi_bits_encode(x, w, k, a, n(1 : 8));
	mp3write(y3, fs, strcat('tmp/', num2str(t), 'tmp.mp3'),  '--quiet -h -b 128'); y3_a = mp3read(strcat('tmp/', num2str(t), 'tmp.mp3'));
        %audiowrite(strcat('tmp/', num2str(t), 'tmp.m4a'),  y3, fs); [y3_aw fs] = audioread(strcat('tmp/', num2str(t), 'tmp.m4a')); y3_aw = y3_aw(1 : 441000, 1);
        y3 = 1.8 * y3;
        w31 = multi_bits_decode(y3, num_watermark, k, n(1 : 8));
	w32 = multi_bits_decode(y3_a, num_watermark, k, n(1 : 8));
	%w33 = multi_bits_decode(y3_aw, num_watermark, k, n(1 : 8));
       
        y4 = multi_bits_encode(x, w, k, a, n(1 : 16));
	mp3write(y4, fs, strcat('tmp/', num2str(t), 'tmp.mp3'),  '--quiet -h -b 128'); y4_a = mp3read(strcat('tmp/', num2str(t), 'tmp.mp3'));
        %audiowrite(strcat('tmp/', num2str(t), 'tmp.m4a'), y4, fs); [y4_aw fs] = audioread(strcat('tmp/', num2str(t), 'tmp.m4a')); y4_aw = y4_aw(1 : 441000, 1);
        y4 = 1.8 * y4;
        w41 = multi_bits_decode(y4, num_watermark, k, n(1 : 16));
	w42 = multi_bits_decode(y4_a, num_watermark, k, n(1 : 16));
	%w43 = multi_bits_decode(y4_aw, num_watermark, k, n(1 : 16));
		
	y5 = multi_bits_encode(x, w, k, a, n(1 : 32));
	mp3write(y5, fs, strcat('tmp/', num2str(t), 'tmp.mp3'),  '--quiet -h -b 128'); y5_a = mp3read(strcat('tmp/', num2str(t), 'tmp.mp3'));
        %audiowrite( strcat('tmp/', num2str(t), 'tmp.m4a'),  y5, fs); [y5_aw fs] = audioread(strcat('tmp/', num2str(t), 'tmp.m4a')); y5_aw = y5_aw(1 : 441000, 1);
        y5 = 1.8 * y5;
        w51 = multi_bits_decode(y5, num_watermark, k, n(1 : 32));
	w52 = multi_bits_decode(y5_a, num_watermark, k, n(1 : 32));
	%w53 = multi_bits_decode(y5_aw, num_watermark, k, n(1 : 32));
        result{t} = result{t} + [sum(w11 == w), sum(w21 == w), sum(w31 == w), sum(w41 == w), sum(w51 == w);
                                 sum(w12 == w), sum(w22 == w), sum(w32 == w), sum(w42 == w), sum(w52 == w)];
                                 %sum(w13 == w), sum(w23 == w), sum(w33 == w), sum(w43 == w), sum(w53 == w)];
        if mod(i, 5) == 0
            disp([t, i]);
            disp(result{t} / (i * num_watermark) * 100);
        end
    end
end
ret = netsum(result) / (count * times * num_watermark) * 100;
save('\home\wujing\hupeng\result\multi_test2.mat');
