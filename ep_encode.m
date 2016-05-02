function y  = ep_encode(x, w, k, a, n)
y = [];
count = numel(w);
length_segment = floor(length(x) / count);
EP_key = EP_PNSequence(k);
% key = EP_PNSequence(Lpn);
% X = reshape(x, [], length_segment);
for i = 1 : count
    x_temp = x((i - 1) * length_segment + 1 : i * length_segment);
    h = echo_kernel(EP_key, a, n(w(i) + 1));
    y_temp = conv(x_temp, h');
    y_temp = y_temp(1 : length(x_temp));
    y = cat(1, y, y_temp);
end
if length(y) < length(x)
    y = cat(1, y, x(numel(y) + 1 : end));
end
y = y / max(abs(y));
