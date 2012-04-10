function int_img = interimagebymatlab(imagedata)
    imagedata = double(imagedata);
    [height, width] = size(imagedata);
    int_img = zeros(height + 1, width + 1);
    for i = 2:height+1
        cur_sum = 0;
        for j = 2:width+1
            cur_sum = cur_sum + imagedata(i-1,j-1);
            int_img(i,j) = int_img(i - 1, j) + cur_sum;
        end
    end
end