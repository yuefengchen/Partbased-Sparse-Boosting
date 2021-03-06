% program is programming by chenyuefeng on 2012-03-06
% demo main function
% part based model
% top , bottom, left , right
%

clear;
clear global parameter;

global parameter;

load girl_gt.mat;
groundth_gt = girl_gt;
parameter.numselectors = 20;
parameter.overlap = 0.99;
parameter.searchfactor = 2;
parameter.minfactor = 0.001;
parameter.patch = groundth_gt(1,:);
parameter.iterationinit = 0;
parameter.numweakclassifiers = parameter.numselectors * 10;
parameter.minarea = 9;
parameter.imagewidth = 320;
parameter.imageheight = 240;
parameter.imdirformat = './/data//girl//imgs//img%05d.png';

parameter.imgstart = 0;
parameter.imgend = 501;


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
% strongclassifier(1) total   block
% strongclassifier(2) top     block
% strongclassifier(3) bottom  block
% strongclassifier(4) left    block
% strongclassifier(5) right   block

sstrongclassifier = struct('total_strongclassifier', struct, ...
                           'total_selectors', [], ...
                           'total_alpha', [],...
                           'top_strongclassifier', struct, ... 
                           'top_selectors', [], ...
                           'top_alpha', [],...
                           'bottom_strongclassifier', struct, ...
                           'bottom_selectors', [], ...
                           'bottom_alpha', [], ...
                           'left_strongclassifier', struct, ...
                           'left_selectors', [], ...
                           'left_alpha', [],...
                           'right_strongclassifier', struct, ...
                           'right_selectors', [], ...
                           'right_alpha', []...
                           );
sstrongclassifier = partbased_init_strongclassifier(parameter.patch);
sp_sstrongclassifier = sstrongclassifier;
sp_parameter = parameter;

% generate the patches in the search region
patches = generatepatches(parameter.patch, parameter.searchfactor, parameter.overlap);
% first initilize the weakclassifiers


%selectors_copy = selectors;
%alpha_copy = alpha;
%[boostloc, boostconf, boost_selectors] = boosting(sumimagedata, patches);
%  ======= boost
%

if  parameter.boost
    parameter.imsavedir = './/data//girl//partbasedboost//img%05d.png';
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
    sstrongclassifier = sp_sstrongclassifier;
    parameter = sp_parameter;
    parameter.imsavedir = './/data//girl//partbasedspboost//img%05d.png';
    [spboostloc, spboostconf, sstrongclassifier] = ...
         partbased_sparseboosting(sstrongclassifier, sumimagedata, patches);
    if parameter.saveresult
        figure;
        saveresult(strongclassifier, spboostloc, []);
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