function aff_matrix = generateaffinematrix( p )
    % theta   p(1)
    % alpha   p(2)
    % scale_x p(3)
    % scale_y p(4)
    % off_x   p(5)
    % off_y   p(6)
    
    rotationmatrix = [cos(p(1)) -sin(p(1)); 
                      sin(p(1)) cos(p(1))];
    stretchmatrix =   [cos(p(2)) -sin(p(2)); 
                      sin(p(2)) cos(p(2))];
    negstretchmatrix = [ cos(p(2)) sin(p(2)) ;
                        -sin(p(2)) cos(p(2)) ];
    scalematrix = [p(3) 0;
                   0  p(4)];  
    A = rotationmatrix * negstretchmatrix * scalematrix * stretchmatrix;
    aff_matrix = [A, [p(5); p(6)]];
    aff_matrix = [aff_matrix ; [0 0 1]];
end