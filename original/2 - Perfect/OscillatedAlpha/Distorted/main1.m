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
    t=1; U=2; P=3; FsCreated=4; FsAvail=5; Alfa=6; AlfaSS=7; RT=8; Rep=9; columns = 9;
    sim = Simulation(columns);
    P_Start = 4;
    I_Start = 4;
    R_Start = 4;
    N = P_Start + I_Start + R_Start;
    Tmax = 16*60; % minutes
    CRN = 364;%71 243
    %---------------
    %Set and Update:
    %---------------
    tInfect = 6;% minutes
    tHeal = 6;% minutes
    cells.DistInfect('exp',tInfect); 
    cells.DistHeal('exp',tHeal); 
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------
    %---------------------------- Press F5 --------------------------------
    %---------------------------- Press F5 --------------------------------
    %---------------------------- Press F5 --------------------------------
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------
    cells.S_Start = S_Start;
    cells.I_Start = I_Start;
    cells.R_Start = R_Start;
    cells.alphaOpt = alphaOptOld;
    cells.Tmax = Tmax;
    cells.Umax = Umax;
    cells.envChange = envChange;
    cells.envFactor = envFactor;
    cells.ctrlReact = ctrlReact;
    cells.k = k;
    cells.h = h;
    isHill = 1;
    %--------------------------
    %Type 1: Run Once - 1*alpha
    %--------------------------
    cells.repNumber = 0;
    unTrnsFullDataU = DataTable(columns);
    unTrnsFullDataAlfa = DataTable(columns);
    rng(CRN) % CRN+i
    alphaSS = 1*alphaOptOld;
    alphaSSNew = 1*alphaOptNew;
    cells.alphaSS = alphaSS;
    cells.alphaSSNew = alphaSSNew;
    cells.RunOnce;
    unTrnsFullDataU.Append(cells.unTrnsDataU);
    unTrnsFullDataAlfa.Append(cells.unTrnsDataAlfa);
    growthData = unTrnsFullDataU.DataTableToMatrix();
    alfaSignal = unTrnsFullDataAlfa.DataTableToMatrix(); %changeToHalf_Once
    save 'noChange.mat' growthData alfaSignal U_Start...
      P_Start F_Start Tmax Umax isHill alphaOptOld alphaSS...
      alphaSSNew ctrlReact envChange n0 CRN tF tP tU ...
      t U P FsAvail FsCreated Alfa AlfaSS RT;
  
    %--------------------------
    %Type 1: Run Once - 2*alpha
    %--------------------------
%     cells.repNumber = 0;
%     unTrnsFullDataU = DataTable(columns);
%     unTrnsFullDataAlfa = DataTable(columns);
%     rng(CRN) % CRN+i
%     alphaSS = max(2*alphaOptOld,1);
%     alphaSSNew = max(2*alphaOptNew,1);
%     cells.alphaSS = alphaSS;
%     cells.alphaSSNew = alphaSSNew;
%     cells.RunOnce;
%     unTrnsFullDataU.Append(cells.unTrnsDataU);
%     unTrnsFullDataAlfa.Append(cells.unTrnsDataAlfa);
%     growthData = unTrnsFullDataU.DataTableToMatrix();
%     alfaSignal = unTrnsFullDataAlfa.DataTableToMatrix();
%     save 'changeToHalf_Twice.mat' growthData alfaSignal U_Start...
%       P_Start F_Start Tmax Umax isHill alphaOptOld alphaSS...
%       alphaSSNew ctrlReact envChange n0 CRN tF tP tU ...
%       t U P FsAvail FsCreated Alfa AlfaSS RT;
  
    %----------------------
    %Type 1: Run Once - 1*1
    %----------------------
%     cells.repNumber = 0;
%     unTrnsFullDataU = DataTable(columns);
%     unTrnsFullDataAlfa = DataTable(columns);
%     rng(CRN)
%     alphaSS = 1;
%     alphaSSNew = 1;
%     cells.alphaSS = alphaSS;
%     cells.alphaSSNew = alphaSSNew;
%     cells.RunOnce;
%     unTrnsFullDataU.Append(cells.unTrnsDataU);
%     unTrnsFullDataAlfa.Append(cells.unTrnsDataAlfa);
%     growthData = unTrnsFullDataU.DataTableToMatrix();
%     alfaSignal = unTrnsFullDataAlfa.DataTableToMatrix();
%     save 'changeToHalf_is1.mat' growthData alfaSignal U_Start...
%       P_Start F_Start Tmax Umax isHill alphaOptOld alphaSS...
%       alphaSSNew ctrlReact envChange n0 CRN tF tP tU ...
%       t U P FsAvail FsCreated Alfa AlfaSS RT;
end
fprintf('Finished.\n');