function y = wav_quantize(x, nbits)
m = 2.^(nbits-1);
switch nbits
case 8,
   b=128;
case {16,24, 32},
   b=0;
otherwise,
   error(message('MATLAB:audiovideo:wavwrite:invalidBitsPerSample'));
end
% Scale the input data:
if isfloat(x)
    y = round(m .* x + b);
else
    % integer data types should not be scaled:
    y = x;
end
[samples,channels] = size(y);
total_samples = samples*channels;
y = reshape(y',total_samples,1);
y = (y - b) ./ m;