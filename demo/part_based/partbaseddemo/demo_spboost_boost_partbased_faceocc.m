% program is programming by chenyuefeng on 2012-03-06
% demo main function
% part based model
% top , bottom, left , right
%

clear;
close all;
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
parameter.boost = true;
parameter.spboost = true;

%% partbased


%% random part 
% 2012-04-06
parameter.partbased = true;
parameter.randompart = false;
parameter.partnumber = 5;
parameter.sizefixed = true;
parameter.fixedwidth = floor(parameter.patch(3) / 2);
parameter.fixedheight = floor(parameter.patch(4) / 2);

%% edgebased haar feature
parameter.edgefeature = false;
parameter.edgethreshold = 0.7;

%% overlap
parameter.overlapconstrain = 0.5;

%% weak classifier feature size
parameter.haar_size = 5;

%% initeration 
parameter.init_iteration = 50;

objectlocation = parameter.patch;

% generate haar feature randomly and initilize the gaussian distribution 

I = imread(num2str(parameter.imgstart, parameter.imdirformat));
imshow(I);
sumimagedata = intimage(I);

%% initilize the posgaussian and neggaussian
% strongclassifier(1) total   block
% strongclassifier(2) top     block
% strongclassifier(3) bottom  block
% strongclassifier(4) left    block
% strongclassifier(5) right   block


sstrongclassifier = partbased_init_strongclassifier(I, parameter.patch);


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
    parameter.imsavedir = './/data//faceocc//boost//img%05d.png';
    %[boostloc, boostconf, boost_selectors, strongclassifier, selectors, alpha] = ...
    %    boosting(strongclassifier, sumimagedata, patches);
    [boostloc, boostconf, sstrongclassifier] = ...
         partbased_rawboosting(sstrongclassifier, sumimagedata, patches);
    if parameter.saveresult
        figure;
        saveresult(strongclassifier, boostloc, boost_selectors);
    end
end

%% assigne parameter
sstrongclassifier = sp_sstrongclassifier;
parameter = sp_parameter;

%% generate the patches in the search region
patches = generatepatches(parameter.patch, parameter.searchfactor, parameter.overlap);

%% ======== sp boost

figure;

if parameter.spboost
    sstrongclassifier = sp_sstrongclassifier;
    parameter = sp_parameter;
    parameter.imsavedir = './/data//faceocc//partbasedspboost//img%05d.png';

    [spboostloc, spboostconf, sstrongclassifier] = ...
         partbased_sparseboosting(sstrongclassifier, sumimagedata, patches);
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