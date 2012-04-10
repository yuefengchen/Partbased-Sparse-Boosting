function haarfeature = reconstructionhaarfeature(haarfeature_before)
    numofhaarfeature = length(haarfeature_before);
    index = 1;
    haarfeature.area = [];
    haarfeature.mean = [];
    haarfeature.sigma = [];
    haarfeature.type = [];
    haarfeature.location = [];
    haarfeature.weight = [];
    haarfeature.index = [];   
    for i = 1:numofhaarfeature
        haarfeature.area = [haarfeature.area ; haarfeature_before(i).areas];
        haarfeature.mean = [haarfeature.mean ; haarfeature_before(i).mean];
        haarfeature.sigma = [haarfeature.sigma;haarfeature_before(i).sigma];
        haarfeature.type = [haarfeature.type ; haarfeature_before(i).type];
        haarfeature.location = [haarfeature.location ;haarfeature_before(i).location];
        haarfeature.weight = [haarfeature.weight;haarfeature_before(i).weight];
        haarfeature.index = [haarfeature.index; index];
        index = index +  haarfeature_before(i).areas;
    end
end