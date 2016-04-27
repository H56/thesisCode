% clear; close all; clc;
% 
% % files_root_path = 'music_pieces/';
% % all_files = dir(fullfile(files_root_path, '*.wav'));
% % count = length(all_files);
% load('music.mat');
[~, count] = size(music);
fs = 44100;

times = 1;
n = [44 88];
num_watermark = 10;
num_slice = 10;
Lpn = 1023;
a = 0.002;
snr = 0;

count1 = 0;
count2 = 0;
srn1 = 0;
srn2 = 0;
% count_water = 0;
for t = 1 : times
    for i = 1 : count
%         [x, fs] = audioread(strcat(files_root_path, all_files(i).name));
        x = music(:, i);
        % embed watermark
        p = PNSequence(Lpn);
        w = randi(2, 1, num_watermark) - 1;
        y1 = dual_encode(x, w, p, a, n);
        y2 = slice_encode(x, w, p, a, n, num_slice);
        
        w1 = dual_decode(y1, num_watermark, p, n);
        w2 = slice_decode(y2, num_watermark, p, n, num_slice);
        
        count1 = count1 + sum(w == w1);
        count2 = count2 + sum(w == w2);
                
        srn1 = srn1 + SNR(x, y1);
        srn2 = srn2 + SNR(x, y2);
    end
end
result = [count1 count2] ./ (times * count * num_watermark) * 100;
srn = [srn1 srn2] ./ (times * count);
disp(result);
disp(srn);