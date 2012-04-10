function classid = classifybyselector(value)
    global selectors;
    global haarfeature;
    global parameter;
    posgaussian = [];
    neggaussian = [];
    for i = 1:parameter.numselectors
        posgaussian = [posgaussian; haarfeature(i).posgaussian(selectors(i), 1)];
        neggaussian = [neggaussian; haarfeature(i).neggaussian(selectors(i), 1)];
    end
    mean = (posgaussian + neggaussian)/2;
    
    logicalval = ~xor (value < mean , posgaussian < neggaussian);
    classid = ones(length(value), 1);
    classid(find(logicalval == 0)) = -1;
end