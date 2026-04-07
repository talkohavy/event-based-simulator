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
t=1; U=2; P=3; F=4; Alfa=5; AlfaSS=6; RT=7; Rep=8;

%-------------------------
%Stage 2: Load Sim results
%-------------------------
load('data.mat');
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
%Test 2: Calculate and plot Fitted Vs. Expected
%----------------------------------------------
pwd.SetMinMax_X(0,200);
pwd.SetMinMax_Y(0,10);
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
    %--------------------------
    %Part 1: Proof of linearity
    %--------------------------
    %A: Create y_fittedLine from observed and plot it
    pwd.ClearFigure();
    pwd.ChangeTitle("Slope as \mu");
    pwd.ChangeXlabel("simTime_{[min]}");
    pwd.ChangeYlabel("ln(U(t)/U(0))"); % 
    y_fittedLine = y_Us; %array is dumb in matlab
    U0 = y_fittedLine(1);
    for j=1:1:length(y_fittedLine)
        Uj = y_fittedLine(j);
        y_fittedLine(j) = log(Uj/U0);
    end
    pwd.Plot_xVy(x_time,y_fittedLine,'fittedLine');
    pause(0.1);
    %B: Create exptd Line and plot it.
    muExpcted = pwd.CalcMuExpected_Exp(alpha,tU);
    fprintf("Mu expected is: %.4f\n",muExpcted );
    y_expectedLine = muExpcted.*x_time;
    pwd.ChangeLineColor('m');
    pwd.Plot_xVy(x_time,y_expectedLine,'expctdLine');
    pwd.ChangeLineColor('black');
    pause(0.1);
    %C: Print best shipua (last dot)
    res = y_expectedLine(end)/x_time(end);
    fprintf('The linear shipua is: %0.5f\n\n',res);
    pause(0.1);
    %----------------------------------------------------
    %Part 8: R2Squared - Linear Regression on fitted line 
    %----------------------------------------------------
    %A: Create y_fittedLine from observed and plot it
    y_fittedLine = y_Us; %array is dumb in matlab
    U0 = y_fittedLine(1);
    for j=1:1:length(y_fittedLine)
        Uj = y_fittedLine(j);
        y_fittedLine(j) = log(Uj/U0);
    end
    R2Square = pwd.R2squared(x_time,y_fittedLine); %5= color magenta
    %-----------------------
    %Part 9: Show food state
    %-----------------------
    pwd.Plot_xVy(x_time,y_Fs,'Fs');
    pause(0.2);
end

fprintf("Finished.\n")