function weightvalue = haarfeatureeval(haarfeature, sumimagedata, patch)
    x_offset = patch(1);
    y_offset = patch(2);
    location = haarfeature.location;
    location(:,1) = location(:,1) + x_offset ;
    location(:,2) = location(:,2) + y_offset ;
  %  errrow = find(location(:,2) + location(:,4) > size(sumimagedata, 1));
  %   errcol = find(location(:,1) + location(:,3) > size(sumimagedata, 2));
  %   if(length(errrow) ~= 0 | length(errcol) ~= 0 )
  %       disp('error')
  %       save error.mat;
  %  end
   
    topleft  = sub2ind(size(sumimagedata), location(:,2), location(:,1));
    botright = sub2ind(size(sumimagedata), location(:,2) + location(:,4), location(:, 1) + location(:, 3));
    topright = sub2ind(size(sumimagedata), location(:,2), location(:,1) + location(:,3));
    botleft  = sub2ind(size(sumimagedata), location(:,2) + location(:,4), location(:,1));
    
    
    
    
        
    haarfeature.sumblock = sumimagedata(topleft) + sumimagedata(botright) - sumimagedata(topright) - sumimagedata(botleft);
    numofhaarfeatures = length(haarfeature.area);
    
    weightvalue = [];
    haarfeature.weightvalue = [];
    for i = 1:numofhaarfeatures
        indexid = haarfeature.index(i):haarfeature.index(i) + haarfeature.area(i) - 1;
        % haarfeature.weightvalue = [ haarfeature.weightvalue;sum(haarfeature.sumblock(indexid).* ...
        %    haarfeature.weight(indexid))];
        weightvalue = [weightvalue; sum(haarfeature.sumblock(indexid).* haarfeature.weight(indexid))];
    end
   % haarfeature.weightvalue = haarfeature.weightvalue;
end