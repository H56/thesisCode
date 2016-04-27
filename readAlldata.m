clear; close all; clc;

files_root_path = 'music_pieces/';
all_files = dir(fullfile(files_root_path, '*.wav'));
count = length(all_files);

result = [];
for i = 1 : count
    [x, fs] = audioread(strcat(files_root_path, all_files(i).name));
    x = x / max(abs(x));
    if isempty(result)
        result = x;
    else
        result = [result x];
    end
end
