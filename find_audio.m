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
delay = 44;

% count_water = 0;
for i = 1 : count
    [x, fs] = audioread(strcat(files_root_path, all_files(i).name));
    k = PNSequence(Lpn);
    index = randi(length(x) - fs, 1);
    x_temp = x(index : index + fs);
    
    q = [zeros(1, delay) k];
    cy = ifft(log(abs(fft(x_temp))));
    delta_c3 = q * cy(1 : Lpn + delay);
    h1 = echo_kernel(k, a, delay);
    y_temp = conv(x_temp, h1');
    y_temp = y_temp(1 : length(x_temp));
    cyt = ifft(log(abs(fft(y_temp))));
    if q * cyt(1 : delay + Lpn) < 0.5
        if delta_c3 >= 0
            h1 = echo_kernel(k, a, delay);
        else
            h1 = echo_kernel(-k, a, delay);
        end
        y_n = conv(x_temp, h1');
        y_n = y_n(1 : length(x_temp));
    end
end