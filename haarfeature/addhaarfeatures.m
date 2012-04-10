function addhaarfeatures(onehaarfeature, indextoinsert)
    global haarfeature;
    numofhaarfeatures = length(haarfeature.area);
    if indextoinsert  == numofhaarfeatures + 1 
        haarfeature.area = [haarfeature.area ; onehaarfeature.area];
        haarfeature.mean = [haarfeature.mean ; onehaarfeature.mean];
        haarfeature.sigma = [haarfeature.sigma;onehaarfeature.sigma];
        haarfeature.type = [haarfeature.type ; onehaarfeature.type];
        % add
        haarfeature.correct = [haarfeature.correct ; onehaarfeature.correct];
        haarfeature.wrong = [haarfeature.wrong ; onehaarfeature.wrong];
        
        haarfeature.location = [haarfeature.location ;onehaarfeature.location];
        haarfeature.weight = [haarfeature.weight;onehaarfeature.weight];
        index = haarfeature.index(length(haarfeature.index)) + haarfeature.area(length(haarfeature.index));
        haarfeature.index = [haarfeature.index; index];
    else
        % move haarfeature(index:numofhaarfeatures) to  haarfeature(index + 1:numofhaarfeatures + 1)
        % 
        
        haarfeature.area(indextoinsert+1:numofhaarfeatures+1)  = haarfeature.area(indextoinsert:numofhaarfeatures);
        haarfeature.mean(indextoinsert+1:numofhaarfeatures+1)  = haarfeature.mean(indextoinsert:numofhaarfeatures);
        haarfeature.sigma(indextoinsert+1:numofhaarfeatures+1) = haarfeature.sigma(indextoinsert:numofhaarfeatures);
        haarfeature.type(indextoinsert+1:numofhaarfeatures+1)  = haarfeature.type(indextoinsert:numofhaarfeatures);
        haarfeature.index(indextoinsert+1:numofhaarfeatures+1) = haarfeature.index(indextoinsert:numofhaarfeatures) + onehaarfeature.area;
        % add
        haarfeature.correct(indextoinsert+1:numofhaarfeatures+1)  = haarfeature.correct(indextoinsert:numofhaarfeatures); 
        haarfeature.wrong(indextoinsert+1:numofhaarfeatures+1)  = haarfeature.wrong(indextoinsert:numofhaarfeatures);  
        
        locationlength = size(haarfeature.location, 1);
        locationfirst = haarfeature.index(indextoinsert);
        haarfeature.location(locationfirst + onehaarfeature.area:locationlength + onehaarfeature.area,:) =  ...
            haarfeature.location(locationfirst:locationlength,:);
        haarfeature.weight(locationfirst + onehaarfeature.area:locationlength + onehaarfeature.area) = ...
            haarfeature.weight(locationfirst:locationlength);
      
        
        haarfeature.area(indextoinsert) = onehaarfeature.area;
        haarfeature.mean(indextoinsert) = onehaarfeature.mean;
        haarfeature.sigma(indextoinsert) = onehaarfeature.sigma;
        haarfeature.type(indextoinsert) = onehaarfeature.type;
        % add
        haarfeature.correct(indextoinsert) = onehaarfeature.correct;
        haarfeature.wrong(indextoinsert) = onehaarfeature.wrong;
        haarfeature.location(locationfirst:locationfirst + onehaarfeature.area -1 ,:) = onehaarfeature.location;
        haarfeature.weight(locationfirst:locationfirst + onehaarfeature.area - 1) = onehaarfeature.weight;
    end
end