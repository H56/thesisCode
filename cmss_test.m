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
[~, count] = size(data);
fs = 44100;

times = 1;
n = [44 88];
num_watermark = 10;
num_slice = 10;
Lpn = 1023;
a = 0.002;
a1 = 0.00001;
a2 = 0.072;
snr = 0;

count1 = zeros(times, 1);
count2 = zeros(times, 1);
srn1 = zeros(times, 1);
srn2 = zeros(times, 1);
% count_water = 0;
for t = 1 : times
    for i = 1 : count
%         [x, fs] = audioread(strcat(files_root_path, all_files(i).name));
        x = data(:, i);
        % embed watermark
        p = PNSequence(Lpn);
        w = randi(2, 1, num_watermark) - 1;
        [y1 k] = cmss_encode(x, w, a1, a2);
        y2 = slice_encode(x, w, p, a, n, num_slice);
        
        w1 = cmss_decode(y1, num_watermark, k);
        w2 = slice_decode(y2, num_watermark, p, n, num_slice);
        
        count1(t) = count1(t) + sum(w == w1);
        count2(t) = count2(t) + sum(w == w2);
                
        srn1(t) = srn1(t) +  SNR(x, y1);
        srn2(t) = srn2(t) +  SNR(x, y2);
        if mod(i, 50) == 0
            disp(['t: ' num2str(t) ', i: ' num2str(i) ': ']);
            disp(['result: ' num2str([count1(t) count2(t)] / (i * num_watermark) * 100)]);
            disp(['srn: ' num2str([srn1(t) srn2(t)] / i)]);
        end
    end
    disp(['step' num2str(t) ': ']);
    disp(['accuracy: ' num2str([count1(t) count2(t)] / (count * num_watermark))]);
    disp(['srn: ' num2str([srn1(t) srn2(t)] / count)]);
end
result = [sum(count1) sum(count2)] ./ (times * count * num_watermark) * 100;
srn = [sum(srn1) sum(srn2)] ./ (times * count);
disp(['resutl: ' num2str(result) '%']);
disp(['srn: ' num2str(srn)]);
