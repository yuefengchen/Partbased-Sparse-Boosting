% program is programming by chenyuefeng on 2012-03-06
% demo main function

clear;
clear global parameter;
global parameter;
load faceocc_gt.mat;
groundth_gt = faceocc_gt;
parameter.numselectors = 10;
parameter.overlap = 0.99;
parameter.searchfactor = 2;
parameter.minfactor = 0.001;
parameter.patch = groundth_gt(1,:);
parameter.iterationinit = 0;
parameter.numweakclassifiers = parameter.numselectors * 10;
parameter.minarea = 9;
parameter.imagewidth = 352;
parameter.imageheight = 288;
parameter.imdirformat = './/data//faceocc//imgs//img%05d.png';

parameter.imgstart = 0;
parameter.imgend = 885;

parameter.saveresult = false;
parameter.boost = false;
parameter.spboost = true;
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
if parameter.boost
    parameter.imsavedir = './/data//faceocc//boost//img%05d.png';
    [boostloc, boostconf, boost_selectors, strongclassifier, selectors, alpha] = ...
         boosting(strongclassifier, sumimagedata, patches);

    if parameter.saveresult
        figure;
        saveresult(strongclassifier, boostloc, boost_selectors);
    end
end

% ======== sp boost
figure;

if parameter.spboost
    strongclassifier = sp_strongclassifier;
    parameter = sp_parameter;
    parameter.imsavedir = './/data//faceocc//spboost//img%05d.png';
    [spboostloc, spboostconf, spboost_selectors, strongclassifier, selectors, alpha] = ...
         sparseboosting(strongclassifier, sumimagedata, patches);
    if parameter.saveresult
        figure;
        saveresult(strongclassifier, spboostloc, spboost_selectors);
    end
end

figure; 
if parameter.boost
    boosterror = calerror(boostloc, groundth_gt, 'b') ;
end
hold on
if parameter.spboost
    spboosterror = calerror(spboostloc, groundth_gt, 'r');
end


figure
if parameter.boost
    plot(parameter.imgstart + 1: parameter.imgend, boostconf, 'b');
end

hold on
if parameter.spboost
    plot(parameter.imgstart + 1: parameter.imgend, spboostconf, 'r');
end
if parameter.boost
    mean(boosterror)*5
end
if parameter.spboost
    mean(spboosterror)*5
end