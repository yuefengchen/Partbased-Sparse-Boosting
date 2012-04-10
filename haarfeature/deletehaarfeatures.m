function deletehaarfeatures(indexofhaarfeature)
    global haarfeature;
    index  = haarfeature.index(indexofhaarfeature);
    areanum = haarfeature.area(indexofhaarfeature);
    haarfeaturenum = length(haarfeature.area);
    haarfeature.area(indexofhaarfeature) = [];
    haarfeature.mean(indexofhaarfeature) = [];
    haarfeature.sigma(indexofhaarfeature) = [];
    haarfeature.type(indexofhaarfeature) = [];
    % add
    haarfeature.correct(indexofhaarfeature) = [];
    haarfeature.wrong(indexofhaarfeature) = [];
    
    haarfeature.location(index:index + areanum - 1, :) = [];
    haarfeature.weight(index:index + areanum - 1) = [];
    haarfeature.index(indexofhaarfeature+1:haarfeaturenum) = haarfeature.index(indexofhaarfeature+1:haarfeaturenum) - areanum;
    haarfeature.index(indexofhaarfeature) = [];
end