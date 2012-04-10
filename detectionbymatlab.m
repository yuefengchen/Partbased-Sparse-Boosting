function confidencemap = detectionbymatlab(sumimagedata, patches)
    global parameter; 
    confidencemap = zeros(parameter.imageheight, parameter.imagewidth);
    numpatches = size(patches, 1);
    for patchno = 1:numpatches - 4
        y = patches(patchno, 2);
        x = patches(patchno, 1);
        confidencemap(y, x) = strongclassify(sumimagedata, patches(patchno,:));
      %  k = k + 1;
    end
end