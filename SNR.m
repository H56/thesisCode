function snr = SNR(x, y)
snr = 10*log10(sum(x.^2) / sum((y - x).^2));