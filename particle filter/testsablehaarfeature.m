% test stable haarfeature selection
%
% program is programming by chenyuefeng on 2012-03-06
% demo main function
% part based model
% top , bottom, left , right
%

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

% stable selection haar feature
parameter.numofaffinesample = 100;
parameter.affineparameter.p =   [0, 0, 1, 1, 0, 0]';
parameter.affineparameter.std = [0.26, 0.01,  0.3, 0.3, 14, 14]';

objectlocation = parameter.patch;
%parameter.initializeiterations = 50;
% generate haar feature randomly and initilize the gaussian distribution 

I = imread(num2str(parameter.imgstart, parameter.imdirformat));
imshow(I);

strongclassifier = init_strongclassifier(parameter.patch);

strongclassifier(1) = stablehaarfeature(strongclassifier(1), I, parameter.patch, parameter.numofaffinesample, parameter.affineparameter)

