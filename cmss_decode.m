function w = cmss_decode(y, Lw, k)
Lseg = floor(numel(y) / Lw);
S = sparse([1 : Lseg], [1 : Lseg], k);
w = [];
for i = 1 : Lw
    yseg = y((i - 1) * Lseg + 1 : i * Lseg);
    z = yseg' * S * yseg;
    if z >= 0
        w = [w 1];
    else
        w = [w 0];
    end
end
