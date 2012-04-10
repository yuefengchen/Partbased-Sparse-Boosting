function confidence = strongclassify(sumimagedata, patch)
    global haarfeature;
    global selectors;
    global alpha;
    x_offset = patch(1);
    y_offset = patch(2);
    weightvalue = [];
    for i = 1:length(selectors)
        locationindex = haarfeature(i).index(selectors(i));
        areas = haarfeature(i).area(selectors(i));
        
        location = haarfeature(i).location(locationindex:locationindex + areas - 1, :);
        weight = haarfeature(i).weight(locationindex:locationindex + areas - 1, :);
        location(:,1) = location(:,1) + x_offset;
        location(:,2) = location(:,2) + y_offset;
        
        topleft  = sub2ind(size(sumimagedata), location(:,2), location(:,1));
        botright = sub2ind(size(sumimagedata), location(:,2) + location(:,4), location(:, 1) + location(:, 3));
        topright = sub2ind(size(sumimagedata), location(:,2), location(:,1) + location(:,3));
        botleft  = sub2ind(size(sumimagedata), location(:,2) + location(:,4), location(:,1));
        blocksum =  sumimagedata(topleft) + sumimagedata(botright) - sumimagedata(topright) - sumimagedata(botleft);
        weightvalue = [weightvalue; sum(blocksum.*weight)];
    end
    classid = classifybyselector(weightvalue);
    confidence = sum((classid.*alpha))/sum(alpha);
end