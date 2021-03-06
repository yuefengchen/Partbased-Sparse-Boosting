% program is programming by chenyuefeng on 2012-03-06
% demo main function
clear;
clear global parameter;
global parameter;
load david_gt.mat;
parameter.numselectors = 20;
parameter.overlap = 0.99;
parameter.searchfactor = 1.3;
parameter.minfactor = 0.001;
parameter.patch = david_gt(1,:);
parameter.iterationinit = 0;
parameter.numweakclassifiers = parameter.numselectors * 10;
parameter.minarea = 9;
parameter.imagewidth = 320;
parameter.imageheight = 240;
parameter.imdirformat = './/data//david//imgs//img%05d.png';

parameter.imgstart = 1;
parameter.imgend = 462;
objectlocation = parameter.patch;
%parameter.initializeiterations = 50;
% generate haar feature randomly and initilize the gaussian distribution 

I = imread(num2str(parameter.imgstart, parameter.imdirformat));
imshow(I);
sumimagedata = intimage(I);
% initilize the posgaussian and neggaussian
strongclassifier = init_strongclassifier(parameter.patch);

% for spboost
sp_strongclassifier = strongclassifier;
sp_parameter = parameter;

% generate the patches in the search region
patches = generatepatches(parameter.patch, parameter.searchfactor, parameter.overlap);
% first initilize the weakclassifiers


%selectors_copy = selectors;
%alpha_copy = alpha;
%[boostloc, boostconf, boost_selectors] = boosting(sumimagedata, patches);
%  ======= boost
%

%parameter.imsavedir = './/data//david//boost//img%05d.png';
%[boostloc, boostconf, boost_selectors, strongclassifier, selectors, alpha] = ...
%     boosting(strongclassifier, sumimagedata, patches);
%figure;
%saveresult(strongclassifier, boostloc, boost_selectors);


% ======== sp boost
figure;

strongclassifier = sp_strongclassifier;
parameter = sp_parameter;
parameter.imsavedir = './/data//david//spboost//img%05d.png';
[spboostloc, spboostconf, spboost_selectors, strongclassifier, selectors, alpha] = ...
     sparseboosting(strongclassifier, sumimagedata, patches);
figure;
saveresult(strongclassifier, spboostloc, spboost_selectors);


figure; 
boosterror = calerror(boostloc, david_gt, 'b') ;
hold on
spboosterror = calerror(spboostloc, david_gt, 'r');

figure
plot(parameter.imgstart + 1: parameter.imgend, boostconf, 'b');
hold on
plot(parameter.imgstart + 1: parameter.imgend, spboostconf, 'r');

mean(boosterror)*5
mean(spboosterror)*5
