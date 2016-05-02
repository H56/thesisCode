%clear; close all; clc;

%files_root_path = 'music_pieces/';
%all_files = dir(fullfile(files_root_path, '*.wav'));
%count = length(all_files);

% music = data;
[~, count] = size(data);
fs = 44100;

times = 100;
n = [20 40 60 80 100 120 140 160 180 200 220 240 260 280 300 320
    340 360 380 400 420 440 460 480 500 520 540 560 580 600 620 640];
num_watermark = 10;
Lpn = 1023;
a1 = 0.002;
a2 = 0.002;
a3 = 0.006;
snr = cell(times, 1);
result = cell(times, 1);
for t = 1 : times
    result{t} = zeros(3, 6);
    snr{t} = zeros(1, 6);
end
% count_water = 0;
parfor t = 1 : times
    for i = 1 : count
%        [x, fs] = audioread(strcat(files_root_path, all_files(i).name));
        x = data(:, i);
        k = PNSequence(Lpn);
        w = randi(2, 1, num_watermark) - 1;

        y11 = echo_encode(x, w, k, a1, n(1 : 2));
        y12 = wav_quantize(y11, 8);
        y13 = awgn(y11, 30, 'measured');
        w11 = echo_decode(y11, num_watermark, k, n(1 : 2));
        w12= echo_decode(y12, num_watermark, k, n(1 : 2));
        w13 = echo_decode(y13, num_watermark, k, n(1 : 2));

        y21 = slice_encode(x, w, k, a2, n(1 : 2), 2);
        y22 = wav_quantize(y21, 8);
        y23 = awgn(y21, 30, 'measured');
        w21 = slice_decode(y21, num_watermark, k, n(1 : 2), 2);
        w22 = slice_decode(y22, num_watermark, k, n(1 : 2), 2);
        w23 = slice_decode(y23, num_watermark, k, n(1 : 2), 2);

        y31 = slice_encode(x, w, k, a2, n(1 : 2), 4);
        y32 = wav_quantize(y31, 8);
        y33 = awgn(y31, 30, 'measured');
        w31 = slice_decode(y31, num_watermark, k, n(1 : 2), 4);
        w32 = slice_decode(y32, num_watermark, k, n(1 : 2), 4);
        w33 = slice_decode(y33, num_watermark, k, n(1 : 2), 4);

        y41 = slice_encode(x, w, k, a2, n(1 : 2), 8);
        y42 = wav_quantize(y41, 8);
        y43 = awgn(y41, 30, 'measured');
        w41 = slice_decode(y41, num_watermark, k, n(1 : 2), 8);
        w42 = slice_decode(y42, num_watermark, k, n(1 : 2), 8);
        w43 = slice_decode(y43, num_watermark, k, n(1 : 2), 8);

        y51 = slice_encode(x, w, k, a2, n(1 : 2), 10);
        y52 = wav_quantize(y51, 8);
        y53 = awgn(y51, 30, 'measured');
        w51 = slice_decode(y51, num_watermark, k, n(1 : 2), 10);
        w52 = slice_decode(y52, num_watermark, k, n(1 : 2), 10);
        w53 = slice_decode(y53, num_watermark, k, n(1 : 2), 10);

        y61 = ep_encode(x, w, k, a3, n(1 : 2));
        y62 = wav_quantize(y61, 8);
        y63 = awgn(y61, 30, 'measured');
        w61 = ep_decode(y61, num_watermark, k, n(1 : 2));
        w62 = ep_decode(y62, num_watermark, k, n(1 : 2));
        w63 = ep_decode(y63, num_watermark, k, n(1 : 2));
 
        result{t} = result{t} + [sum(w == w11) sum(w == w21) sum(w == w31) sum(w == w41) sum(w == w51) sum(w == w61);
                                 sum(w == w12) sum(w == w22) sum(w == w32) sum(w == w42) sum(w == w52) sum(w == w62);
                                 sum(w == w13) sum(w == w23) sum(w == w33) sum(w == w43) sum(w == w53) sum(w == w63)];
        snr{t} = snr{t} + [SNR(x, y11) SNR(x, y21) SNR(x, y31) SNR(x, y41) SNR(x, y51) SNR(x, y61)]
        if mod(i, 50) == 0
            disp([t i]);
            disp(result{t} / (i * num_watermark) * 100);
            disp(snr{t} / i);
        end
   end
end
ret = netsum(result) / (count * times * num_watermark) * 100;
disp(ret);
disp(netsum(snr) / count);
save('/home/wujing/hupeng/slice_ep_test_2_1.mat', 'ret');

