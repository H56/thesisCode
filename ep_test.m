% clear; close all; clc;
% 
% % files_root_path = 'music_pieces/';
% % all_files = dir(fullfile(files_root_path, '*.wav'));
% % count = length(all_files);
% load('music.mat');
%clear; close all; clc;

% files_root_path = 'music_pieces/';
% all_files = dir(fullfile(files_root_path, '*.wav'));
% count = length(all_files);
%load('music_data.mat');
music = data;
[~, count] = size(music);
fs = 44100;

times = 1;
n = [44 88];
num_watermark = 10;
num_slice = 10;
Lpn = 1023;
a = 0.002;
snr = 0;

count1 = zeros(times, 1);
count2 = zeros(times, 1);
srn1 = zeros(times, 1);
srn2 = zeros(times, 1);
% count_water = 0;
for t = 1 : times
    for i = 1 : count
%         [x, fs] = audioread(strcat(files_root_path, all_files(i).name));
        x = music(:, i);
        % embed watermark
        p = PNSequence(Lpn);
        w = randi(2, 1, num_watermark) - 1;
        y1 = EP_embed_echo_watermarking(x, w, p, 0.0062, n);
        y2 = slice_encode(x, w, p, a, n, num_slice);
        
        w1 = EP_decoding_echo_watermarking(y1, num_watermark, p, n);
        w2 = slice_decode(y2, num_watermark, p, n, num_slice);
        
        count1(t) = count1(t) + sum(w == w1);
        count2(t) = count2(t) + sum(w == w2);
                
        srn1(t) = srn1(t) +  SNR(x, y1);
        srn2(t) = srn2(t) +  SNR(x, y2);
    end
    disp(['step' num2str(t) ': ']);
    disp(['accuracy: ' num2str([count1(t) count2(t)] / (count * num_watermark))]);
    disp(['srn: ' num2str([srn1(t) srn2(t)] / count)]);
end
result = [sum(count1) sum(count2)] ./ (times * count * num_watermark) * 100;
srn = [sum(srn1) sum(srn2)] ./ (times * count);
disp(['resutl: ' num2str(result) '%']);
disp(['srn: ' num2str(srn)]);
