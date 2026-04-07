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
    t=1; U=2; P=3; FsCreated=4; UsResting=5; UsHungry=6; FsAvail=7; Alfa=8; AlfaSS=9; RT=10; Rep=11; columns = Rep;
    cells = Simulation(columns);
    U_Start = 4;
    P_Start = 4;
    F_Start = 4;
    alpha_Start = 0.4497; %(sqrt(2)-1); %1 1*(sqrt(2)-1) 2*(sqrt(2)-1);;
    Tmax = 16*60; % minutes
    Umax = 2048;
    envChange = 64;
    ctrlReact = 65;
    k = 1;
    h = 2;
    n0 = 1;
    CRN = 71;%71
    %---------------
    %Set and Update:
    %---------------
    tF = 6;% minutes
    tP = 6;% minutes
    tU = 6;% minutes
    cells.DistFood('exp',tF); %Options: determinist exp unif norm 6.3
    cells.DistCreatingP('exp',tP); 
    cells.DistCreatingU('exp',tU); 
    cells.DistRestingU('exp',tU/10); 
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------
    %---------------------------- Press F5 --------------------------------
    %---------------------------- Press F5 --------------------------------
    %---------------------------- Press F5 --------------------------------
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------
    cells.U_Start = U_Start ;
    cells.P_Start = P_Start;
    cells.F_Start = F_Start;
    cells.alpha_Start = alpha_Start;
    cells.Tmax = Tmax;
    cells.Umax = Umax;
    cells.envChange = envChange;
    cells.ctrlReact = ctrlReact;
    cells.k = k;
    cells.h = h;
    
    %--------------------
    %Step 4: Run Software
    %--------------------
    isHill = 1;
%     for i= 1:1:n0

        %--------------------------
        %Type 1: Run Once - 1*alpha
        %--------------------------
%         unTrnsFullDataU = DataTable(columns);
%         unTrnsFullDataAlfa = DataTable(columns);
%         rng(CRN) % CRN+i
%         alphaSS = 1*(0.4497); %1 1*(sqrt(2)-1) 2*(sqrt(2)-1);0.2808
%         alphaSSNew = 1*(0.3070);
%         cells.alphaSS = alphaSS;
%         cells.alphaSSNew = alphaSSNew;
%         cells.RunOnce;
%         unTrnsFullDataU.Append(cells.unTrnsDataU);
%         unTrnsFullDataAlfa.Append(cells.unTrnsDataAlfa);
%         growthData = unTrnsFullDataU.DataTableToMatrix();
%         alfaSignal = unTrnsFullDataAlfa.DataTableToMatrix();
%         save 'changeToDouble_Once.mat' growthData alfaSignal U_Start...
%               P_Start F_Start Tmax Umax isHill alpha_Start alphaSS...
%               alphaSSNew ctrlReact envChange n0 CRN tF tP tU ...
%               t U P FsAvail FsCreated Alfa AlfaSS RT;
        
        %--------------------------
        %Type 2: Run Once - 2*alpha
        %--------------------------
        cells.repNumber = 0;
        unTrnsFullDataU = DataTable(columns);
        unTrnsFullDataAlfa = DataTable(columns);  
        rng(CRN) % CRN+i
        alphaSS = 2*(0.4142); %1 1*(sqrt(2)-1) 2*(sqrt(2)-1);0.2808
        alphaSSNew = 2*(0.2808);
        cells.alphaSS = alphaSS;
        cells.alphaSSNew = alphaSSNew;
        cells.RunOnce;
        unTrnsFullDataU.Append(cells.unTrnsDataU);
        unTrnsFullDataAlfa.Append(cells.unTrnsDataAlfa);
        growthData = unTrnsFullDataU.DataTableToMatrix();
        alfaSignal = unTrnsFullDataAlfa.DataTableToMatrix();
        save 'changeToDouble_Twice.mat' growthData alfaSignal U_Start...
              P_Start F_Start Tmax Umax isHill alpha_Start alphaSS...
              alphaSSNew ctrlReact envChange n0 CRN tF tP tU ...
              t U P FsAvail FsCreated Alfa AlfaSS RT;
          
        %----------------------
        %Type 3: Run Once - 1*1
        %----------------------
%         cells.repNumber = 0;
%         unTrnsFullDataU = DataTable(columns);
%         unTrnsFullDataAlfa = DataTable(columns);  
%         rng(CRN)% CRN+i
%         alphaSS = 1;
%         alphaSSNew = 1; %1 1*(sqrt(2)-1) 2*(sqrt(2)-1);
%         cells.alphaSS = alphaSS;
%         cells.alphaSSNew = alphaSSNew;
%         cells.RunOnce;
%         unTrnsFullDataU.Append(cells.unTrnsDataU);
%         unTrnsFullDataAlfa.Append(cells.unTrnsDataAlfa);
%         growthData = unTrnsFullDataU.DataTableToMatrix();
%         alfaSignal = unTrnsFullDataAlfa.DataTableToMatrix();
%         save 'changeToDouble_Is1.mat' growthData alfaSignal U_Start...
%               P_Start F_Start Tmax Umax isHill alpha_Start alphaSS...
%               alphaSSNew ctrlReact envChange n0 CRN tF tP tU ...
%               t U P FsAvail FsCreated Alfa AlfaSS RT;

%     end
end
fprintf('Finished.\n');