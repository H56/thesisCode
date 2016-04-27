function w = dual_decode(y, count, k, n)
Lseg = floor(length(y) / count);
d = zeros(1, length(n));
w = zeros(1, count);
for i  = 1 : count
    start = (i - 1) * Lseg + 1;
    if mod(start, 2) == 1 
        start_odd = start;
        start_even = start + 1;
    else
        start_even = start;
        start_odd = start + 1;
    end
    y_odd = y(start_odd : 2 : i * Lseg);
    y_even = y(start_even : 2 : i * Lseg);
    
    cy_odd = ifft(log(abs(fft(y_odd))));
    cy_even = ifft(log(abs(fft(y_even))));
    for j = 1 : length(n)
        d(j) = [zeros(1, n(j)) k] * cy_odd(1 : length(k_odd) + n(j)) - [zeros(1, n(j)) k] * cy_even(1 : length(k_even) + n(j));
    end
    [~, w(i)] = max(d);
end
w = w - 1;