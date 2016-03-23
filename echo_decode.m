function w = echo_decode(y, count, key, n)
Lseg = floor(length(y) / count);
d = zeros(1, length(n));
w = zeros(1, count);
for i  = 1 : count
    yseg = y((i - 1) * Lseg + 1 : i * Lseg);
    cyseg = ifft(log(abs(fft(yseg))));
    for j = 1 : length(n)
        d(j) = [zeros(1, n(j)) key] * cyseg(1 : length(key) + n(j));
    end
    [~, w(i)] = max(d);
end
w = w - 1;