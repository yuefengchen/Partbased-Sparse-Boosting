% program is programming by chenyuefeng on 2012-03-06
% demo main function
clear;
clear global haarfeature;
clear global parameter;
clear global selectors;
clear global alpha;
global haarfeature;
global parameter;
global selectors;
global alpha;
load faceocc_gt.mat;
load haarmat.mat;

parameter.numselectors = 10;
parameter.overlap = 0.99;
parameter.searchfactor = 2;
parameter.minfactor = 0.001;
parameter.patch = faceocc_gt(1,:);
parameter.iterationinit = 0;
parameter.numweakclassifiers = parameter.numselectors * 10;
parameter.minarea = 9;
parameter.imagewidth = 352;
parameter.imageheight = 288;
parameter.imdirformat = './/data//faceocc//imgs//img%05d.png';
parameter.imsavedir = './/data//faceocc//spboost//img%05d.png';
parameter.imgstart = 0;
parameter.imgend = 885;
objectlocation = parameter.patch;
%parameter.initializeiterations = 50;
% generate haar feature randomly and initilize the gaussian distribution 

I = imread(num2str(parameter.imgstart, parameter.imdirformat));
imshow(I);
sumimagedata = interimagebymatlab(I);
% initilize the posgaussian and neggaussian
for i = 1:parameter.numselectors
    generaterandomfeaturebymat(i,parameter.numweakclassifiers, ...
        haarmat(1+parameter.numweakclassifiers*(i-1):parameter.numweakclassifiers*i,:));
end
% generate the patches in the search region
patches = generatepatches(parameter.patch, parameter.searchfactor, parameter.overlap);
% first initilize the weakclassifiers
selectors = zeros(parameter.numselectors, 1);
alpha = zeros(parameter.numselectors, 1);
numofpatches = size(patches, 1);

patchesforupdate = zeros(8, 4);
labelforupdate = zeros(8, 1);

t_selectors = [];

mostselected = zeros(parameter.numselectors/2, 2);
cumulateselected = zeros(parameter.numselectors, 2);
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
    updatesparse(sumimagedata, patchesforupdate, labelforupdate, importance);
   
    
   
end
flag = 1;
confidence = [];
selector_perframe = selectors;

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
    
    
    updatesparse(sumimagedata, patchesforupdate, labelforupdate, importance);
    %{
    if size(t_selectors , 2) >= 50
        
        for selno = 1:parameter.numselectors
            curselect = t_selectors(selno,size(t_selectors, 2) - 49 : size(t_selectors, 2));
            uniqueselectid = unique(curselect);
            count = histc(curselect, uniqueselectid);
            [maxv, ind] = max(count);
            cumulateselected(selno,:) = [uniqueselectid(ind), maxv];
        end
        [sorted , index] = sort(cumulateselected(:, 2), 'descend');
        cumulateselected = cumulateselected(index,:);
        mostselected = [index(1:size(mostselected, 1)), cumulateselected(1:size(mostselected, 1), 1)];
        semiupdatesparse(sumimagedata, patchesforupdate, labelforupdate, importance, mostselected);
    else
        updatesparse(sumimagedata, patchesforupdate, labelforupdate, importance);
    end
    %}
    %pause;
end
figure;
calerror(objectlocation, faceocc_gt, 'r');
figure;
plot(1:length(confidence), confidence, 'b')
saveresult(objectlocation, t_selectors);
