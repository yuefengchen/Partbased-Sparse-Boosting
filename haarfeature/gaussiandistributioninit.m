function gaussiandistributioninit(initial_parameter)
    global posgaussian;
    global neggaussian;
    if size(initial_parameter, 2) ~= 2
        disp('error initial_parameter is not equal 2');
    end
    numofweakcls = size(initial_parameter, 1);
    % gaussian distribution 
    % weakcls(:,1)     mean
    % weakcls(:,2)     sigma
    % weakcls(:,3)     m_P_mean
    % weakcls(:,4)     m_R_mean
    % weakcls(:,5)     m_P_sigma
    % weakcls(:,6)     m_R_sigma
    posgaussian = zeros(numofweakcls, 6);
    posgaussian(:,1:2) = initial_parameter;
    posgaussian(:,3) = 1000;
    posgaussian(:,4) = 0.01;
    posgaussian(:,5) = 1000;
    posgaussian(:,6) = 0.01;
    
    neggaussian = zeros(numofweakcls, 6);
    neggaussian(:,1:2) = initial_parameter;
    neggaussian(:,3) = 1000;
    neggaussian(:,4) = 0.01;
    neggaussian(:,5) = 1000;
    neggaussian(:,6) = 0.01;
end