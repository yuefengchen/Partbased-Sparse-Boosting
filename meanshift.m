function objregion = meanshift(init_region, confidencemap , imw, imh)
   
    x = init_region(1);
    y = init_region(2);
    width = init_region(3);
    height = init_region(4);
    
    X = repmat(1:imw, imh, 1);
    Y = repmat([1:imh]', 1, imw);
    while 1
      %  idy = centery - starty + 1;
      %  idx = centerx - startx + 1;
      %  X = repmat((centerx - width/2):(centerx + width/2), height, 1);
      %  Y = repmat([(centery - height/2):(centery + height/2)]', 1, width);
        M00 = sum(sum(confidencemap(y:y+height - 1, x:x+width -1)));
        M10 = sum(sum(Y(y:y+height - 1, x:x+width -1).*confidencemap(y:y+height - 1, x:x+width -1)));
        M01 = sum(sum(X(y:y+height - 1, x:x+width -1).*confidencemap(y:y+height - 1, x:x+width -1)));
        cury = M10/M00;
        curx = M01/M00;
        if( (y - cury)^2 + (x - curx)^2 < 1) 
            objregion = [floor(curx), floor(cury), width, height];
            return;
        end
        y = cury;
        x = curx;
    end
end