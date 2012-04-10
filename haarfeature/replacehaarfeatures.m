function replacehaarfeatures(index1, index2, patchsize, minarea)
    % replace the haarfeature whose index = index1 with the id = index2 ' s
    % haarfeature
    
    % first delete haarfeature with the index1
    
   
    global haarfeature;
    onehaarfeature.area = haarfeature.area(index2);
    onehaarfeature.mean = haarfeature.mean(index2);
    onehaarfeature.sigma = haarfeature.sigma(index2);
    onehaarfeature.type  = haarfeature.type(index2);
    % add
    onehaarfeature.correct  = haarfeature.correct(index2);
    onehaarfeature.wrong  = haarfeature.wrong(index2);
    indexofidnex2 = haarfeature.index(index2);
    onehaarfeature.location = haarfeature.location(indexofidnex2:indexofidnex2 + onehaarfeature.area -1, :);
    onehaarfeature.weight = haarfeature.weight(indexofidnex2:indexofidnex2 + onehaarfeature.area -1);
    
    deletehaarfeatures(index1);
    addhaarfeatures(onehaarfeature, index1);
    
    onehaarfeature = generateonefeature(patchsize, minarea);
    deletehaarfeatures(index2);
    addhaarfeatures(onehaarfeature, index2);
end