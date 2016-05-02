function PNRet = EP_PNSequence(PN)
PNRet = PN;
n = numel(PN);
for i = 2 : n - 1
    PNRet(i) = ((-1)^(fix((PNRet(i - 1) + PN(i - 1) + PN(i) + PN(i + 1)) / 4))) * PN(i);
end
