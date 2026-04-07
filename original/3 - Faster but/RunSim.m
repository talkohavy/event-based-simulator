clc;
close all;
format shortG;
%delete(findall(0));
addpath("MyClasses")
%----------------------------------
if (questdlg("Run Simulation?") == "Yes")
    clear;
    cells=MySoftware();
    cells.U_Start = 1;
    cells.P_Start = 1;
    cells.F_Start = 0;%2000
    cells.Tmax = 1.3*60;
    cells.Umax = 2048;
    cells.isHill = 0;
    cells.alphaSS = 0.28;
    cells.k = 2;
    cells.h = 2;
    cells.alpha = 0.41;
    n0=30;
    CRN = 456; % 456=to Rami. 123=in presentation.
    %---------------
    %Set and Update:
    %---------------
    cells.FoodDist('exp',12); %Options: determinist exp unif norm 6.3
    cells.DupDist('exp',6); %Options: determinist exp unif norm 6.3
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
%     cells.Run(CRN,1);
    cells.NewFigure();
    alfaMin = 0.05;
    alfaMax = 0.3;
    step = 0.05;
    curAlfa = alfaMin;
    rows = uint8((alfaMax-alfaMin)/step);
    toRami = zeros(rows,2+2*n0);
    for i= 1:1:rows
        cells.alpha = curAlfa;
        toRami(i,1) = i;
        toRami(i,2) = cells.alpha;
        disp(cells.alpha);
        cells.numOfReps = 0;
        t=1; U=2; P=3; F=4; Alfa=5; RT=6;
        for j= 1:1:n0
            rng(CRN+j)
            cells.RunOnce;
            toRami(i,3+2*(j-1)) = cells.CalcMuFitted().b;
            toRami(i,4+2*(j-1)) = cells.R2squared();
            %---------------------------------------
%             cells.ClearFigure();
%             cells.Plot_expectedU();
%             cells.Plot_fittedU();
%             pause(0.00005);
        end
        curAlfa = curAlfa + step;
    end    
    delete(findall(0));
    filename = 'C:\\Users\\talkohavy\\Desktop\\values.xlsx';
    xlswrite(filename,toRami);
%     cells.TransformData;
%     cells.SetRep(1);
%     fullData = cells.fullData; % Columns: 1=t 2=U 3=P 4=F 5=Alfa 6=RT 7=Replication
%     fullData = xlsread(filename);
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

if (questdlg("Run Plots?") == "Yes")
    %-------
    %Step 1: if not right after sim
    %-------
%     filename = 'C:\\Users\\talkohavy\\Desktop\\Values 2.xlsx';
%     fullData = xlsread(filename);
%     cells.fullData = fullData;
%     cells.numOfReps = fullData(end,7);
%     cells.fixedAlpha = 0.7;


    
    t=1; U=2; P=3; F=4; Alfa=5; RT=6;
    cells.NewFigure();
    if (cells.isHill)
        %-------
        %Step 2: Plot n0 Graphs
        %-------
        for i = 1:1:cells.numOfReps
            cells.ClearFigure();
            cells.SetRep(i);
            cells.Plot_xVy(t,U);
            cells.Plot_xVy(t,P);
            cells.Plot_xVy(t,F);
            pause(1);
        end
        pause(1);

        %-------
        %Step 2: RBS gauge for Alpha Hill
        %-------
        if (cells.numOfReps>1)
            cells.AlphaRBS();
            pause(5);
            delete(findall(0));
            cells.NewFigure();
        end
        pause(1);
        
        %-------
        %Step 3: View Alpha Vibrations
        %-------
        for i = 1:1:cells.numOfReps
            cells.ClearFigure();
            cells.SetRep(i);
            cells.Plot_xVy(t,Alfa);
            cells.SetMaxXMaxY(200,0.9);
            pause(1);
        end
        pause(2);
        
        %-------
        %Step 5: SimTime Vs. RealTime
        %-------
        for i = 1:1:cells.numOfReps
            cells.ClearFigure();
            cells.SetRep(i);
            cells.Plot_xVy(RT,t);
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
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %-------
        %Step 6: SimTime Vs. RealTime
        %-------
        for i = 1:1:cells.numOfReps
            cells.ClearFigure();
            cells.SetRep(i);
            cells.Plot_xVy(RT,t);
            cells.SetMaxXMaxY(0.5,100);
            pause(1);
            cells.SetMaxXMaxY(2.5,150);
            pause(1);
            cells.SetMaxXMaxY(8,200);
            pause(3);
        end
        
        %-------
        %Step 7: Fitted Vs. Expected
        %-------
        for i = 1:1:cells.numOfReps
            cells.ClearFigure();
            cells.SetRep(i);
            fprintf('-------------------\n')
            fprintf('Results of Rep: %.0f\n', i)
            cells.ScatterPlot_xVy(t,U);
            pause(1);
            cells.Plot_expectedU();
            pause(1);
            cells.Plot_fittedU();
            pause(1);
            cells.Plot_ProveLinear(U);
            pause(1);
            cells.SetMaxXMaxY(100,20);
            pause(1);
            cells.SetMaxXMaxY(600,600);
            %cells.Plot_xVy(t,F);
            %pause(1);
        end
    end
end
%delete(findall(0));
%cells.Animation();
%cells.SetRep(i);
xi = cells.data(:,t);
ui = cells.data(:,U);
sz = length(xi);
yi = zeros(sz,1);
for j=1:1:sz
    yi(j) = log(ui(j)/ui(1));
end
disp('Finished.');



        
        
        
        
% toRami = DataTable2(2+3*25);        
% for i= 1:1:100
%     toRami.AddRow();
%     toRami.GetLast().SetValueAt(1,i);
%     toRami.GetLast().SetValueAt(2,cells.alpha);
%     cells.numOfReps = 0;
%     disp(cells.alpha);
%     for j= 1:1:n0
%         rng(CRN+j)
%         cells.RunOnce;
%         toRami.SetValueAt(3+3*(j-1),cells.CalcMuExpected());
%         toRami.SetValueAt(4+3*(j-1),cells.CalcMuFitted().b);
%         toRami.SetValueAt(5+3*(j-1),cells.R2squared());    
%     end
% end