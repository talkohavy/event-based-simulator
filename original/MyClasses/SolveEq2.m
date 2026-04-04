function ret = SolveEq2(Ppooli,PSAi)
    % #########  First Method  ##########
    % #########  First Method  ##########
    % #########  First Method  ##########
    % #########  First Method  ##########

    %--------------------------
    % STEP 1: The non-dependant
    %--------------------------
    syms phi
    
    %---------------------------------
    % STEP 2: Left Side (The Equation)
    %---------------------------------
    leftSide = phi;
    %Note: 4 is number of parts in structure.
    
    %-------------------
    % STEP 3: Right Side
    %-------------------
    rightSide = 1/(Ppooli*PSAi) - 1;
    
    %-----------------------------------
    % STEP 4: Solve by MATLAB'S Function
    %-----------------------------------
    ret = double(vpasolve(leftSide == rightSide , phi));
    ret = ret(1);
end