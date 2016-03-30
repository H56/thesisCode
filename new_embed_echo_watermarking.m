function y = new_embed_echo_watermarking(x, watermarking, a, delta, length_segment, key)
y = [];
n = numel(watermarking);
if length_segment <= 0
    length_segment = fix(numel(x) / n);
end
key_temp = key;
p = [key_temp zeros(1, length_segment - length(key_temp))];
for i = 1 : n
    x_temp = x((i - 1) * length_segment + 1 : i * length_segment);
    q = [zeros(1, delta(watermarking(i) + 1)) p(1 : end - delta(watermarking(i) + 1))];
    delta_c3 = q * ifft(log(abs(fft(x_temp))));
    if delta_c3 >= 0
        h1 = echo_kernel(key_temp, a, delta(watermarking(i) + 1));
    else
        h1 = echo_kernel(-key_temp, a, delta(watermarking(i) + 1));
    end
    y_temp = conv(x_temp, h1');
    y_temp = y_temp(1 : length(x_temp));
    y = cat(1, y, y_temp);
end
if length(y) < length(x)
    y = cat(1, y, x(numel(y) + 1 : end));
end
y = y / (max(abs(y)) + 0.1);
