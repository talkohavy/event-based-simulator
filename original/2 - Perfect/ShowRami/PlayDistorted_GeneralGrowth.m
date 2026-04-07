clc;
format shortG;
addpath("MyClasses");
addpath("Results/Oscillated Alpha/Fixed K/TwoAlphaOptDistorted");
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
load ('changeToDouble_Once.mat');
growthData1 = growthData;
alfaSignal1 = alfaSignal;
load ('changeToDouble_Twice.mat');
growthData2 = growthData;
alfaSignal2 = alfaSignal;
load ('changeToDouble_Is1.mat');
growthData3 = growthData;
alfaSignal3 = alfaSignal;


%Options: changeToDouble_Once changeToDouble_Twice changeToDouble_Is1
howManySimVsTime = 0;
howManyGrowths = n0;
howManySpecials = n0;
howManyAlphaVibrations = n0;


%----------------------------------------------
%Stage 3: Define x/y labels, title & zoom level
%----------------------------------------------
pwd.ChangeXlabel("time");
pwd.ChangeYlabel("Cost");
pwd.ChangeTitle("Regular Plot");
%Line:
pwd.ChangeLineColor('black');
pwd.ChangeLineWidth(3);
pwd.ChangeLineStyle(1); %1=Solid
%Verticle/Horizontal:
pwd.ChangeVhLineColor('magenta');
pwd.ChangeVhLineStyle(2); %2=Dashed
pwd.ChangeVhLineWidth(1.5);
%Scatter:
pwd.ChangeScatterColor('black');
pwd.ChangeScatterSize(100);
pwd.ChangeScatterWidth(1);
pwd.ChangeScatterShape('o');
%Hard Reset:
% pwd.ResetStyles();
% maxSimTime = oneRepDataArrU(end,1);
% maxAlfa = max(oneRepDataArrU(:,Alfa));

%------------------------------------------
%Stage 4: All Plot Actions - Take From Here
%------------------------------------------
            % -------------------
            % Option 1: Line Plot
            % -------------------
            % pwd.Plot_xVy(x1,y1,'Quantity');

            % ---------------------
            % Option 2: ScatterPlot
            % ---------------------
            % pwd.ScatterPlot_xVy(x1,y1,'Quantity');

            % -----------------------
            % Option 3: Vertical Line
            % -----------------------
            % pwd.Plot_VerticalLine(xValue,height_0_1,""); %1=100%

            % -------------------------
            % Option 4: Horizontal Line
            % -------------------------
            % pwd.Plot_HorizontalLine(yValue,height_0_1); %1=100%

            % --------------------------
            % Option 5: Turn to SemiLogY
            % --------------------------
            % pwd.Plot_TurnToSemiLogY();
            
            % --------------------------
            % Option 6: Turn to SemiLogX
            % --------------------------
            % pwd.Plot_TurnToSemiLogX();

%###############################
%-------- Plot Number 1 --------
%-------- Plot Number 1 --------
%-------- Plot Number 1 --------
%###############################
%-------------------------------
%Test 3: SimTime Vs. RealTime
%-------------------------------
pwd.ChangeTitle("SimTime Vs. RealTime");
pwd.ChangeXlabel("realTime_{[sec]}");
pwd.ChangeYlabel("simTime_{[min]}");
for rep = 1:1:howManySimVsTime
    oneRepDataArrU = GetOneRepDataArr(growthData,rep);
    x_realTime = oneRepDataArrU(:,RT);
    y_simTime = oneRepDataArrU(:,t);
    yChange = oneRepDataArrU(uChange - 3,t);
    pwd.Plot_xVy(x_realTime,y_simTime,'time');
    maxSimTime = oneRepDataArrU(end,1);
    maxRealTime = max(oneRepDataArrU(:,RT));
    pwd.SetMinMax_X(0,maxRealTime);
    pwd.SetMinMax_Y(0,maxSimTime);
    pwd.Plot_HorizontalLine(yChange,5); %5=500% width
    pwd.SetMinMax_X(0,0.5);
    pwd.SetMinMax_Y(0,100);
    pause(1);
    pwd.SetMinMax_X(0,2.5);
    pwd.SetMinMax_Y(0,150);
    pause(1);
    maxSimTime = oneRepDataArrU(end,1);
    maxRealTime = max(oneRepDataArrU(:,RT));
    pwd.SetMinMax_X(0,maxRealTime*1.1);
    pwd.SetMinMax_Y(0,maxSimTime*1.1);
    pause(1);
    prompt = 'Press enter to continue...';
    input(prompt);
    pwd.ClearFigure();
end

