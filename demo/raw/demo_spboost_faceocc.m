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
parameter.imgstart = 0;
parameter.imgend = 885;
objectlocation = parameter.patch;
%parameter.initializeiterations = 50;
% generate haar feature randomly and initilize the gaussian distribution 

I = imread(num2str(parameter.imgstart, parameter.imdirformat));
imshow(I);
sumimagedata = intimage(I);
% initilize the posgaussian and neggaussian
init_strongclassifier(parameter.patch);
% generate the patches in the search region
patches = generatepatches(parameter.patch, parameter.searchfactor, parameter.overlap);
% first initilize the weakclassifiers
selectors = zeros(parameter.numselectors, 1);
alpha = zeros(parameter.numselectors, 1);
% spboost

[spboostloc, spboostconf] = sparseboosting(sumimagedata, patches);

figure; 
calerror(spboostloc, faceocc_gt, 'r');
