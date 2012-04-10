function affinep = generateaffineparameter(numofaffinesample, affineparameter)
    affinep = repmat(affineparameter.p, [1 numofaffinesample]) + ...
        randn(length(affineparameter.p), numofaffinesample) .* repmat(affineparameter.std, [1 numofaffinesample]);
end