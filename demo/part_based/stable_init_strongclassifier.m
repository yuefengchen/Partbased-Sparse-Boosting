function sstrongclassifier = stable_init_strongclassifier(patch, rawimage)
    widthdiv2 = floor(patch(3)/2);
    heightdiv2 = floor(patch(4)/2);
    leftwidth = patch(3) - widthdiv2;
    leftheight = patch(4) - heightdiv2;
    
    sstrongclassifier.total_strongclassifier = init_stablestrongclassifier(patch, rawimage);
    
    %top and bottom
    sstrongclassifier.top_strongclassifier = init_stablestrongclassifier( [ patch(1), patch(2), patch(3), heightdiv2], rawimage);
    sstrongclassifier.bottom_strongclassifier = init_stablestrongclassifier( [ patch(1), ...
        patch(2) + patch(4) - leftheight , patch(3), leftheight ], rawimage);
    % left and right
    sstrongclassifier.left_strongclassifier = init_stablestrongclassifier( [ patch(1) , patch(2), widthdiv2, patch(4)], rawimage);
    sstrongclassifier.right_strongclassifier = init_stablestrongclassifier( [ patch(1) + patch(3) - leftwidth, ...
       patch(2), leftwidth, patch(4)] , rawimage);
end