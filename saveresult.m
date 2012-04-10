function saveresult(strongclassifier, objectlocation, t_selectors)
    global parameter;
   
   

    fg = figure;
    
    
	
		
    e = 1;
    
    for i = parameter.imgstart:parameter.imgend
        I = imread(num2str(i, parameter.imdirformat));
        
        
        imshow(I);
        rectangle('Position',objectlocation(e,:), 'edgecolor', 'g');
        if(size(t_selectors, 1) ~= 0 )
            if i ~= parameter.imgstart
                selectornow = t_selectors(:, e - 1);
                for j = 1:length(selectornow)
                    index = strongclassifier(j).index(selectornow(j));
                    area = strongclassifier(j).area(selectornow(j));
                    type = strongclassifier(j).type(selectornow(j));
                    block = strongclassifier(j).location(index:index + area - 1, :);
                    % align x and y
                    block(:,1) = block(:,1) + objectlocation(e,1);
                    block(:,2) = block(:,2) + objectlocation(e,2);
                    for k = 1:area
                        rectangle('Position',block(k,:), 'edgecolor', 'r');
                        text(block(k,1) + block(k,3)/2, block(k,2) + block(k,4)/2, num2str(j));
                    end
                end
            end
        end
       
        
        savedir = num2str(i,parameter.imsavedir);
       
        e = e + 1;
        saveas(gcf, savedir, 'png');
    end
    
end