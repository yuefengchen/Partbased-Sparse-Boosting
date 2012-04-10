function show( objectlocation)
    global parameter;
    e = 1;
    for imgno = parameter.imgstart:parameter.imgend
            I = imread(num2str(imgno, parameter.imdirformat));
            subplot(1, 2, 1);
            imshow(I);
            % sumimagedata = interimage(I);
            subplot(1, 2, 2);

            imshow(I);
            rectangle('Position',  objectlocation(e,:) ,'edgecolor', 'g');
         %   objectlocation = [objectlocation; parameter.patch];
         
             e = e + 1;
             pause;
     end

        % generate patches
   
    
end