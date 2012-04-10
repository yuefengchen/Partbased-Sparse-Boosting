function [pospatches, negpatches] = generatesample(pmindis, maxpossamplenum,  nmindis, nmaxdis , maxnegsamplenum)
    global parameter;
    objx = parameter.patch(1);
    objy = parameter.patch(2);
    width = parameter.patch(3);
    height = parameter.patch(4);
    
    patches = generatepatchesbydistance(parameter.patch, nmaxdis, parameter.overlap);
    distance = sqrt( (patches(:,1) - objx).^2 + (patches(:,2) - objy).^2);
    
    % generate positive samples
    posindex = find(distance < pmindis);
    if length(posindex) > maxpossamplenum
        rndposindex = posindex(randperm(length(posindex)));
        pospatches = patches(rndposindex(1:maxpossamplenum), :);
    else
        pospatches = patches(posindex, :);
    end
    
    % generate negative  samples
    negindex = find(distance > nmindis & distance < nmaxdis);
    if  length(negindex) > maxnegsamplenum
        rndnegindex = negindex( randperm( length( negindex )) );
        negpatches = patches(rndnegindex(1:maxnegsamplenum), :);
       
    else
        negpatches = patches(negindex, :); 
    end
    
end