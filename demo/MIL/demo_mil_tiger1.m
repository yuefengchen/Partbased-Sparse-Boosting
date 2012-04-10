% program is programming by chenyuefeng on 2012-03-06
% demo main function

clear;
clear global parameter;
global parameter;
load tiger1_gt.mat;
parameter.numselectors = 50;
parameter.overlap = 0.99;
parameter.searchfactor = 2.0;
parameter.minfactor = 0.001;
parameter.patch = tiger1_gt(1,:);
parameter.iterationinit = 0;
parameter.numweakclassifiers = parameter.numselectors * 20;
parameter.minarea = 9;
parameter.imagewidth = 320;
parameter.imageheight = 240;
parameter.imdirformat = './/data//tiger1//imgs//img%05d.png';

parameter.imgstart = 0;
parameter.imgend = 353;


% for MIL
parameter.mil_posradtrain = 4.0;
parameter.mil_negnumtrain = 65;
parameter.mil_initposradtrain = 3.0;
parameter.mil_wrchwinsz = 25;



objectlocation = parameter.patch;
%parameter.initializeiterations = 50;
% generate haar feature randomly and initilize the gaussian distribution 

I = imread(num2str(parameter.imgstart, parameter.imdirformat));
imshow(I);
sumimagedata = intimage(I);
% initilize the posgaussian and neggaussian

strongclassifier = struct('area', [] , ...
                              'type', [] , ...
                              'location', [] , ...
                              'weight', [] , ...
                              'index', [] , ...
                              'posgaussian', [] , ...
                              'neggaussian', [] , ...
                              'correct', [] , ...
                              'wrong', [] , ...
                              'weightvalue', []);
    
strongclassifier = generaterandomfeature(parameter.numweakclassifiers , parameter.patch , parameter.minarea);

%strongclassifier = init_strongclassifier(parameter.patch);

% for spboost
sp_strongclassifier = strongclassifier;
sp_parameter = parameter;


parameter.imsavedir = './/data//tiger1//milboost//img%05d.png';
[milboostloc, milboostconf, milboost_selectors, strongclassifier, selectors] = ...
     milboosting(strongclassifier, sumimagedata);
figure;
saveresult(strongclassifier, milboostloc, milboost_selectors);



figure; 
milboosterror = calerror(milboostloc, tiger1_gt, 'b') ;

figure
plot(parameter.imgstart + 1: parameter.imgend, milboostconf, 'b');

mean(milboosterror)*5;
