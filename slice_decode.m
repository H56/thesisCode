function w = slice_decode(y, Lw, key, n, ns)
Lwseg = log2(length(n));
if 2^Lwseg ~= length(n)
    disp('wrong input');
    return;
end
N = ceil(Lw / Lwseg);
Lseg = floor(length(y) / N);
Lslice = floor(Lseg / ns);
w = [];
for i = 1 : N
    yseg = y((i - 1) * Lseg + 1 : i * Lseg);
    d = zeros(1, numel(n));
    for j = 1 : ns
        yslice = yseg((j - 1) * Lslice + 1 : j * Lslice);
        cyslice = ifft(log(abs(fft(yslice))));
        for k = 1 : length(n)
            d(k) = d(k) + [zeros(1, n(k)) key] * cyslice(1 : length(key) + n(k));
        end
    end
    [~, index] = max(d);
    b = dec2bin(index - 1, Lwseg);
    w = [w double(b) - 48];
end
w = w(1 : Lw);