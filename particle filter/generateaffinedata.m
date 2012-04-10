function affinesumdata = generateaffinedata(rawimage, patch, affinep)
    [imgheight, imgwidth] = size(rawimage);
    numofaffinesample = size(affinep, 2);
    [x, y] = meshgrid(patch(1):patch(1) + patch(3) - 1, patch(2):patch(2) + patch(4) - 1);
    x = reshape(x, [size(x,1) * size(x,2) 1]);
    y = reshape(y, [size(y,1) * size(y,2) 1]);
    location = [x' ; y'; ones(1, length(x))];
    affinesumdata = zeros(patch(4) + 1, patch(3) + 1, size(affinep, 2));
    for i = 1:numofaffinesample
        affine_matrix = generateaffinematrix(affinep(:,i));
        locationafteraffine = inv(affine_matrix) * location;
        locationafteraffine(1,:) = floor(locationafteraffine(1,:) + 0.5);
        locationafteraffine(2,:) = floor(locationafteraffine(2,:) + 0.5);

        totalpixel = 1:size(locationafteraffine, 2);
        errpixel = find(locationafteraffine(1,:) > imgwidth | locationafteraffine(2,:) > imgheight | ...
                        locationafteraffine(1,:) < 1 | locationafteraffine(2,:) < 1);
        
        totalpixel(errpixel) = [];
        
        data = floor(mean(mean(rawimage(patch(2):patch(2) + patch(4) - 1, patch(1):patch(1) + patch(3) - 1))))*ones(patch(4), patch(3));
        indexinrawimage = sub2ind(size(rawimage), locationafteraffine(2,totalpixel), locationafteraffine(1,totalpixel));
        data(totalpixel) = rawimage(indexinrawimage);
        affinesumdata(:,:, i) = intimage(uint8(data));
    end
end