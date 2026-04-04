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
    cells = MySoftware();
    %--------------------
    %STEP 1: Create Graph
    %--------------------
    tuple = {'r1','r2','P1','P2','P3','P4'};
    len = length(tuple);
    names = strings(1,len);
    for i=1:1:len
        names(i) = tuple{i};
    end
    %      r1 r2 P1 P2 P3 P4
    %      01 02 03 04 05 06
    arr = [ 0  1  1  0  0  0; %01 r1 1
            0  0  0  1  0  0; %02 r2 2
            0  0  0  0  1  0; %03 P1 3
            0  0  0  0  0  1; %04 P2 4
            0  0  0  0  0  0; %05 P3 5
            0  0  0  0  0  0];%06 P4 6
    graphMatrix = GraphMatrix(arr,names);
    graphMatrix.DFS();
    graphMatrix.TopologicalSort();
    graphMatrix.MakeForcedArray();
    graphMatrix.MakeStillAndNotForced();
    graphMatrix.PrintTopological();
    cells.graphMatrix = graphMatrix;
    
    %----------------------------
    %STEP 2: Update Simple Fields
    %----------------------------
    cells.U_Start = 4;
    cells.P_Start = 4;
    cells.F_Start = 0;%0
    cells.Tmax = 6*60;
    cells.Umax = 2048;
    cells.Pmax = 10240000;
    cells.isHill = 0;
    cells.alphaSS = 0.285;
    cells.k = 2;
    cells.h = 2;
    cells.alpha = 0.285;
    n0 = 5;
    CRN = 123; % 456=to Rami. 123=in presentation.
    %---------------
    %Set and Update:
    %---------------
    cells.DistFood('exp',6); %Options: determinist exp unif norm 6.3 ('exp',12)
    cells.DistCreatingP('exp',0.1167);
    cells.DistCreatingRP('exp',6.3/4*1.1);
    cells.DistSelfAssembly('exp',2);
    %--------------------------------------------------------------------------
    %--------------------------------------------------------------------------
    %----------------------------- Press F5 -----------------------------------
    %----------------------------- Press F5 -----------------------------------
    %----------------------------- Press F5 -----------------------------------
    %--------------------------------------------------------------------------
    %--------------------------------------------------------------------------

    %-------
    %Step 4: Run Software
    %-------
    unTrnsFullData = DataTable(7);
    for i= 1:1:n0
        rng(CRN+i)
        cells.RunOnce;
        unTrnsFullData.Append(cells.unTrnsData);
    end
    fullDataArr = unTrnsFullData.TransformData();

    %-------
    %Step 5: Rami's Format
    %-------
    %Row Alpha MuFitted_1 R2Squared_1 MuFitted_2 R2Squared_2
    % 1  0.05    0.079        0.99         0.081    0.99
    
%     alfaMin = 0.75;
%     alfaMax = 1;
%     step = 0.05;
%     curAlfa = alfaMin;
%     rows = uint8((alfaMax-alfaMin)/step)+1;
%     toRami = zeros(rows,2+2*n0);
%     for i= 1:1:rows
%         cells.alpha = curAlfa;
%         toRami(i,1) = i;
%         toRami(i,2) = cells.alpha;
%         disp(cells.alpha);
%		  cells.runNumber = 0;
%         for j = 1:1:n0
%             rng(CRN+j)
%             cells.RunOnce;
%			  oneRepDataArr = cells.unTrnsData.TransformData();
%             toRami(i,3+2*(j-1)) = cells.CalcMuFitted(oneRepDataArr).b;
%             toRami(i,4+2*(j-1)) = cells.R2squared(oneRepDataArr);
%             %---------------------------------------
%             %cells.ClearFigure();
%             %cells.Plot_expectedU();
%             %cells.Plot_fittedU(oneRepDataArr);
%             %pause(0.00005);
%         end
%         curAlfa = curAlfa + step;
%     end    
%     delete(findall(0));
%     filename = 'C:\\Users\\\blacksoul\\Desktop\\values.xlsx';
%     xlswrite(filename,toRami);
end
%#############################################################
%#############################################################
%#############################################################
%#############################################################
%#############################################################
%#############################################################
%#############################################################
%#############################################################
%#############################################################
%#############################################################
%Explanation: After sim you'll have fullDataArr and the function
%SetRep, which accepts arr and number of rep. SetRep returns an
%arr of the certain Rep results.
t=1; U=2; P=3; F=4; Alfa=5; RT=6; Rep=7;
numOfReps = fullDataArr(end,Rep);