%###############################
%-------- Plot Number 2 --------
%-------- Plot Number 2 --------
%-------- Plot Number 2 --------
%###############################
%------------------------------------
%Test 4: Calculate and plot mu fitted
%------------------------------------
pwd.ChangeXlabel("simTime_{[min]}");
pwd.ChangeYlabel("quantity_{[#]}");
pwd.ChangeTitle("Ribosome Count");
maxSimTime = max(growthData(:,1));
for rep = 1:1:howManyGrowths
    maxUs = max(growthData1(:,2)); %Doesn't matter who!
    pwd.SetMinMax_X(0,maxSimTime*1.2);
    pwd.SetMinMax_Y(0,maxUs*1.2);
    %----------------------
    %Part 1: Plot Graph One
    %----------------------
    oneRepDataArrU1 = GetOneRepDataArr(growthData1,rep);
    x0_time = oneRepDataArrU1(1:envChange - 3,t);
    y0_Us = oneRepDataArrU1(1:envChange - 3,U);
    x1_time = oneRepDataArrU1(envChange - 3:end,t);
    y1_Us = oneRepDataArrU1(envChange - 3:end,U);
    pwd.ChangeLineColor('black');
    pwd.Plot_xVy(x0_time,y0_Us,'before');
    pwd.ChangeLineColor('red');
    pwd.Plot_xVy(x1_time,y1_Us,'1 \alpha*');
    %Plot Its envChange point:
    x1Change = oneRepDataArrU1(envChange - 3,t);
    pwd.ChangeVhLineStyle(2); %2=Dashed
    pwd.ChangeVhLineColor('magenta');
    pwd.Plot_VerticalLine(x1Change,0.85,"");
    
    %----------------------
    %Part 2: Plot Graph Two
    %----------------------
    oneRepDataArrU2 = GetOneRepDataArr(growthData2,rep);
    x0_time = oneRepDataArrU2(1:envChange - 3,t);
    y0_Us = oneRepDataArrU2(1:envChange - 3,U);
    x2_time = oneRepDataArrU2(envChange - 3:end,t);
    y2_Us = oneRepDataArrU2(envChange - 3:end,U);
    pwd.ChangeLineColor('black');
    pwd.Plot_xVy(x0_time,y0_Us,'');
    pwd.ChangeLineColor('green');
    pwd.Plot_xVy(x2_time,y2_Us,'2 \alpha*');
    %Plot Its envChange point:
    x2Change = oneRepDataArrU2(envChange - 3,t);
    pwd.ChangeVhLineStyle(2); %2=Dashed
    pwd.ChangeVhLineColor('magenta');
    pwd.Plot_VerticalLine(x2Change,0.85,"");
    
    %------------------------
    %Part 3: Plot Graph Three
    %------------------------
    oneRepDataArrU3 = GetOneRepDataArr(growthData3,rep);
    x0_time = oneRepDataArrU3(1:envChange - 3,t);
    y0_Us = oneRepDataArrU3(1:envChange - 3,U);
    x3_time = oneRepDataArrU3(envChange - 3:end,t);
    y3_Us = oneRepDataArrU3(envChange - 3:end,U);
    pwd.ChangeLineColor('black');
    pwd.Plot_xVy(x0_time,y0_Us,'');
    pwd.ChangeLineColor('blue');
    pwd.Plot_xVy(x3_time,y3_Us,'is 1');
    %Plot Its envChange point:
    x3Change = oneRepDataArrU3(envChange - 3,t);
    pwd.ChangeVhLineStyle(2); %2=Dashed
    pwd.ChangeVhLineColor('magenta');
    pwd.Plot_VerticalLine(x3Change,0.85,"");
    
    %------------------------
    %Part 4: Plot Finish Line
    %------------------------
    finishLine = min([x1_time(end), x2_time(end), x3_time(end)]);
    pwd.ChangeVhLineStyle(3); %1=Solid
    pwd.ChangeVhLineColor('black');
    pwd.Plot_VerticalLine(finishLine,1,"");
    
    %---------------------------
    %Part 2: Calculate mu fitted
    %---------------------------
    res = pwd.CalcMuFitted(x1_time,y1_Us);
    muFitted1 = res.b;
    constant1 = res.a;
    fprintf("Mu fitted of Once is: %.4f\n",muFitted1);
    
    res = pwd.CalcMuFitted(x2_time,y2_Us);
    muFitted2 = res.b;
    constant2 = res.a;
    fprintf("Mu fitted of Twice is: %.4f\n",muFitted2);
    
    res = pwd.CalcMuFitted(x3_time,y3_Us);
    muFitted3 = res.b;
    constant3 = res.a;
    fprintf("Mu fitted of 1 is: %.4f\n",muFitted3);
end

fprintf("Finished.\n")