function y = multi_bits_encode(x, w, k, a, n)
Lwseg = log2(length(n));
if 2^Lwseg ~= length(n)
    disp('wrong input');
    return;
end
N = ceil(length(w) / Lwseg);
if length(w) < N * Lwseg
    w = [w zeros(1, N * Lwseg - length(w))];
end
Lseg = floor(length(x) / N);
y = [];
for i = 1 : N
    w_temp = w((i - 1) * Lwseg + 1 : i * Lwseg);
    n0 = n(bin2dec(num2str(w_temp, '%d')) + 1);
    kernel = echo_kernel(k, a, n0);
    x_seg = x((i - 1) * Lseg + 1 : i * Lseg);
    y_seg = conv(x_seg, kernel);
    y_seg = y_seg(1 : length(x_seg));
    y = [y; y_seg];
end
y = [y; x(length(y) + 1 : end)];
y = y - mean(y);
y = y / (max(abs(y)));
