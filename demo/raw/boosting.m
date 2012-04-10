function [objectlocation, confidence, t_selectors, strongclassifier, selectors, alpha] = boosting(strongclassifier, sumimagedata, patches)
    global parameter;
    %global haarfeature;
    %global selectors;
    %global alpha;
    numofpatches = size(patches, 1);
    objectlocation = parameter.patch;
    t_selectors = [];
    for  i = 1:50

        [strongclassifier, selectors, alpha] = update(strongclassifier, sumimagedata, parameter.patch, 1, 1.0);
        [strongclassifier, selectors, alpha] = update(strongclassifier, sumimagedata, patches(numofpatches - 3,:), -1, 1.0);
        [strongclassifier, selectors, alpha] = update(strongclassifier, sumimagedata, parameter.patch, 1, 1.0);
        [strongclassifier, selectors, alpha] = update(strongclassifier, sumimagedata, patches(numofpatches - 2,:), -1, 1.0);
        [strongclassifier, selectors, alpha] = update(strongclassifier, sumimagedata, parameter.patch, 1, 1.0);
        [strongclassifier, selectors, alpha] = update(strongclassifier, sumimagedata, patches(numofpatches - 1,:), -1, 1.0);
        [strongclassifier, selectors, alpha] = update(strongclassifier, sumimagedata, parameter.patch, 1, 1.0);
        [strongclassifier, selectors, alpha] = update(strongclassifier, sumimagedata, patches(numofpatches,:),  -1, 1.0);

    end
    flag = 1;
    confidence = [];
    for imgno = parameter.imgstart+1:parameter.imgend
        t_selectors = [t_selectors,  selectors];
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
       % confidencemap = - ones(size(I, 1), size(I, 2));
        confidencemap = detection(strongclassifier, selectors, alpha, sumimagedata, patches);
        confidencemap = (confidencemap - min(min(confidence)))/( max(max(confidence)) - min(min(confidence)) ); 
        imshow(confidencemap);


        g = fspecial('gaussian', [3 ,3]);
        confidencemap = imfilter(confidencemap, g);
        
        % get the max patches
        [maxx, yind] = max(confidencemap, [], 1);
        [maxv, xind] = max(maxx);
        if(max(max(confidencemap)) ~= 0)
            parameter.patch = [xind yind(xind) parameter.patch(3), parameter.patch(4)];
        end
        imshow(I);
        rectangle('Position',parameter.patch, 'edgecolor', 'g');
        text( xind + parameter.patch(3)/2, yind(xind)+ parameter.patch(4)/2, num2str(max(max(confidencemap)), '%6f'));
        objectlocation = [objectlocation;parameter.patch];
        confidence = [confidence ; max(max(confidencemap))];
        

        % generate patches
        patches = generatepatches(parameter.patch, parameter.searchfactor, parameter.overlap);
        numofpatches = size(patches, 1);

        [strongclassifier, selectors, alpha] = update(strongclassifier, sumimagedata, parameter.patch, 1, 1.0);
        [strongclassifier, selectors, alpha] = update(strongclassifier, sumimagedata, patches(numofpatches - 3,:), -1, 1.0);
        [strongclassifier, selectors, alpha] = update(strongclassifier, sumimagedata, parameter.patch, 1, 1.0);
        [strongclassifier, selectors, alpha] = update(strongclassifier, sumimagedata, patches(numofpatches - 2,:), -1, 1.0);
        [strongclassifier, selectors, alpha] = update(strongclassifier, sumimagedata, parameter.patch, 1, 1.0);
        [strongclassifier, selectors, alpha] = update(strongclassifier, sumimagedata, patches(numofpatches - 1,:), -1, 1.0);
        [strongclassifier, selectors, alpha] = update(strongclassifier, sumimagedata, parameter.patch, 1, 1.0);
        [strongclassifier, selectors, alpha] = update(strongclassifier, sumimagedata, patches(numofpatches,:),  -1, 1.0);

        pause(0.00040);
    end
  %  onlboost_faceoc = objectlocation;
  %  onlboost_faceoc_confidence = confidence;
  %  save onlboost_faceoc.mat onlboost_faceoc;
  %  save onlboost_faceoc_confidence.mat onlboost_faceoc_confidence;
end