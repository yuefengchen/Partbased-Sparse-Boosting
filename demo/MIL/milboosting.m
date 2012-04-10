function [objectlocation, confidence, t_selectors, strongclassifier, selectors] = milboosting(strongclassifier, sumimagedata)
    
    global parameter;
    objectlocation = parameter.patch;
    [pospatches, negpatches] = generatesample( parameter.mil_initposradtrain, 100000, ...
        1.5*parameter.mil_initposradtrain, 2* parameter.mil_wrchwinsz, parameter.mil_negnumtrain);
    
    confidence = [];
    t_selectors = [];
    % MIL INIT
    %for  i = 1:50
    [strongclassifier, selectors] = updatemilboost_special(strongclassifier, sumimagedata, pospatches, negpatches);
    %end
    
    flag = 1;
    for imgno = parameter.imgstart+1:parameter.imgend
        t_selectors = [t_selectors, selectors];
        if mod(imgno , 10) == 0 
            imgno
            if flag
                tic
            else
                toc
            end
            flag = ~flag;
        end

        I = imread(num2str(imgno, parameter.imdirformat));
        subplot(1, 2, 1);
        imshow(I);
        sumimagedata = intimage(I);
        subplot(1, 2, 2);
        %confidencemap = detectionbymatlab(sumimagedata, patches); 
        %confidencemap = -ones(size(I));
        patches = generatepatches(parameter.patch, parameter.searchfactor, parameter.overlap);
        confidencemap = mildetection_special(strongclassifier, selectors, sumimagedata, patches); 
        %confidencemap = (confidencemap - 1)/2;
       % confidencemap = (confidencemap - min(min(confidencemap)))/( max(max(confidencemap)) - min(min(confidencemap)) );
        imshow(confidencemap);


        g = fspecial('gaussian', [3 ,3]);
        confidencemap = imfilter(confidencemap, g);

        % get the max patches
        [maxx, yind] = max(confidencemap, [], 1);
        [maxv, xind] = max(maxx);
        parameter.patch = [xind yind(xind) parameter.patch(3) parameter.patch(4)];
        imshow(I);
        rectangle('Position',parameter.patch, 'edgecolor', 'g');
        text( xind + parameter.patch(3)/2, yind(xind)+ parameter.patch(4)/2, num2str(max(max(confidencemap)), '%6f'));
        objectlocation = [objectlocation;parameter.patch];
        confidence = [confidence ; max(max(confidencemap))];


        % generate patches
        [pospatches, negpatches] = generatesample( parameter.mil_posradtrain, 100000, ...
              parameter.mil_posradtrain + 5, 1.5* parameter.mil_wrchwinsz, parameter.mil_negnumtrain);
       
        [strongclassifier, selectors] = updatemilboost_special(strongclassifier, sumimagedata, pospatches, negpatches);
    end
 
end