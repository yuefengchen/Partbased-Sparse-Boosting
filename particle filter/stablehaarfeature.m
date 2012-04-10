%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% affine transformation
% P = [theta,phi, scale_x, scale_y, x_offset, y_offset]
%%%%%%%%%
function stablestrongclassifier = stablehaarfeature(strongclassifier, rawimage, patch, numofaffinesample, affineparameter)


    
    global parameter;
    stablestrongclassifier = struct ( 'area',        [], ...
                                      'type',        [], ...
                                      'location' ,   [], ...
                                      'weight',      [], ...
                                      'index',       [], ...
                                      'posgaussian', [], ...
                                      'neggaussian', [], ...
                                      'correct',     [], ...
                                      'wrong',       [], ...
                                      'weightvalue', []);
    
   
                                      
    affinep = generateaffineparameter(numofaffinesample, affineparameter);
    affinesumdata = generateaffinedata(rawimage, patch, affinep);
    evalvalue = [];
    for i = 1:size(affinesumdata, 3)
        evalvalue = [evalvalue, haarfeatureeval(strongclassifier, affinesumdata(:,:, i), [1,1, 0, 0])];
    end
    meanv =mean(evalvalue, 2);
    stdv = std(evalvalue, 0, 2);
    std2mean = abs(stdv./meanv);
    [sortedvalue, sortedindex] = sort(std2mean);
    index = 1;
    for i = 1:parameter.numweakclassifiers
        stablestrongclassifier.area(i) = strongclassifier.area(sortedindex(i));
        stablestrongclassifier.type(i) = strongclassifier.type(sortedindex(i));
        stablestrongclassifier.posgaussian(i,:) = strongclassifier.posgaussian(sortedindex(i), :);
        stablestrongclassifier.neggaussian(i,:) = strongclassifier.neggaussian(sortedindex(i), :);
        stablestrongclassifier.correct(i) = strongclassifier.correct(sortedindex(i));
        stablestrongclassifier.wrong(i) = strongclassifier.wrong(sortedindex(i));
       % stablestrongclassifier.weightvalue(i) =  strongclassifier.weigthvalue(sortedindex(i));
        
        indexvalue = strongclassifier.index(sortedindex(i));
        areavalue = strongclassifier.area(sortedindex(i));
        
        location = strongclassifier.location(indexvalue: indexvalue + areavalue - 1, :);
        weight = strongclassifier.weight(indexvalue: indexvalue + areavalue - 1);
        
        stablestrongclassifier.location(index:index + areavalue - 1, :) = location;
        stablestrongclassifier.weight(index:index + areavalue - 1) = weight;
        stablestrongclassifier.index(i) = index;
       
        
        index = index + areavalue;
    end
    stablestrongclassifier.area = stablestrongclassifier.area';
    stablestrongclassifier.type = stablestrongclassifier.type';
    stablestrongclassifier.correct = stablestrongclassifier.correct';
    stablestrongclassifier.wrong = stablestrongclassifier.wrong';
    stablestrongclassifier.weight = stablestrongclassifier.weight';
    stablestrongclassifier.index = stablestrongclassifier.index';
end