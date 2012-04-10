function   onehaarfeature = generateonefeature( patchsize, min_area)
    % haarfeature block_width, block_height, x0, y0, colsinblock, rowsinblock,
    % blockweight, mean, sigma
    index = 1;
    
    patchsizeheight = patchsize(2);
    patchsizewidth = patchsize(1);
   
    vaild = false;
    while vaild ~= true
        y0 = randi(floor(patchsizeheight));
        x0 = randi(floor(patchsizewidth));
        colsinblock = floor((1 - sqrt(1 - rand())) * patchsizewidth);
        rowsinblock = floor((1 - sqrt(1 - rand())) * patchsizeheight);
        %col = randi(patchsize(1));
        prob = rand();
        if prob <= 0.2
            %   1
            %  -1

            block_height = 2;
            block_width  = 1;
            if x0 + block_width * colsinblock >= patchsizewidth | y0 + block_height * rowsinblock >= patchsizeheight
                continue;
            end
            if block_width * block_height * colsinblock * rowsinblock < min_area
                continue;
            end

            area = 2;
            mean = 0;
            sigma = sqrt(256 * 256 * area / 12);
            type =1;
            location = [x0,  y0,               colsinblock, rowsinblock; 
                        x0,  y0 + rowsinblock, colsinblock, rowsinblock];
            weight =  [1 -1]'./(location(:,3).* location(:,4));
            
            onehaarfeature.area =  area;
            onehaarfeature.mean =  mean;
            onehaarfeature.sigma = sigma;
            onehaarfeature.type =  type;
            onehaarfeature.location =  location;
            onehaarfeature.weight = weight;
       
            vaild = true;

         %   return ;

        elseif prob <= 0.4
            %   1   -1
            block_height = 1;
            block_width  = 2 ;
            if x0 + block_width * colsinblock >= patchsizewidth | y0 + block_height * rowsinblock >= patchsizeheight
                continue;
            end
            if block_width * block_height * colsinblock * rowsinblock < min_area
                continue;
            end


            area = 2;
            mean = 0;
            sigma = sqrt(256 * 256 * area / 12);
            type = 2;
            location = [x0,                y0,  colsinblock, rowsinblock; 
                        x0 + colsinblock,  y0 , colsinblock, rowsinblock];
            weight = [1, -1]' ./(location(:,3).* location(:,4));
           
            onehaarfeature.area =  area;
            onehaarfeature.mean =  mean;
            onehaarfeature.sigma = sigma;
            onehaarfeature.type =  type;
            onehaarfeature.location =  location;
            onehaarfeature.weight = weight;
            vaild = true;

        elseif prob <= 0.6
            block_height = 4;
            block_width  = 1 ;
            if x0 + block_width * colsinblock >= patchsizewidth | y0 + block_height * rowsinblock >= patchsizeheight
                continue;
            end
            if block_width * block_height * colsinblock * rowsinblock < min_area
                continue;
            end

            area = 3;
            mean = 0;
            sigma = sqrt(256 * 256 * area / 12);
            type = 3;
            location = [ x0,  y0,                 colsinblock,  rowsinblock; 
                         x0,  y0 + rowsinblock,   colsinblock,  2*rowsinblock;
                         x0,  y0 + 3*rowsinblock, colsinblock,  rowsinblock];
            weight = [1 -2, 1]' ./(location(:,3).* location(:,4));
            
            onehaarfeature.area =  area;
            onehaarfeature.mean =  mean;
            onehaarfeature.sigma = sigma;
            onehaarfeature.type =  type;
            onehaarfeature.location =  location;
            onehaarfeature.weight = weight;
           
            vaild = true;

        elseif prob <= 0.8
            block_height = 1;
            block_width  = 4 ;
            if x0 + block_width * colsinblock >= patchsizewidth | y0 + block_height * rowsinblock >= patchsizeheight
                continue;
            end
            if block_width * block_height * colsinblock * rowsinblock < min_area
                continue;
            end


            area = 3;
            mean = 0;
            sigma = sqrt(256 * 256 * area / 12);
            type = 4;
            location = [ x0,                 y0,  colsinblock,   rowsinblock; 
                         x0 + colsinblock,   y0,  2*colsinblock, rowsinblock;
                         x0 + 3*colsinblock, y0,  colsinblock,   rowsinblock];
            weight = [1,  -2,  1]' ./(location(:,3).* location(:,4));
            onehaarfeature.area =  area;
            onehaarfeature.mean =  mean;
            onehaarfeature.sigma = sigma;
            onehaarfeature.type =  type;
            onehaarfeature.location =  location;
            onehaarfeature.weight = weight;
            vaild = true;
        else
            block_height = 2;
            block_width  = 2 ;
            if x0 + block_width * colsinblock >= patchsizewidth | y0 + block_height * rowsinblock >= patchsizeheight
                continue;
            end
            if block_width * block_height * colsinblock * rowsinblock < min_area
                continue;
            end

            area = 4;
            mean = 0;
            sigma = sqrt(256 * 256 * area / 12);
            type =5;
            location = [ x0,                 y0,               colsinblock, rowsinblock; 
                         x0 + colsinblock,   y0,               colsinblock, rowsinblock;
                         x0,                 y0 + rowsinblock, colsinblock, rowsinblock;
                         x0 + colsinblock,   y0 + rowsinblock, colsinblock, rowsinblock];
            weight = [1,  -1, -1,  1]' ./(location(:,3).* location(:,4));
            onehaarfeature.area =  area;
            onehaarfeature.mean =  mean;
            onehaarfeature.sigma = sigma;
            onehaarfeature.type =  type;
            onehaarfeature.location =  location;
            onehaarfeature.weight = weight;
            vaild = true;
        end
    end
    onehaarfeature.correct = 1;
    onehaarfeature.wrong = 1;
end