clc;
format shortG;
addpath("MyClasses");
addpath("Results/Fixed Alpha");
%-------------------
%Stage 1: Clean Page
%-------------------
clear;
close all;
if(length(findall(0))>1)
    delete(findall(0));
end
pwd = PlayWithData();
pwd.NewFigure();

%-------------------------
%Stage 2: Load Sim results
%-------------------------
load('OptFixedAlpha.mat'); %OptFixedAlpha
howManySimVsTime = n0;
howManyGrowths = n0;

%------------------------------------------
%Stage 3: All Plot Actions - Take From Here
%------------------------------------------
            % -------------------
            % Option 1: Line Plot
            % -------------------
            % pwd.ChangeLineWidth(3);
            % pwd.ChangeLineStyle(1); %1=Solid
            % pwd.ChangeLineColor('black');
            % pwd.Plot_xVy(x1,y1,'Quantity');

            % ---------------------
            % Option 2: ScatterPlot
            % ---------------------
            % pwd.ChangeScatterSize(100);
            % pwd.ChangeScatterWidth(1);
            % pwd.ChangeScatterColor('black');
            % pwd.ChangeScatterShape('o');
            % pwd.ScatterPlot_xVy(x1,y1,'Quantity');

            % -----------------------
            % Option 3: Vertical Line (2=200%)
            % -----------------------
            % pwd.ChangeVhLineStyle(2); %2=Dashed
            % pwd.ChangeVhLineWidth(1.5);
            % pwd.ChangeVhLineColor('magenta');
            % pwd.Plot_VerticalLine(xValue,2,"");

            % -------------------------
            % Option 4: Horizontal Line (2=200%)
            % -------------------------
            % pwd.ChangeVhLineStyle(2); %2=Dashed
            % pwd.ChangeVhLineWidth(1.5);
            % pwd.ChangeVhLineColor('magenta');
            % pwd.Plot_HorizontalLine(yValue,2);

            % --------------------------
            % Option 5: Turn to SemiLogY
            % --------------------------
            % pwd.Plot_TurnToSemiLogY();
            
            % --------------------------
            % Option 6: Turn to SemiLogX
            % --------------------------
            % pwd.Plot_TurnToSemiLogX();
            
            % --------------------
            % Option 7: Ratio Zoom
            % --------------------
            % maxX = max(dataSet(:,1));
            % maxY = max(dataSet(:,2));
            % pwd.SetMaxXMaxY(maxX*1.1,maxY*1.1);


%###############################
%-------- Test Number 1 --------
%-------- Test Number 1 --------
%-------- Test Number 1 --------
%###############################
%----------------------------
%Test 1: SimTime Vs. RealTime
%----------------------------
pwd.ChangeXlabel("realTime_{[sec]}");
pwd.ChangeYlabel("simTime_{[min]}");
pwd.ChangeTitle("SimTime Vs. RealTime");
for rep = 1:1:howManySimVsTime
    pwd.ClearFigure();
    oneRepDataArrU = GetOneRepDataArr(growthData,rep);
    x_realTime = oneRepDataArrU(:,RT);
    y_simTime = oneRepDataArrU(:,t);
    pwd.Plot_xVy(x_realTime,y_simTime,'time');
    pwd.SetMinMax_X(0,0.5);
    pwd.SetMinMax_Y(0,100);
    pause(1);
    pwd.SetMinMax_X(0,2.5);
    pwd.SetMinMax_Y(0,150);
    pause(1);
    maxSimTime = oneRepDataArrU(end,1);
    maxRealTime = max(oneRepDataArrU(:,6));
    pwd.SetMinMax_X(0,maxRealTime*1.1);
    pwd.SetMinMax_Y(0,maxSimTime*1.1);
    pwd.Plot_VerticalLine(40,1,""); %1=100%
    pause(2);
end

fprintf("Finished.\n")