function [objectlocation, confidence, sstrongclassifier] = partbased_sparseboosting(sstrongclassifier, sumimagedata, patches)
    
    global parameter;
    objectlocation = parameter.patch;
    numofpatches = size(patches, 1);
    patchesforupdate = zeros(8, 4);
    labelforupdate = zeros(8, 1);
   %t_selectors = [];
   
    confidence_total = [];
    confidence_top = [];
    confidence_bottom = [];
    confidence_left = [];
    confidence_right = [];
    
    for  i = 1:parameter.init_iteration
        
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
        
        sstrongclassifier = partbased_updatesparse(sstrongclassifier,  ... 
            sumimagedata, patchesforupdate, labelforupdate, importance);

    end
    flag = 1;
    confidence = [];
    
    for imgno = parameter.imgstart+1:parameter.imgend
       % t_selectors = [t_selectors, selectors];
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
        
       % if parameter.randompart
        sstrongclassifier = partbased_detection(sstrongclassifier , sumimagedata, patches); 
        [location, confidencenow ] = partbased_maxconfidence(sstrongclassifier);
        parameter.patch = location;
        imshow(I);

        % combined max area
        rectangle('Position',parameter.patch, 'edgecolor', 'g');
        text( parameter.patch(1) + parameter.patch(3)/2, parameter.patch(2)+ parameter.patch(4)/2, num2str(confidencenow, '%6f'));
        objectlocation = [objectlocation; parameter.patch];
        confidence = [confidence, confidencenow];
       % else
        %confidencemap = detectionbymatlab(sumimagedata, patches); 
        %total_strongclassifier
        %
          %{  
            confidencemap = partbased_detection(sstrongclassifier , sumimagedata, patches); 







            g = fspecial('gaussian', [3 ,3]);
            confidencemap.confidencemap_total  = imfilter(confidencemap.confidencemap_total, g);
            confidencemap.confidencemap_top    = imfilter(confidencemap.confidencemap_top, g);
            confidencemap.confidencemap_bottom = imfilter(confidencemap.confidencemap_bottom, g);
            confidencemap.confidencemap_left   = imfilter(confidencemap.confidencemap_left, g);
            confidencemap.confidencemap_right  = imfilter(confidencemap.confidencemap_right, g); 

            confidencemap_combined = 1 - (1 - confidencemap.confidencemap_total).* ...
                                         (1 - confidencemap.confidencemap_top).* ...
                                         (1 - confidencemap.confidencemap_bottom).* ...
                                         (1 - confidencemap.confidencemap_left).* ...
                                         (1 - confidencemap.confidencemap_right);
            confidencemap_combined = imfilter(confidencemap_combined, g);
            imshow(confidencemap_combined);
            % get the max patches

            [maxx, yind] = max(confidencemap_combined, [], 1);
            [maxv, xind] = max(maxx);
            parameter.patch = [xind yind(xind) parameter.patch(3) parameter.patch(4)];
            imshow(I);

            % combined max area
            rectangle('Position',parameter.patch, 'edgecolor', 'g');
            text( xind + parameter.patch(3)/2, yind(xind)+ parameter.patch(4)/2, num2str(max(max(confidencemap_combined)), '%6f'));
            objectlocation = [objectlocation;parameter.patch];

            % total max area
            [maxx, yind] = max(confidencemap.confidencemap_total, [], 1);
            [maxv, xind] = max(maxx);
            total_location = [xind yind(xind) parameter.patch(3) parameter.patch(4)];
            rectangle('Position', total_location , 'edgecolor', 'b');

            % top max area
            [maxx, yind] = max(confidencemap.confidencemap_top, [], 1);
            [maxv, xind] = max(maxx);
            top_location = [xind yind(xind) parameter.patch(3) parameter.patch(4)];
            rectangle('Position', top_location , 'edgecolor', 'cyan');

            % bottom max area
            [maxx, yind] = max(confidencemap.confidencemap_bottom, [], 1);
            [maxv, xind] = max(maxx);
            bottom_location = [xind yind(xind) parameter.patch(3) parameter.patch(4)];
            rectangle('Position', bottom_location , 'edgecolor', 'magenta');


            % left max area
            [maxx, yind] = max(confidencemap.confidencemap_left, [], 1);
            [maxv, xind] = max(maxx);
            left_location = [xind yind(xind) parameter.patch(3) parameter.patch(4)];
            rectangle('Position', left_location , 'edgecolor', 'yellow');

            % right max area
            [maxx, yind] = max(confidencemap.confidencemap_right, [], 1);
            [maxv, xind] = max(maxx);
            right_location = [xind yind(xind) parameter.patch(3) parameter.patch(4)];
            rectangle('Position', right_location , 'edgecolor', 'black');

            confidence = [confidence ; max(max(confidencemap_combined))];
            confidence_total  =  [confidence_total; confidencemap.confidencemap_total(parameter.patch(2), parameter.patch(1))];
            confidence_top    =  [confidence_top; confidencemap.confidencemap_top(parameter.patch(2), parameter.patch(1))];
            confidence_bottom =  [confidence_bottom; confidencemap.confidencemap_bottom(parameter.patch(2), parameter.patch(1))];
            confidence_left   =  [confidence_left; confidencemap.confidencemap_left(parameter.patch(2), parameter.patch(1))];
            confidence_right  =  [confidence_right; confidencemap.confidencemap_right(parameter.patch(2), parameter.patch(1))];
        % generate patches
        end
        %}
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
        sstrongclassifier = partbased_updatesparse(sstrongclassifier, sumimagedata, patchesforupdate, labelforupdate, importance);
    end
 
end