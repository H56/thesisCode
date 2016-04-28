function y = cmss_encode(x, w, k, a1, a2)
S = diag(k);
Lw = numel(w);
Lx = numel(x);
Lseg = floor(Lx / Lw);
y = [];
for i = 1 : Lw
    xseg = x((i - 1) * Lseg + 1 : i * Lseg);
    if xseg * S * xseg >= 0
        if w(i) == 0
            yseg = xseg - a2 * S * xseg;
        else
            yseg = xseg + a1 * S * xseg;
        end
    else
        if w(i) == 0
            yseg = xseg - a1 * S * xseg;
        else
            yseg = xseg + a2 * S * xseg;
        end
    end
    y = [y; yseg];
end
y =  [y x(length(y) + 1 : end)];
y = y - mean(y);
y = y / max(abs(y));