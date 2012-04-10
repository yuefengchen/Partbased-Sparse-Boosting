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
load faceocc_gt;
parameter.numselectors = 10;
parameter.overlap = 0.99;
parameter.searchfactor = 2;
parameter.minfactor = 0.001;
parameter.patch = faceocc_gt(1,:);
parameter.iterationinit = 0;
parameter.numweakclassifiers = parameter.numselectors * 40;
parameter.minarea = 9;
parameter.imagewidth = 352;
parameter.imageheight = 288;
parameter.imdirformat = './/faceocc//imgs//img%05d.png';
parameter.imgstart = 0;
parameter.imgend = 885;
objectlocation = parameter.patch;
%parameter.initializeiterations = 50;
% generate haar feature randomly and initilize the gaussian distribution 

I = imread(num2str(parameter.imgstart, parameter.imdirformat));
imshow(I);
sumimagedata = interimagebymatlab(I);
% initilize the posgaussian and neggaussian
init_strongclassifier(parameter.patch);
% generate the patches in the search region
patches = generatepatches(parameter.patch, parameter.searchfactor, parameter.overlap);
% first initilize the weakclassifiers
selectors = zeros(parameter.numselectors, 1);
alpha = zeros(parameter.numselectors, 1);
numofpatches = size(patches, 1);
maxdistance =sqrt(parameter.patch(3)^2 + parameter.patch(4)^2) / 2;
maxpossamplenum = 4;
pmindis = 5;

maxnegsamplenum = 4;
nmindis = maxdistance / 2;
nmaxdis = maxdistance;


for  i = 1:50
    i
    [patchesforupdate, labelforupdate] = generatesample(patches(1:numofpatches - 4, :), ... 
        pmindis, maxpossamplenum, nmindis, nmaxdis, maxnegsamplenum);
    importance = ones(size(patchesforupdate , 1),1);
    updatesparse(sumimagedata, patchesforupdate, labelforupdate, importance);
   
    
   
end
flag = 1;
confidence = [];
for imgno = parameter.imgstart+1:parameter.imgend
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
    
    [patchesforupdate, labelforupdate] = generatesample(patches(1:numofpatches - 4, :), ... 
        pmindis, maxpossamplenum, nmindis, nmaxdis, maxnegsamplenum);
    importance = ones(size(patchesforupdate , 1),1);
    
    
    updatesparse(sumimagedata, patchesforupdate, labelforupdate, importance);
    
    if mod(imgno, 100) == 0
        %pause;
    end
end
