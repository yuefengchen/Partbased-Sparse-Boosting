function classreal = classifyrealboost(strongclassifier,value)
    % log ( p+ / p-) = - log(sigma+) + (x - mean+)^2 / (2 * sigma+^2) -
    %                 (- log(sigma-) + (x - mean-)^2 / (2 * sgima-^2)
    %
    pmean = strongclassifier.posgaussian(:, 1);
    psigma = strongclassifier.posgaussian(:, 2);
    nmean = strongclassifier.neggaussian(:, 1);
    nsigma = strongclassifier.neggaussian(:, 2);
    pos = (1 ./ (sqrt(2*pi).*psigma) ) .* exp( -(value - pmean).^2 ./ (2*psigma.^2)) + 1e-5;
    neg = (1 ./ (sqrt(2*pi).*nsigma) ) .* exp( -(value - nmean).^2 ./ (2*nsigma.^2)) + 1e-5;
    classreal = log ( (pos ) ./(neg));
end