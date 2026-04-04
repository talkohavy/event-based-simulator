function ret = SolveEq1(tRP,Ppooli,PSAi,alfa)
    % #########  First Method  ##########
    % #########  First Method  ##########
    % #########  First Method  ##########
    % #########  First Method  ##########
    %--------------------------
    % STEP 1: The non-dependant
    %--------------------------
    syms mu
    
    %---------------------------------
    % STEP 2: Left Side (The Equation)
    %---------------------------------
    %leftSide = 1/(1+s*tRP)*(alfa/4*(1/(1+s*tSAi))^4 + 1);
    leftSide = 1/(1+mu*tRP)*(alfa/4*Ppooli*PSAi + 1);
    %Note: 4 is number of parts in structure.
    
    %-------------------
    % STEP 3: Right Side
    %-------------------
    rightSide = 1;
    
    %-----------------------------------
    % STEP 4: Solve by MATLAB'S Function
    %-----------------------------------
    ret = double(solve(leftSide == rightSide , mu));
    ret = ret(1);
end