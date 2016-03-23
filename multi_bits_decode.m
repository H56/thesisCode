function w = multi_bits_decode(y, Lw, k, n)
Lwseg = log2(length(n));
if 2^Lwseg ~= length(n)
    disp('wrong input');
    return;
end
N = ceil(Lw / Lwseg);
Lseg = floor(length(y) / N);
w = [];
d = zeros(1, length(n));
for i = 1 : N
    y_seg = y((i - 1) * Lseg + 1 : i * Lseg);
    cy = ifft(log(abs(fft(y_seg))));
    for j = 1 : length(n)
        d(j) = [zeros(1, n(j)) k] * cy(1 : length(k) + n(j));
    end
    [~, index] = max(d);
    b = dec2bin(index - 1, Lwseg);
    w = [w double(b) - 48];
end
w = w(1 : Lw);
    