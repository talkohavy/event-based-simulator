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
%----------------------------------------------
%Test 1: Calculate and plot Fitted Vs. Expected
%----------------------------------------------
maxSimTime = max(growthData(:,1));
maxUs = max(growthData(:,2));
pwd.SetMinMax_X(0,maxSimTime*1.3);
pwd.SetMinMax_Y(0,maxUs*1.3);
pwd.ChangeLineWidth(4);
pwd.ChangeXlabel("simTime_{[min]}");
pwd.ChangeYlabel("quantity_{[#]}");
pwd.ChangeTitle("Ribosome Count");
for rep = 1:1:howManyGrowths
    oneRepDataArrU = GetOneRepDataArr(growthData,rep);
    fprintf('-------------------\n')
    fprintf('Results of Rep: %.0f\n', rep)
    x_time = oneRepDataArrU(:,t);
    y_Us = oneRepDataArrU(:,U);
    y_Ps = oneRepDataArrU(:,P);
    y_Fs = oneRepDataArrU(:,F);
    %----------------------------
    %Part 1: Make rawData thinner
    %----------------------------
    stack = 1;
    a = 1;
    x_time_thinner = [];
    y_Us_thinner = [];
    for i=1:1:length(x_time)
        if (x_time(i) > stack*a)
            x_time_thinner(a) = x_time(i);
            y_Us_thinner(a) = y_Us(i);
            a = a + 1;
        end
    end
%     x_time_thinner = [  x_time(1:1000) ;
%                         x_time(1000:250:end)];
%     y_Us_thinner = [y_Us(1:1000) ;
%                     y_Us(1000:250:end)];
    %---------------------------
    %Part 2: Calculate mu fitted (& y fitted)
    %---------------------------
    res = pwd.CalcMuFitted(x_time,y_Us);
    muFitted = res.b;
    constant = res.a;
    fprintf("Mu fitted is: %.5f\n",muFitted);
    y_fitted = constant*exp(muFitted.*x_time);
    %-----------------------------
    %Part 3: Calculate mu expected (& y expected)
    %-----------------------------
    muExpcted = pwd.CalcMuExpected_Exp(alpha,tU);
    fprintf("Mu expected is: %.4f\n",muExpcted );
    y_expected = constant*exp(muExpcted.*x_time);
    pause(0.1);
    %------------------------------------------------------------------
    %Part 4: Plot mu fitted graph + mu expected graph + rawData results
    %------------------------------------------------------------------
    pwd.ClearFigure();
    %- Plot 1: Raw Data
    pwd.ChangeScatterColor('black');
    pwd.ScatterPlot_xVy(x_time_thinner,y_Us_thinner,'simulation');%150= dot size, 1= color black
    pwd.Plot_TurnToSemiLogY();
    %- Plot 2: Expected Theory
    pwd.ChangeLineWidth(6);
    pwd.ChangeLineColor('green');
    pwd.Plot_xVy(x_time,y_expected,'theory'); %3= color green
    %- Plot 3: Fitted Data
%     pwd.ChangeScatterColor('red');
%     pwd.ScatterPlot_xVy(x_time,y_fitted,'fittedData');%150= dot size, 1= color black

    
    pause(0.1);
end

fprintf("Finished.\n")