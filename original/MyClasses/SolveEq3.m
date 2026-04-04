function ret = SolveEq3(tPool_arr,tSA_arr,tRP,alfa)
    % #########  First Method  ##########
    % #########  First Method  ##########
    % #########  First Method  ##########
    % #########  First Method  ##########
    n = length(tPool_arr);
    
    %--------------------------
    % STEP 1: The non-dependant
    %--------------------------
    syms mu
    
    %---------------------------------
    % STEP 2: Left Side (The Equation)
    %---------------------------------
    leftSide = 1;
    %Note: 4 is number of parts in structure.
    
    %-------------------
    % STEP 3: Right Side
    %-------------------
    rightSide = (alfa/(4*n)*sum(exp(-mu*(tSA_arr+tPool_arr)))+1) * 1/(1+mu*tRP);
    
    %-----------------------------------
    % STEP 4: Solve by MATLAB'S Function
    %-----------------------------------
    ret = double(vpasolve(leftSide == rightSide , mu));
    ret = ret(1);
end