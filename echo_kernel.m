function h = echo_kernel(p, a, n0)
if n0 >= 0
    h = a * cat(2, zeros(1, n0), p);
else
    h = a * cat(2, p, zeros(1, -n0));
end
h(1) = 1;