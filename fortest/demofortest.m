% program is programming by chenyuefeng on 2012-03-06
% demo main function
clear;
clear global haarfeature;
clear global parameter;
clear global selectors;
clear global alpha;
load haarmat;
load imagedata;
global haarfeature;
global parameter;
global selectors;
global alpha;
parameter.numselectors = 20;
parameter.overlap = 0.99;
parameter.searchfactor = 2;
parameter.minfactor = 0.001;
parameter.patch = [129 86 97 130];
parameter.iterationinit = 50;
parameter.numweakclassifiers = parameter.numselectors * 10;
parameter.minarea = 9;
parameter.imagewidth = 352;
parameter.imageheight = 288;
parameter.imdirformat = '..\\faceocc\\imgs\\img%05d.png';
parameter.imgstart = 0;
parameter.imgend = 885;
%parameter.initializeiterations = 50;
% generate haar feature randomly and initilize the gaussian distribution 


imshow(imagedata);
sumimagedata = interimage(imagedata);
% initilize the posgaussian and neggaussian
for i = 1:parameter.numselectors
    generaterandomfeaturebymat(i,250, haarmat(1+250*(i-1):250*i,:));
end
% generate the patches in the search region
%patches = generatepatches(parameter.patch, parameter.searchfactor, parameter.overlap);
% first initilize the weakclassifiers

%numofpatches = size(patches, 1);
tic
for  i = 1:parameter.iterationinit
   
    updatestrongclassifier(sumimagedata, [80 21 97 130], -1, 1.0);
    updatestrongclassifier(sumimagedata, parameter.patch, 1, 1.0);
    updatestrongclassifier(sumimagedata, [177 21 97 130], -1, 1.0);
    updatestrongclassifier(sumimagedata, parameter.patch, 1, 1.0);
    updatestrongclassifier(sumimagedata, [80 151 97 130], -1, 1.0);
    updatestrongclassifier(sumimagedata, parameter.patch, 1, 1.0);
    updatestrongclassifier(sumimagedata, [177 151 97 130], -1, 1.0);
    updatestrongclassifier(sumimagedata, parameter.patch, 1, 1.0);
end
toc
load imagedatafordetection
patches = generatepatches(parameter.patch, parameter.searchfactor, parameter.overlap);
for imgno = parameter.imgstart+1:parameter.imgend
   % I = imread(num2str(imgno, parameter.imdirformat));
    subplot(1, 2, 1);
    imshow(imagedatafordetection);
    sumimagedata = interimage(imagedatafordetection);
    subplot(1, 2, 2);
    confidencemap = detection(sumimagedata, patches); 
    g = fspecial('gaussian', [3 ,3]);
    confidencemap = imfilter(confidencemap, g);
    imshow(confidencemap);
    [maxx, yind] = max(confidencemap, [], 1);
    [maxv, xind] = max(maxx);
    targetpatch = [xind, yind(xind)];
end
