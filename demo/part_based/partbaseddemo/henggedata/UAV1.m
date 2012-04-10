% program is programming by chenyuefeng on 2012-03-06
% demo main function
% part based model
% top , bottom, left , right
%

clear;
clear global parameter;

global parameter;


parameter.numselectors = 10;
parameter.overlap = 0.99;
parameter.searchfactor = 2;
parameter.minfactor = 0.001;
parameter.patch = [104, 111, 39, 36];
parameter.iterationinit = 0;
parameter.numweakclassifiers = parameter.numselectors * 10;
parameter.minarea = 9;
parameter.imagewidth = 320;
parameter.imageheight = 240;
parameter.imdirformat = './/data//UAV1//imgs//img%05d.jpg';

parameter.imgstart = 0;
parameter.imgend = 439;


parameter.saveresult = false;
parameter.boost = false;
parameter.spboost = true;


% random part 
% 2012-04-06
parameter.randompart = false;
parameter.partnumber = 5;
parameter.sizefixed = true;
parameter.fixedwidth = floor(parameter.patch(3) / 2);
parameter.fixedheight = floor(parameter.patch(4) / 2);

%%%%%%%%%%
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
    parameter.imsavedir = './/data//UAV1//partbasedboost//img%05d.jpg';
    [boostloc, boostconf, boost_selectors, strongclassifier, selectors, alpha] = ...
        boosting(strongclassifier, sumimagedata, patches);
    if parameter.saveresult
        figure;generatepatches
        saveresult(strongclassifier, boostloc, boost_selectors);
    end
end

% ======== sp boost
figure;

if parameter.spboost
    sstrongclassifier = sp_sstrongclassifier;
    parameter = sp_parameter;
    parameter.imsavedir = './/data//UAV1//partbasedspboost//img%05d.jpg';
    [spboostloc, spboostconf, sstrongclassifier] = ...
         partbased_sparseboosting(sstrongclassifier, sumimagedata, patches);
    if parameter.saveresult
        figure;
        saveresult(strongclassifier, spboostloc, []);
    end
end
