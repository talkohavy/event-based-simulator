clc;
close all;
format shortG;
if (length(findall(0)) > 1)
    delete(findall(0));
end
addpath("MyClasses")
%----------------------------------
if (questdlg("Run Simulation?") == "Yes")
    clear;
    t=1; U=2; P=3; F=4; Alfa=5; RT=6; Rep=7; columns=Rep;
    cells = Simulation(columns);
    cells.U_Start = 4;
    cells.P_Start = 4;
    cells.F_Start = 4;
    cells.Tmax = 1600*60; % minutes
    cells.Umax = 4096;%4096
    %cells.Pmax = 512;
    cells.isHill = 0;
    cells.alpha = sqrt(2)-1;
    n0 = 2;
    CRN = 71;
    %---------------
    %Set and Update:
    %---------------
    tF = 6;% minutes
    tP = 6;% minutes
    tU = 6;% minutes
    dist = "exp"; %Options: determinist exp unif norm
    cells.DistFood(dist,tF); 
    cells.DistCreatingP(dist,tP); 
    cells.DistCreatingU(dist,tU); 
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------
    %---------------------------- Press F5 --------------------------------
    %---------------------------- Press F5 --------------------------------
    %---------------------------- Press F5 --------------------------------
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------

    %--------------------
    %Step 4: Run Software
    %--------------------
    unTrnsFullDataU = DataTable(columns);
    for i= 1:1:n0
        rng(CRN+i)
        cells.RunOnce;
        unTrnsFullDataU.Append(cells.unTrnsDataU);
    end
    growthData = unTrnsFullDataU.TransformData();
    %--------------------
    %Step 5: Save Results
    %--------------------
    U_Start = cells.U_Start;
    P_Start = cells.P_Start;
    F_Start = cells.F_Start;
    Tmax = cells.Tmax;
    Umax = cells.Umax;
    isHill = 0;
    wasExploded = cells.Explosion;
    alpha = cells.alpha;
    clear i unTrnsFullDataU cells columns;
	save ('OptFixedAlpha.mat');
end
fprintf('Finished.\n');