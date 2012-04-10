function   haarfeature = generaterandomfeaturesptial(featurenum, patchsize, min_area)
    % haarfeature block_width, block_height, x0, y0, colsinblock, rowsinblock,
    % blockweight, mean, sigma
    global parameter;
    index = 1;
    haarfeature.area = [];
    haarfeature.type = [];
    haarfeature.location = [];
    haarfeature.weight = [];
    haarfeature.index = [];   
    haarfeature.posgaussian = [];
    haarfeature.neggaussian = [];
    
    patchsizeheight = patchsize(4);
    patchsizewidth = patchsize(3);
    for i = 1:featurenum
        vaild = false;
        while vaild ~= true
            % modify now
            y0 = randi(floor(patchsizeheight)) - 1 ;
            x0 = randi(floor(patchsizewidth)) - 1;
            y1 = randi(floor(patchsizeheight)) - 1 ;
            x1 = randi(floor(patchsizewidth)) - 1;
            %colsinblock = floor((1 - sqrt(1 - rand())) * patchsizewidth);
            %rowsinblock = floor((1 - sqrt(1 - rand())) * patchsizeheight);
            colsinblock = floor(rand() * patchsizewidth / 5);
            rowsinblock = floor(rand() * patchsizeheight / 5);
           
           
            if x0 +  colsinblock >= patchsizewidth | y0 + rowsinblock >= patchsizeheight | ...
               x1 +  colsinblock >= patchsizewidth | y1 + rowsinblock >= patchsizeheight   
                continue;
            end
            if  colsinblock * rowsinblock < min_area
                continue;
            end
            location = [x0,  y0, colsinblock, rowsinblock; 
                        x1,  y1, colsinblock, rowsinblock];
   

            area = 2;
            mean = 0;
            sigma = sqrt(256 * 256 * area / 12);
            type = 1;
            %location = [x0,  y0,               colsinblock, rowsinblock; 
            %            x0,  y0 + rowsinblock, colsinblock, rowsinblock];
            weight =  [1 -1]'./(location(:,3).* location(:,4));
            haarfeature.area = [haarfeature.area; area];
            haarfeature.type = [haarfeature.type ; type];
            haarfeature.location = [haarfeature.location ; location];
            haarfeature.weight = [haarfeature.weight; weight];
            haarfeature.index = [haarfeature.index; index];
            haarfeature.posgaussian = [haarfeature.posgaussian; [mean, sigma, 1000, 0.01, 1000, 0.01]];
            haarfeature.neggaussian = [haarfeature.neggaussian; [mean, sigma, 1000, 0.01, 1000, 0.01]];
            index = index +  area;
            vaild = true;
        
        end
    end
    % used to calculate the accmulated correct and wrong samples
    haarfeature.correct = ones(featurenum, 1);
    haarfeature.wrong = ones(featurenum, 1);
    haarfeature.weightvalue = zeros(size(haarfeature.area,1), 1);

end