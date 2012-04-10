function drawhaarfeature
    global selectors;
    global haarfeature;
    for i = 1:length(selectors)
        index = haarfeature(i).index(selectors(i));
        area = haarfeature(i).area(selectors(i));
        type = haarfeature(i).type(selectors(i));
        block = haarfeature(i).location(index:index + area - 1, :);
        
    end
end