function [objectlocation, confidence, t_selectors] = sparserealboosting( sumimagedata, patches)
    
    global parameter;
    global haarfeature;
    global selectors;
    global alpha;
    objectlocation = parameter.patch;
    numofpatches = size(patches, 1);
    patchesforupdate = zeros(8, 4);
    labelforupdate = zeros(8, 1);
    t_selectors = [];
    for  i = 1:50

        importance = ones(8,1);

        patchesforupdate(1,:) = parameter.patch;
        labelforupdate(1) = 1;

        patchesforupdate(2,:) = patches(numofpatches - 3,:);
        labelforupdate(2) = -1;

        patchesforupdate(3,:) = parameter.patch;
        labelforupdate(3) = 1;

        patchesforupdate(4,:) = patches(numofpatches - 2,:);
        labelforupdate(4) = -1;

        patchesforupdate(5,:) = parameter.patch;
        labelforupdate(5) = 1;

        patchesforupdate(6,:) = patches(numofpatches - 1,:);
        labelforupdate(6) = -1;

        patchesforupdate(7,:) = parameter.patch;
        labelforupdate(7) = 1;

        patchesforupdate(8,:) = patches(numofpatches ,:);
        labelforupdate(8) = -1;
        updatesparserealboost(sumimagedata, patchesforupdate, labelforupdate, importance);

    end
    flag = 1;
    confidence = [];
    for imgno = parameter.imgstart+1:parameter.imgend
        t_selectors = [t_selectors; selectors];
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
        confidencemap = detection(sumimagedata, patches); 
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
        patches = generatepatches(parameter.patch, parameter.searchfactor, parameter.overlap);
        numofpatches = size(patches, 1);

        importance = ones(8,1);

        patchesforupdate(1,:) = parameter.patch;
        labelforupdate(1) = 1;

        patchesforupdate(2,:) = patches(numofpatches - 3,:);
        labelforupdate(2) = -1;

        patchesforupdate(3,:) = parameter.patch;
        labelforupdate(3) = 1;

        patchesforupdate(4,:) = patches(numofpatches - 2,:);
        labelforupdate(4) = -1;

        patchesforupdate(5,:) = parameter.patch;
        labelforupdate(5) = 1;

        patchesforupdate(6,:) = patches(numofpatches - 1,:);
        labelforupdate(6) = -1;

        patchesforupdate(7,:) = parameter.patch;
        labelforupdate(7) = 1;

        patchesforupdate(8,:) = patches(numofpatches ,:);
        labelforupdate(8) = -1;
        updatesparserealboost(sumimagedata, patchesforupdate, labelforupdate, importance);
    end
 %   onspboost_faceocc_gt = objectlocation;
 %   onspboost_faceocc_confidence = confidence;
 %   save onspboost_faceocc_gt.mat onspboost_faceocc_gt;
 %   save onspboost_faceocc_confidence.mat onspboost_faceocc_confidence;
end