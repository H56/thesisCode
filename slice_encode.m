function y = slice_encode(x, w, k, a, n, ns)
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
Lslice = floor(Lseg / ns);
y = [];
for i = 1 : N
    xseg = x((i - 1) * Lseg + 1 : i * Lseg);
    w_temp = w((i - 1) * Lwseg + 1 : i * Lwseg);
    kernel = echo_kernel(k, a, n(bin2dec(num2str(w_temp, '%d')) + 1));
    for j = 1 : ns
        xslice = xseg((j - 1) * Lslice + 1 : j * Lslice);
        yslice = conv(xslice, kernel');
        yslice = yslice(1 : Lslice);
        y = [y; yslice];
    end
    y = [y; xseg(ns * Lslice + 1 : end)];
end
y = [y; x(length(y) + 1 : end)];
y = y / (max(abs(y)));
