function  updatestrongclassifier( sumimagedata, patch, label, importance)
    global parameter;
    global haarfeature;
    global selectors;
    global alpha;
   
    for i = 1:parameter.numselectors
        % for each weakclassifiers update 
        % possion sampling
        % calculate the haarfeature value for each weakclassifier
        haarfeatureeval(i, sumimagedata, patch);
        k = poissrnd(importance);
        %%%
        %%%
        % for debug
        %%%%
        k = 0;
        for j = 1:k+1
            % update weak classifier    
            if label == 1
                % pos update
                posgaussiandistributionupdate(i, haarfeature(i).weightvalue, parameter.minfactor);
            else
                % neg update
                neggaussiandistributionupdate(i, haarfeature(i).weightvalue, parameter.minfactor);
            end
        end
      
        % classification
        classid = classify(i, haarfeature(i).weightvalue);
        indwrong = find(classid ~=  label);
        indcorrect = find(classid ==  label);
        haarfeature(i).wrong(indwrong) =  haarfeature(i).wrong(indwrong) + importance;
        haarfeature(i).correct(indcorrect) =  haarfeature(i).correct(indcorrect) + importance;
        % calculate the error
        error = haarfeature(i).wrong(1:parameter.numweakclassifiers) ./ ...
            (haarfeature(i).wrong(1:parameter.numweakclassifiers) + haarfeature(i).correct(1:parameter.numweakclassifiers));
        % get the selectclassifier with the least error
        [minerror, selectclassifierindex] = min(error);
        selectors(i) = (selectclassifierindex);
        if minerror >= 0.5
            alpha(i) = 0;
        else
            alpha(i) = log((1 - minerror)/minerror);
        end
        % update the importance
        if classid(selectclassifierindex) == label
            % decrease the importance
            importance = importance * sqrt(minerror/(1 - minerror));
        else
            importance = importance * sqrt((1 - minerror)/minerror);
        end
    end
end