function watermarking = EP_decoding_echo_watermarking1(y, key, delta, length_segment, watermarking_length)
if length_segment <= 0
    length_segment = fix(numel(y) / watermarking_length);
end
watermarking = [];
p = [key zeros(1, length_segment - length(key))];
for i = 1 : watermarking_length
    cy = ifft(log(abs(fft(y((i - 1)*length_segment + 1 : i * length_segment)))));
    cy0 = [zeros(1, delta(1)) p(1, 1 : end - delta(1))]*cy-0.5*([zeros(1, delta(1)-1) p(1, 1 : end - delta(1)+1)]*cy + [zeros(1, delta(1)+1) p(1, 1 : end - delta(1)-1)]*cy);
    cy1 = [zeros(1, delta(2)) p(1, 1 : end - delta(2))]*cy-0.5*([zeros(1, delta(2)-1) p(1, 1 : end - delta(2)+1)]*cy + [zeros(1, delta(2)+1) p(1, 1 : end - delta(2)-1)]*cy);
    if cy0 >= cy1
        watermarking = [watermarking 0];
    else
        watermarking = [watermarking 1];
    end
end
