function sstrongclassifier = partbased_init_strongclassifier(I, patch)
    global parameter;
    
    widthdiv2 = floor(patch(3)/2);
    heightdiv2 = floor(patch(4)/2);
    leftwidth = patch(3) - widthdiv2;
    leftheight = patch(4) - heightdiv2;
    if  ~parameter.randompart
        
        %{
        %% total
        partpatch = [0 , 0, patch(3), patch(4)];
        sstrongclassifier(1).partclassifier = init_strongclassifier(I, [patch(1) + partpatch(1), ...
                    patch(2) + partpatch(2), partpatch(3), partpatch(4)]);
        sstrongclassifier(1).partpatch = [partpatch(1), partpatch(2), partpatch(3), partpatch(4)];
        
        %% top
        partpatch = [0 , 0, patch(3), heightdiv2];
        sstrongclassifier(2).partclassifier = init_strongclassifier(I, [patch(1) + partpatch(1), ...
                    patch(2) + partpatch(2), partpatch(3), partpatch(4)]);
        sstrongclassifier(2).partpatch = [partpatch(1), partpatch(2), partpatch(3), partpatch(4)];
        
        %% left
        partpatch = [0 , 0, widthdiv2, patch(4)];
        sstrongclassifier(3).partclassifier = init_strongclassifier(I, [patch(1) + partpatch(1), ...
                    patch(2) + partpatch(2), partpatch(3), partpatch(4)]);
        sstrongclassifier(3).partpatch = [partpatch(1), partpatch(2), partpatch(3), partpatch(4)];
        
        %% bottom
        partpatch = [0 , patch(4) - leftheight, patch(3), leftheight];
        sstrongclassifier(4).partclassifier = init_strongclassifier(I, [patch(1) + partpatch(1), ...
                    patch(2) + partpatch(2), partpatch(3), partpatch(4)]);
        sstrongclassifier(4).partpatch = [partpatch(1), partpatch(2), partpatch(3), partpatch(4)];
        
        %% right
        partpatch = [patch(3) - leftwidth , 0, widthdiv2, patch(4)];
        sstrongclassifier(5).partclassifier = init_strongclassifier(I, [patch(1) + partpatch(1), ...
                    patch(2) + partpatch(2), partpatch(3), partpatch(4)]);
        sstrongclassifier(5).partpatch = [partpatch(1), partpatch(2), partpatch(3), partpatch(4)];
        %}
        %%
        %{
        sstrongclassifier.total_strongclassifier = init_strongclassifier(I,patch);
    
        %top and bottom
        sstrongclassifier.top_strongclassifier = init_strongclassifier(I, [ patch(1), patch(2), patch(3), heightdiv2]);
        sstrongclassifier.bottom_strongclassifier = init_strongclassifier(I, [ patch(1), ...
        patch(2) + patch(4) - leftheight , patch(3), leftheight ]);
        % left and right
        sstrongclassifier.left_strongclassifier = init_strongclassifier(I, [ patch(1) , patch(2), widthdiv2, patch(4)] );
        sstrongclassifier.right_strongclassifier = init_strongclassifier(I, [ patch(1) + patch(3) - leftwidth, ...
        patch(2), leftwidth, patch(4)] );
        %}
        %% just for test
        %% total
        partpatch = [0 , 0, patch(3), patch(4)];
        sstrongclassifier(1).partclassifier = init_strongclassifier(I, [patch(1) + partpatch(1), ...
                    patch(2) + partpatch(2), partpatch(3), partpatch(4)]);
        sstrongclassifier(1).partpatch = [partpatch(1), partpatch(2), partpatch(3), partpatch(4)];

        %% top
        partpatch = [0 , 0, patch(3), heightdiv2];
        sstrongclassifier(2).partclassifier = init_strongclassifier(I, [patch(1) + partpatch(1), ...
                    patch(2) + partpatch(2), partpatch(3), partpatch(4)]);
        sstrongclassifier(2).partpatch = [partpatch(1), partpatch(2), partpatch(3), partpatch(4)];

        %% left
        partpatch = [0 , 0, widthdiv2, patch(4)];
        sstrongclassifier(3).partclassifier = init_strongclassifier(I, [patch(1) + partpatch(1), ...
                    patch(2) + partpatch(2), partpatch(3), partpatch(4)]);
        sstrongclassifier(3).partpatch = [partpatch(1), partpatch(2), partpatch(3), partpatch(4)];

        %% bottom
        partpatch = [0 , patch(4) - leftheight, patch(3), leftheight];
        sstrongclassifier(4).partclassifier = init_strongclassifier(I, [patch(1) + partpatch(1), ...
                    patch(2) + partpatch(2), partpatch(3), partpatch(4)]);
        sstrongclassifier(4).partpatch = [partpatch(1), partpatch(2), partpatch(3), partpatch(4)];

        %% right
        partpatch = [patch(3) - leftwidth , 0, leftwidth, patch(4)];
        sstrongclassifier(5).partclassifier = init_strongclassifier(I, [patch(1) + partpatch(1), ...
                    patch(2) + partpatch(2), partpatch(3), partpatch(4)]);
        sstrongclassifier(5).partpatch = [partpatch(1), partpatch(2), partpatch(3), partpatch(4)];
        if parameter.partnumber == 7
            %% middle horizon
            partpatch = [0 , floor(patch(4)/4), patch(3), heightdiv2];
            sstrongclassifier(6).partclassifier = init_strongclassifier(I, [patch(1) + partpatch(1), ...
                        patch(2) + partpatch(2), partpatch(3), partpatch(4)]);
            sstrongclassifier(6).partpatch = [partpatch(1), partpatch(2), partpatch(3), partpatch(4)];

            %% middle vertical
            partpatch = [floor(patch(3)/4), 0, widthdiv2, patch(4)];
            sstrongclassifier(7).partclassifier = init_strongclassifier(I, [patch(1) + partpatch(1), ...
                        patch(2) + partpatch(2), partpatch(3), partpatch(4)]);
            sstrongclassifier(7).partpatch = [partpatch(1), partpatch(2), partpatch(3), partpatch(4)];
        end
    else
        %sstrongclassifier = struct('partclassifier', struct, ...
         %                          'part_selectors', struct, ...
         %                          'part_alpha', struct ...
         %                  );
        if  parameter.sizefixed
            
            partpatch = [0 , 0, patch(3), patch(4)];
            sstrongclassifier(1).partclassifier = init_strongclassifier(I, [patch(1) + partpatch(1), ...
                        patch(2) + partpatch(2), partpatch(3), partpatch(4)]);
            sstrongclassifier(1).partpatch = [partpatch(1), partpatch(2), partpatch(3), partpatch(4)];

           
            
            
            for i = 2:parameter.partnumber
                vaild = true;
                while vaild
                    partpatch(1) = randi(patch(3)) - 1 ;
                    partpatch(2) = randi(patch(4)) - 1 ;
                    
                    if partpatch(1) + parameter.fixedwidth <= patch(3) & ...
                            partpatch(2) + parameter.fixedheight <= patch(4)
                        vaild = false;
                    end
                end
                partpatch(3) = parameter.fixedwidth;
                partpatch(4) = parameter.fixedheight;
               
                sstrongclassifier(i).partclassifier = init_strongclassifier(I, [patch(1) + partpatch(1), ...
                    patch(2) + partpatch(2), partpatch(3), partpatch(4)]);
                sstrongclassifier(i).partpatch = [partpatch(1), partpatch(2), partpatch(3), partpatch(4)];
            end    
        else
            
        end
    end
   
   %{
   sstrongclassifier.total_strongclassifier = init_strongclassifiersptial(patch);
    
    %top and bottom
    sstrongclassifier.top_strongclassifier = init_strongclassifiersptial( [ patch(1), patch(2), patch(3), heightdiv2]);
    sstrongclassifier.bottom_strongclassifier = init_strongclassifiersptial( [ patch(1), ...
        patch(2) + patch(4) - leftheight , patch(3), leftheight ]);
    % left and right
    sstrongclassifier.left_strongclassifier = init_strongclassifiersptial( [ patch(1) , patch(2), widthdiv2, patch(4)] );
    sstrongclassifier.right_strongclassifier = init_strongclassifiersptial( [ patch(1) + patch(3) - leftwidth, ...
       patch(2), leftwidth, patch(4)] );
    %}
end