function y = echo_encode(x, w, k, a, n)
Lseg = floor(length(x) / length(w));
w = w + 1;
y = [];
for i = 1 : length(w)
    kernel = echo_kernel(k, a, n(w(i)));
    y_temp = conv(x((i - 1) * Lseg + 1 : i *Lseg), kernel');
    y = [y; y_temp(1 : Lseg)];
end
y = [y; x(length(y) + 1 : end)];
y = y / (max(abs(y)) + 1);
