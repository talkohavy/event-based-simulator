clc;
close all;
format shortG;
if(length(findall(0))>1)
    delete(findall(0));
end
addpath("MyClasses")
%----------------------------------
if (questdlg("Run Simulation?") == "Yes")
    clear;
    cells = Simulation();
    %--------------------
    %STEP 1: Create Graph
    %--------------------
    tuple = {'r1','P1','P2','P3','P4'};
    len = length(tuple);
    names = strings(1,len);
    for i=1:1:len
        names(i) = tuple{i};
    end
    %      r1 P1 P2 P3 P4
    %      01 02 03 04 05
    arr = [ 0  1  0  0  0; %01 r1 1
            0  0  1  0  0; %03 P1 2
            0  0  0  1  0; %04 P2 3
            0  0  0  0  1; %05 P3 4
            0  0  0  0  0];%06 P4 5
    graphMatrix = GraphMatrix(arr,names);
    graphMatrix.DFS();
    graphMatrix.TopologicalSort();
    graphMatrix.MakeForcedArray();
    graphMatrix.MakeStillAndNotForced();
    graphMatrix.PrintTopological();
    cells.graphMatrix = graphMatrix;
    
    %---------------------
    %STEP 2: Update Fields
    %---------------------
    cells.U_Start = 4;
    cells.P_Start = 4;
    cells.F_Start = 0;
    cells.Tmax = 16*60;
    cells.Umax = 512;
    cells.alpha = 0.285;
    n0 = 5;
    CRN = 71;
    tF = 6;
    tP = 0.1167;
    tRP = 6.3/4*1.1;
    tSA = 0.5; %6/4
    cells.DistFood('exp',tF); %Options: determinist exp unif norm
    cells.DistCreatingP('exp',tP);
    cells.DistCreatingRP('exp',tRP);
    cells.DistSelfAssembly('exp',tSA);
    %--------------------------------------------------------------------------
    %--------------------------------------------------------------------------
    %----------------------------- Press F5 -----------------------------------
    %----------------------------- Press F5 -----------------------------------
    %----------------------------- Press F5 -----------------------------------
    %--------------------------------------------------------------------------
    %--------------------------------------------------------------------------
    
    %--------------------
    %Step 3: Run Software
    %--------------------
    unTrnsFullDataU = DataTable(7);
    unTrnsFullDataRP = DataTable(6);
    unTrnsFullDataInv = DataTable(12);
    for i= 1:1:n0
        rng(CRN+i)
        cells.RunOnce;
        unTrnsFullDataU.Append(cells.unTrnsDataU);
        unTrnsFullDataRP.Append(cells.unTrnsDataRP);
        unTrnsFullDataInv.Append(cells.unTrnsDataInv);
    end
    growthData = unTrnsFullDataU.TransformData();
    distOfAllRPs = unTrnsFullDataRP.TransformData();
    inventoryList = unTrnsFullDataInv.TransformData();
    
    %--------------------------
    %Step 4: Change Data Format
    %--------------------------
    P1=2;
    P2=3;
    P3=4;
    P4=5;
    vertexes = 5;
    numOfRows = size(distOfAllRPs,1);
    distOfP1 = zeros(numOfRows/vertexes,2);
    distOfP2 = zeros(numOfRows/vertexes,2);
    distOfP3 = zeros(numOfRows/vertexes,2);
    distOfP4 = zeros(numOfRows/vertexes,2);
    indexP1 = 1;
    indexP2 = 1;
    indexP3 = 1;
    indexP4 = 1;
    for i = 1:1:numOfRows
        %---------------------------------------------
        %Get time distribution in Pool&Assembly of P1:
        %---------------------------------------------
        if (distOfAllRPs(i, 1) == P1)
            %Step 1: distP1_Pool_Rep_i
            distOfP1(indexP1,1) = distOfAllRPs(i, 3) - distOfAllRPs(i, 2);
            %Step 2: distP1_FullAssembly_Rep_i
            distOfP1(indexP1,2) = distOfAllRPs(i, 5) - distOfAllRPs(i, 3);
            %Step 3: rep number
            distOfP1(indexP1,3) = distOfAllRPs(i, 6);
            %Step 4: increase index
            indexP1 = indexP1 + 1;
        end

        %---------------------------------------------
        %Get time distribution in Pool&Assembly of P2:
        %---------------------------------------------
        if (distOfAllRPs(i, 1) == P2)
            %Step 1: distP2_Pool_Rep_i
            distOfP2(indexP2,1) = distOfAllRPs(i, 3) - distOfAllRPs(i, 2);
            %Step 2: distP2_FullAssembly_Rep_i
            distOfP2(indexP2,2) = distOfAllRPs(i, 5) - distOfAllRPs(i, 3);
            %Step 3: rep number
            distOfP2(indexP2,3) = distOfAllRPs(i, 6);
            %Step 4: increase index
            indexP2 = indexP2 + 1;
        end

        %---------------------------------------------
        %Get time distribution in Pool&Assembly of P3:
        %---------------------------------------------
        if (distOfAllRPs(i, 1) == P3)
            %Step 1: distP3_Pool_Rep_i
            distOfP3(indexP3,1) = distOfAllRPs(i, 3) - distOfAllRPs(i, 2);
            %Step 2: distP3_FullAssembly_Rep_i
            distOfP3(indexP3,2) = distOfAllRPs(i, 5) - distOfAllRPs(i, 3);
            %Step 3: rep number
            distOfP3(indexP3,3) = distOfAllRPs(i, 6);
            %Step 4: increase index
            indexP3 = indexP3 + 1;
        end

        %---------------------------------------------
        %Get time distribution in Pool&Assembly of P4:
        %---------------------------------------------
        if (distOfAllRPs(i, 1) == P4)
            %Step 1: distP4_Pool_Rep_i
            distOfP4(indexP4,1) = distOfAllRPs(i, 3) - distOfAllRPs(i, 2);
            %Step 2: distP4_FullAssembly_Rep_i
            distOfP4(indexP4,2) = distOfAllRPs(i, 5) - distOfAllRPs(i, 3);
            %Step 3: rep number
            distOfP4(indexP4,3) = distOfAllRPs(i, 6);
            %Step 4: increase index
            indexP4 = indexP4 + 1;
        end
    end
    
    %--------------------
    %Step 5: Save Results
    %--------------------
    U_Start = cells.U_Start;
    P_Start = cells.P_Start;
    F_Start = cells.F_Start;
    Tmax = cells.Tmax;
    Umax = cells.Umax;
    alpha = cells.alpha;
    P1 = 2;
    P2 = 3;
    P3 = 4;
    P4 = 5;
    vertexes = 5; %including r1
    save 'Serial - Workspace.mat' ...
    growthData distOfP1 distOfP2 distOfP3 distOfP4 inventoryList...
    CRN U_Start P_Start F_Start Tmax Umax alpha n0 CRN tF tP tRP tSA;
    fprintf("Finished.\n")
end