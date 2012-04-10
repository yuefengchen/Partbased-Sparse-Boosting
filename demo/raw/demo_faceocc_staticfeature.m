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
parameter.imsavedir = './/data//faceocc//boost//img%05d.png';
parameter.imgstart = 0;
parameter.imgend = 885;
objectlocation = parameter.patch;
%parameter.initializeiterations = 50;
% generate haar feature randomly and initilize the gaussian distribution 
t_selectors = [];

I = imread(num2str(parameter.imgstart, parameter.imdirformat));
imshow(I);
sumimagedata = intimage(I);

% initilize the posgaussian and neggaussian
for i = 1:parameter.numselectors
    generaterandomfeaturebymat(i,parameter.numweakclassifiers, ...
        haarmat(1+parameter.numweakclassifiers*(i-1):parameter.numweakclassifiers*i,:));
end

% initilize the posgaussian and neggaussian
%init_strongclassifier(parameter.patch);
% generate the patches in the search region
patches = generatepatches(parameter.patch, parameter.searchfactor, parameter.overlap);
% first initilize the weakclassifiers
selectors = zeros(parameter.numselectors, 1);
alpha = zeros(parameter.numselectors, 1);
numofpatches = size(patches, 1);


for  i = 1:50
    
    updatenopossion(sumimagedata, parameter.patch, 1, 1.0);
    updatenopossion(sumimagedata, patches(numofpatches - 3,:), -1, 1.0);
    updatenopossion(sumimagedata, parameter.patch, 1, 1.0);
    updatenopossion(sumimagedata, patches(numofpatches - 2,:), -1, 1.0);
    updatenopossion(sumimagedata, parameter.patch, 1, 1.0);
    updatenopossion(sumimagedata, patches(numofpatches - 1,:), -1, 1.0);
    updatenopossion(sumimagedata, parameter.patch, 1, 1.0);
    updatenopossion(sumimagedata, patches(numofpatches,:),  -1, 1.0);
   
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
    parameter.patch = [xind yind(xind) parameter.patch(3), parameter.patch(4)];
    imshow(I);
    rectangle('Position',parameter.patch, 'edgecolor', 'g');
    text( xind + parameter.patch(3)/2, yind(xind)+ parameter.patch(4)/2, num2str(max(max(confidencemap)), '%6f'));
    objectlocation = [objectlocation;parameter.patch];
    confidence = [confidence ; max(max(confidencemap))];
    
    
    % generate patches
    patches = generatepatches(parameter.patch, parameter.searchfactor, parameter.overlap);
    numofpatches = size(patches, 1);
    
    updatenopossion(sumimagedata, parameter.patch, 1, 1.0);
    updatenopossion(sumimagedata, patches(numofpatches - 3,:), -1, 1.0);
    updatenopossion(sumimagedata, parameter.patch, 1, 1.0);
    updatenopossion(sumimagedata, patches(numofpatches - 2,:), -1, 1.0);
    updatenopossion(sumimagedata, parameter.patch, 1, 1.0);
    updatenopossion(sumimagedata, patches(numofpatches - 1,:), -1, 1.0);
    updatenopossion(sumimagedata, parameter.patch, 1, 1.0);
    updatenopossion(sumimagedata, patches(numofpatches,:),     -1, 1.0);
    
    %{
    updatestrongclassifier(sumimagedata, parameter.patch, 1, 1.0);
    updatestrongclassifier(sumimagedata, patches(numofpatches - 3,:), -1, 1.0);
    updatestrongclassifier(sumimagedata, parameter.patch, 1, 1.0);
    updatestrongclassifier(sumimagedata, patches(numofpatches - 2,:), -1, 1.0);
    updatestrongclassifier(sumimagedata, parameter.patch, 1, 1.0);
    updatestrongclassifier(sumimagedata, patches(numofpatches - 1,:), -1, 1.0);
    updatestrongclassifier(sumimagedata, parameter.patch, 1, 1.0);
    updatestrongclassifier(sumimagedata, patches(numofpatches,:),  -1, 1.0);
    %}
    
    selector_perframe = [selector_perframe, selectors];
    pause(0.00040);
end
onlboost_faceoc = objectlocation;
onlboost_faceoc_confidence = confidence;
figure;
calerror(onlboost_faceoc, faceocc_gt, 'r');
figure;
plot(1:length(onlboost_faceoc_confidence), onlboost_faceoc_confidence, 'b')

saveresult(objectlocation, t_selectors);
