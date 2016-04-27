function y = dual_encode(x, w, k, a, n)
Lseg = floor(length(x) / length(w));
w = w + 1;
y = [];
k_odd = k(1 : 2 : end);
k_even = k(2 : 2 : end);
y_temp = zeros(Lseg, 1);
for i = 1 : length(w)
    kernel_odd = echo_kernel(k_odd, a, n(w(i)));
    kernel_even = -echo_kernel(k_even, a, n(w(i)));
    start = (i - 1) * Lseg + 1;
    if mod(start, 2) == 1 
        start_odd = start;
        start_even = start + 1;
    else
        start_even = start;
        start_odd = start + 1;
    end
    x_odd = x(start_odd : 2 : i * Lseg);
    x_even = x(start_even : 2 : i * Lseg);
    y_odd = conv(x_odd, kernel_odd');
    y_even = conv(x_even, kernel_even');
    y_temp(1 : 2 : end) = y_odd(1 : length(x_odd));
    y_temp(2 : 2 : end) = y_even(1 : length(x_even));
    y = [y; y_temp(1 : Lseg)];
end
y = [y; x(length(y) + 1 : end)];
y = y / (max(abs(y)));