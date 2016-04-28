function w = ep_decode(y, count, key, n)
Lseg = floor(length(y) / count);
d = zeros(1, length(n));
w = zeros(1, count);
key = EP_PNSequence(key);
len = length(key);
for i  = 1 : count
    yseg = y((i - 1) * Lseg + 1 : i * Lseg);
    cyseg = ifft(log(abs(fft(yseg))));
    for j = 1 : length(n)
        d(j) = [zeros(1, n(j)) key] * cyseg(1 : len + n(j)) - 0.5 * ([zeros(1, n(j) + 1) key] * cyseg(1 : len + n(j) + 1) + [zeros(1, n(j) - 1) key] * cyseg(1 : len + n(j) - 1));
    end
    [~, w(i)] = max(d);
end
w = w - 1;
