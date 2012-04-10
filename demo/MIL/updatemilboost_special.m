function  [strongclassifier, selectors] = updatemilboost_special(strongclassifier, sumimagedata, pospatch, negpatch)
    global parameter;
    numofpospatches = size(pospatch, 1);
    numofnegpatches = size(negpatch, 1);
    
    numofweakclassifier = parameter.numweakclassifiers;
    
    posweight = zeros(numofweakclassifier, numofpospatches);
    negweight = zeros(numofweakclassifier, numofnegpatches);
    
    selectors = [];
    
    pospred = zeros(numofweakclassifier, numofpospatches);
    negpred = zeros(numofweakclassifier, numofnegpatches);
    
    Hpos = zeros(numofpospatches,1);
    Hneg = zeros(numofnegpatches,1);
    
    Poslikely = zeros(numofweakclassifier, 1);
    Neglikely = zeros(numofweakclassifier, 1);
    likely = zeros(numofweakclassifier,1 );
    index = 1:numofweakclassifier;
    % MIL NO ALPHA
    %alpha = zeros(parameter.numselectors, 1);
    
    
    
    for j = 1: numofpospatches
        strongclassifier.weightvalue = haarfeatureeval(strongclassifier, sumimagedata, pospatch(j,:));
        posweight(:, j) = strongclassifier.weightvalue;
        strongclassifier = posgaussiandistributionupdate(strongclassifier, posweight(:, j), parameter.minfactor); 
    end
    % negsample update
    for j = 1: numofnegpatches
        strongclassifier.weightvalue = haarfeatureeval(strongclassifier, sumimagedata, negpatch(j,:));
        negweight(:, j) = strongclassifier.weightvalue;
        strongclassifier = neggaussiandistributionupdate(strongclassifier, negweight(:, j), parameter.minfactor); 
    end

    for j = 1: numofpospatches
        pospred(:,j) = classifyrealboost(strongclassifier, posweight(:,j));
    end
    for j = 1: numofnegpatches
        negpred(:,j) = classifyrealboost(strongclassifier, negweight(:,j));
    end
    
    
    for i = 1:parameter.numselectors
        
        %%%%%%% 
        % get the positive bag ' s  probility
        for j = 1:numofweakclassifier
            lll = 1.0;
            for k = 1:numofpospatches
                %  p(j,k) = sigmod(Hpos(k) + pospred(j,k)) function  1 /  (1 + exp( - Hpos(k) - pospred(j,k))
                %  1 - || 1 - p(j,k)
                lll = lll * (1 - 1 / (1 + exp(- Hpos(k) - pospred(j,k))) );
            end
            Poslikely(j) = -log(1e-5 + 1.0 - lll );
           
            % get the negative bag's probility
            lll = 0;
            for k = 1:numofnegpatches
                lll = lll - log(( 1e-5 + 1 - 1/ ( 1 + exp( - Hneg(k) - negpred(j,k) ) ) ) );
            end
            Neglikely(j) = lll;
            
        end
        
        likely = Poslikely/numofpospatches + Neglikely/numofnegpatches;
        % choose the best of the classifier
        %
        
        % choose the best of the classifier
        [maxvalue, ind] = sort(likely);
        for j = 1:numofweakclassifier
            if sum(ismember(selectors, ind(j))) == 0
                selectors(i) = ind(j);
                break;
            end
        end
            %{
        likely(selectors) = [];
        selectors = [selectors, index(ind(1))];
        index(find(index == selectors(i))) = [];
        % update the Hpos and Hneg
            %}
        Hpos = Hpos + pospred(selectors(i), :)';
        Hneg = Hneg + negpred(selectors(i), :)';
 
            
        
    end
end