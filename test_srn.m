clear; close all; clc;

files_root_path = 'music_pieces/';
all_files = dir(fullfile(files_root_path, '*.wav'));
count = length(all_files);

times = 100;
n = [44 88];
num_watermark = 10;
num_slice = 10;
Lpn = 1023;
a = [0.001 0.002 0.004 0.006];
snr = 0;

count1 = zeros(1, length(a));
count2 = zeros(1, length(a));
srn1 = zeros(1, length(a));
srn2 = zeros(1, length(a));
% count_water = 0;
for i = 1 : count
    [x, fs] = wavread(strcat(files_root_path, all_files(i).name));
    for t = 1 : times        
        % embed watermark
        p = PNSequence(Lpn);
        w = randi(2, 1, num_watermark) - 1;
        for k = 1 : length(a)
            y1 = echo_encode(x, w, p, a(k), n);
            y2 = slice_encode(x, w, p, a(k), n, num_slice);
                
            srn1(k) = srn1(k) + SNR(x, y1);
            srn2(k) = srn2(k) + SNR(x, y2);
        end
    end
end
% result = [count1 count2] ./ (times * count * num_watermark) * 100;
srn = [srn1' srn2'] ./ (times * count);
% disp(result);
disp(srn);