%------------------------------
%STAGE 2: Plot after simulation
%------------------------------
if (questdlg("Run Plots?") == "Yes")    
    cells.NewFigure();
    if (cells.isHill)
        %----------------------------
        %VERSION 1: Alfa is osillated
        %----------------------------
        %Step 1: Plot n0 Graphs
        for i = 1:1:numOfReps
            cells.ClearFigure();
            oneRepDataArr = SetRep(fullDataArr,i);
            cells.Plot_xVy(oneRepDataArr,t,U);%cells.data
            cells.Plot_xVy(oneRepDataArr,t,P);
            cells.Plot_xVy(oneRepDataArr,t,F);
            pause(1);
        end
        pause(1);

        %-------
        %Step 2: RBS gauge for Alpha Hill
        %-------
        if (numOfReps > 1)
            cells.AlphaRBS(fullDataArr);
            pause(5);
            delete(findall(0));
            cells.NewFigure();
        end
        pause(1);
        
        %-------
        %Step 3: View Alpha Vibrations
        %-------
        for i = 1:1:numOfReps
            cells.ClearFigure();
            oneRepDataArr = SetRep(fullDataArr,i);
            cells.Plot_xVy(oneRepDataArr,t,Alfa);
            cells.SetMaxXMaxY(200,0.9);
            pause(1);
        end
        pause(2);
        
        %-------
        %Step 5: SimTime Vs. RealTime
        %-------
        for i = 1:1:numOfReps
            cells.ClearFigure();
            oneRepDataArr = SetRep(fullDataArr,i);
            cells.Plot_xVy(oneRepDataArr,RT,t);
            cells.SetMaxXMaxY(0.5,100);
            pause(1);
            cells.SetMaxXMaxY(2.5,150);
            pause(1);
            cells.SetMaxXMaxY(8,200);
            pause(3);
        end
    else
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %------------------------------------------------------------------
        %                  VERSION 2: Alfa is Fixed
        %------------------------------------------------------------------
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %Step 1: SimTime Vs. RealTime
%         for i = 1:1:numOfReps
%             cells.ClearFigure();
%             oneRepDataArr = SetRep(fullDataArr,i);
%             cells.Plot_xVy(oneRepDataArr,RT,t);
%             cells.SetMaxXMaxY(0.5,100);
%             pause(1);
%             cells.SetMaxXMaxY(2.5,150);
%             pause(1);
%             cells.SetMaxXMaxY(8,200);
%             pause(3);
%         end
        
        %-------
        %Step 2: Fitted Vs. Expected
        %-------
        for i = 1:1:numOfReps
            cells.ClearFigure();
            oneRepDataArr = SetRep(fullDataArr,i);
            fprintf('-------------------\n')
            fprintf('Results of Rep: %.0f\n', i)
            cells.ScatterPlot_xVy(oneRepDataArr,t,U);
            pause(2);
%             cells.Plot_expectedU();
%             pause(2);
            cells.Plot_fittedU(oneRepDataArr);
            pause(2);
            cells.Plot_ProveLinear(oneRepDataArr,U);
            cells.R2squared(oneRepDataArr,2);
            pause(2);
            cells.SetMaxXMaxY(100,20);
            pause(2);
            cells.SetMaxXMaxY(600,600);
            pause(2);
            cells.Plot_xVy(oneRepDataArr,t,F);
            pause(2);
        end
    end
end
%delete(findall(0));
%cells.Animation();
% oneRepDataArr = SetRep(fullDataArr,1);
% xi = oneRepDataArr(:,t);
% ui = oneRepDataArr(:,U);
% sz = length(xi);
% yi = zeros(sz,1);
% for j=1:1:sz
%     yi(j) = log(ui(j)/ui(1));
% end
% disp('Finished.'); 

 % oneRepDataArr = SetRep(fullDataArr,1);
 % cells.R2squared(oneRepDataArr,2) %On who= 2-U   3-P