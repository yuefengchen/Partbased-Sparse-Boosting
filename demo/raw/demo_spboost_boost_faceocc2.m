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
load faceocc2_gt.mat;
parameter.numselectors = 20;
parameter.overlap = 0.99;
parameter.searchfactor = 1.3;
parameter.minfactor = 0.001;
parameter.patch = faceocc2_gt(1,:);
parameter.iterationinit = 0;
parameter.numweakclassifiers = parameter.numselectors * 10;
parameter.minarea = 9;
parameter.imagewidth = 320;
parameter.imageheight = 240;
parameter.imdirformat = './/data//faceocc2//imgs//img%05d.png';
parameter.imsavedir = './/data//faceocc2//boost//img%05d.png';
parameter.imgstart = 2;
parameter.imgend = 819;
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


haarfeature_copy = haarfeature;
parameter_copy = parameter;
selectors_copy = selectors;
alpha_copy = alpha;
[boostloc, boostconf, boost_selectors] = boosting(sumimagedata, patches);
figure;
saveresult(boostloc, boost_selectors);

haarfeature = haarfeature_copy;
parameter = parameter_copy;
selctors = selectors_copy;
alpha = alpha_copy;

figure;
parameter.imsavedir = './/data//faceocc2//spboost//img%05d.png';
[spboostloc, spboostconf, spboost_selectors] = sparseboosting(sumimagedata, patches);
figure;
saveresult(spboostloc, spboost_selectors);
%haarfeature = haarfeature_copy;
%parameter = parameter_copy;
%selctors = selectors_copy;
%alpha = alpha_copy;


%[sprealboostloc, sprealboostconf, t_selectors] = sparserealboosting(sumimagedata, patches);

figure; 
boosterror = calerror(boostloc, faceocc2_gt, 'b') ;
hold on
spboosterror = calerror(spboostloc, faceocc2_gt, 'r');


%hold on
%sprealboosterror = calerror(sprealboostloc, david_gt, 'g');
mean(boosterror)*5
mean(spboosterror)*5
%mean(sprealboosterror)*5