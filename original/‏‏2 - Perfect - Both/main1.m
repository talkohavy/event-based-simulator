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
    cells = Simulation();
    cells.U_Start = 4;
    cells.P_Start = 4;
    cells.F_Start = 4;
    cells.Tmax = 16*60; % minutes
    cells.Umax = 8192;%8192
    %cells.Pmax = 512;
    cells.isHill = 0;
    cells.alphaSS = 0.285;
    cells.k = 1;
    cells.h = 2;
    cells.alpha = 0.285;
    n0 = 30;
    CRN = 71; % 456=to Rami. 123=in presentation.
    %---------------
    %Set and Update:
    %---------------
    tF = 6;% minutes
    tP = 6;% minutes
    tU = 6;% minutes
    cells.DistFood('exp',tF); %Options: determinist exp unif norm 6.3
    cells.DistCreatingP('exp',tP); 
    cells.DistCreatingU('exp',tU); 
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
    unTrnsFullDataU = DataTable(7);
    unTrnsFullDataAlfa = DataTable(7);
    for i= 1:1:n0
        rng(CRN+i)
        cells.RunOnce;
        unTrnsFullDataU.Append(cells.unTrnsDataU);
        unTrnsFullDataAlfa.Append(cells.unTrnsDataAlfa);
    end
    growthData = unTrnsFullDataU.TransformData();
    alfaSignal = unTrnsFullDataAlfa.TransformData();
    
    %--------------------
    %Step 5: Save Results
    %--------------------
    U_Start = cells.U_Start;
    P_Start = cells.P_Start;
    F_Start = cells.F_Start;
    Tmax = cells.Tmax;
    Umax = cells.Umax;
    isHill = cells.isHill;
    alphaSS = cells.alphaSS;
    k = cells.k;
    h = cells.h;
    alpha = cells.alpha;
    if (isHill)
    save 'Model 1 - Workspace.mat' growthData alfaSignal U_Start P_Start F_Start ...
          Tmax Umax isHill alphaSS k h alpha n0 CRN tF tP tU;
    else
        save 'Model 1 - Workspace.mat' growthData alfaSignal U_Start P_Start F_Start ...
          Tmax Umax isHill alpha n0 CRN tF tP tU;
    end
end
fprintf('Finished.\n');