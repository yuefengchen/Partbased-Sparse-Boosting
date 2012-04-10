function sstrongclassifier = partbased_updatesparse(sstrongclassifier, sumimagedata, patchesforupdate, labelforupdate, importance)
    global parameter;
    widthdiv2 = floor(patchesforupdate(:, 3)/2);
    heightdiv2 = floor(patchesforupdate(:, 4)/2);
    leftwidth =  patchesforupdate(:, 3) - widthdiv2;
    leftheight = patchesforupdate(:, 4) - heightdiv2;
    %{
    if ~parameter.randompart
        
        [sstrongclassifier.total_strongclassifier, sstrongclassifier.total_selectors, ...
            sstrongclassifier.total_alpha] = updatesparse(sstrongclassifier.total_strongclassifier, ...
            sumimagedata,patchesforupdate, labelforupdate, importance);

        %
        %% top  patches
        top_patches = [patchesforupdate(:,1), patchesforupdate(:, 2), patchesforupdate(:, 3),heightdiv2];

        [sstrongclassifier.top_strongclassifier, sstrongclassifier.top_selectors, ...
            sstrongclassifier.top_alpha] = updatesparse(sstrongclassifier.top_strongclassifier, ...
            sumimagedata, top_patches, labelforupdate, importance);

        %
        %% bottom  patches
        bottom_patches = [patchesforupdate(:, 1), patchesforupdate(:, 2) + patchesforupdate(:, 4) ...
            - leftheight, patchesforupdate(:, 3),leftheight];

        [sstrongclassifier.bottom_strongclassifier, sstrongclassifier.bottom_selectors, ...
            sstrongclassifier.bottom_alpha] = updatesparse(sstrongclassifier.bottom_strongclassifier, ...
            sumimagedata, bottom_patches, labelforupdate, importance);

        %
        %% left patches
        left_patches = [patchesforupdate(:, 1), patchesforupdate(:,2), widthdiv2, patchesforupdate(:, 4)];
        [sstrongclassifier.left_strongclassifier, sstrongclassifier.left_selectors, ...
            sstrongclassifier.left_alpha] = updatesparse(sstrongclassifier.left_strongclassifier, ...
            sumimagedata, left_patches, labelforupdate, importance);

        %
        %% right patches
        right_patches = [patchesforupdate(:, 1) + patchesforupdate(:, 3) - leftwidth, patchesforupdate(:, 2), leftwidth, patchesforupdate(:, 4)];
        [sstrongclassifier.right_strongclassifier, sstrongclassifier.right_selectors, ...
            sstrongclassifier.right_alpha] = updatesparse(sstrongclassifier.right_strongclassifier, ...
            sumimagedata, right_patches, labelforupdate, importance);
    else
    %}
        %% random partbased 
        for i = 1:parameter.partnumber
            part_patches = [ patchesforupdate(:,1) + sstrongclassifier(i).partpatch(1), ...
                             patchesforupdate(:,2) + sstrongclassifier(i).partpatch(2), ...
                             repmat(sstrongclassifier(i).partpatch(3), [size(patchesforupdate, 1) 1]), ...
                             repmat(sstrongclassifier(i).partpatch(3), [size(patchesforupdate, 1) 1]) ];
            [sstrongclassifier(i).partclassifier, sstrongclassifier(i).selectors, sstrongclassifier(i).alpha] ...
                = updatesparse(sstrongclassifier(i).partclassifier, sumimagedata, part_patches, labelforupdate, importance);
        end
    %end
end