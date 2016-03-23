function PN = PNSequence(n)
PN = randn(1, n);
for i = 1 : n
   if (PN(i) < 0)
       PN(i) = -1;
   else
       PN(i) = 1;
    end
end