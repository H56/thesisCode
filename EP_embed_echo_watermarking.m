function y  = EP_embed_echo_watermarking(x, watermarking, key, a, delta)
y = [];
n = numel(watermarking);
length_segment = floor(length(x) / n);
EP_key = EP_PNSequence(key);
% key = EP_PNSequence(Lpn);
% X = reshape(x, [], length_segment);
for i = 1 : n
    x_temp = x((i - 1) * length_segment + 1 : i * length_segment);
    h = echo_kernel(EP_key, a, delta(watermarking(i) + 1));
    y_temp = conv(x_temp, h');
    y_temp = y_temp(1 : length(x_temp));
    y = cat(1, y, y_temp);
end
if length(y) < length(x)
    y = cat(1, y, x(numel(y) + 1 : end));
end
