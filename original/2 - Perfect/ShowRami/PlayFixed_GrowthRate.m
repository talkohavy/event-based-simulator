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

%----------------------------------------------
%Stage 3: Define x/y labels, title & zoom level
%----------------------------------------------
pwd.ChangeXlabel("\alpha");
pwd.ChangeYlabel("\mu");
pwd.ChangeTitle("Ranged \alpha");
pwd.SetMinMax_X(0,1);
pwd.SetMinMax_Y(0,0.1);
%Regular Line CSS:
pwd.ChangeLineColor('black');
pwd.ChangeLineWidth(3);
pwd.ChangeLineStyle(1); %1=Solid
%Verticle/Horizontal Line CSS:
pwd.ChangeVhLineColor('blue');
pwd.ChangeVhLineWidth(2.5);
%Scatter CSS
pwd.ChangeScatterColor('black');
pwd.ChangeScatterSize(600);
pwd.ChangeScatterShape('o');
%Hard Reset:
% pwd.ResetStyles();

%###############################
%-------- Test Number 1 --------
%-------- Test Number 1 --------
%-------- Test Number 1 --------
%###############################
%----------------------------------------------
%Test 1: Calculate and plot Fitted Vs. Expected
%----------------------------------------------
maxSimTime = max(growthData(:,1));
maxUs = max(growthData(:,2));
pwd.SetMinMax_X(0,maxSimTime*1.1);
pwd.SetMinMax_Y(0,maxUs*1.1);
pwd.ChangeLineWidth(4);
for rep = 1:1:howManyGrowths
    oneRepDataArrU = GetOneRepDataArr(growthData,rep);
    fprintf('-------------------\n')
    fprintf('Results of Rep: %.0f\n', rep)
    x_time = oneRepDataArrU(:,t);
    y_Us = oneRepDataArrU(:,U);
    y_Ps = oneRepDataArrU(:,P);
    y_Fs = oneRepDataArrU(:,F);
    pwd.ChangeXlabel("simTime_{[min]}");
    pwd.ChangeYlabel("quantity_{[#]}");
    pwd.ChangeTitle("Ribosome Count");
    %Part 2: Calculate mu fitted
    %---------------------------
    res = pwd.CalcMuFitted(x_time,y_Us);
    muFitted = res.b;
    constant = res.a;
    fprintf("Mu fitted is: %.5f\n",muFitted);
    y_fitted = constant*exp(muFitted.*x_time);
    %-----------------------------
    %Part 4: Calculate mu expected
    %-----------------------------
    muExpcted = pwd.CalcMuExpected_Exp(alpha,tU);
    fprintf("Mu expected is: %.4f\n",muExpcted );
    pause(0.1);
    %------------------------------------------------------------------
    %Part 5: Plot mu fitted graph + mu expected graph + rawData results
    %------------------------------------------------------------------
    pwd.ClearFigure();
    y_expected = constant*exp(muExpcted.*x_time);
    pwd.Plot_xVy(x_time,y_fitted,'fittedData');
    pwd.ChangeLineColor('blue');
    pwd.Plot_xVy(x_time,y_expected,'expctdData');
    pwd.ChangeLineColor('black');
    pwd.ScatterPlot_xVy(x_time,y_Us,'rawData');%150= dot size, 1= color black
    pause(0.1);
    %-----------------------
    %Part 9: Show food state
    %-----------------------
    pwd.Plot_xVy(x_time,y_Fs,'Fs');
    pause(0.2);
end

fprintf("Finished.\n")