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
    cells.Umax = 1024;
    cells.alphaSS = 2*(sqrt(2)-1); %0.285*2;
    cells.k = 1;
    cells.h = 2;
    n0 = 1;
    CRN = 75; %71=in presentation.
    %---------------
    %Set and Update:
    %---------------
    tF = 6;% minutes
    tP = 6;% minutes
    tU = 6;% minutes
%     k = 3; % for erlang
    cells.DistFood('exp',tF); %Options: determinist exp unif norm (erlang,k,t) hyperexp
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
    growthData = unTrnsFullDataU.DataTableToMatrix();
    alfaSignal = unTrnsFullDataAlfa.DataTableToMatrix();
    
    %--------------------
    %Step 5: Save Results
    %--------------------
    U_Start = cells.U_Start;
    P_Start = cells.P_Start;
    F_Start = cells.F_Start;
    Tmax = cells.Tmax;
    Umax = cells.Umax;
    isHill = 1;
    alphaSS = cells.alphaSS;
    alpha = cells.alpha;
    k = cells.k;
    h = cells.h;
    save 'TwoAlphaOpt_exp_kIs1.mat' growthData alfaSignal U_Start P_Start F_Start ...
          Tmax Umax isHill alpha n0 CRN tF tP tU;
end
fprintf('Finished.\n');