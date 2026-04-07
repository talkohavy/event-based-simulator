clc;
format shortG;
addpath("MyClasses");
addpath("Results/Fixed Alpha/");
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
t=1; U=2;

%-------------------------
%Stage 2: Load Sim results
%-------------------------
load('RangeRun_Both.mat');

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

            
%--------------------------
%Stage 4: Define Axes Names
%--------------------------
%x Axis & y Axis:
pwd.ChangeXlabel("\alpha");
pwd.ChangeYlabel("\mu_{[1/min]}");
pwd.ChangeTitle("Ranged \alpha");

%------------------------------------
%Stage 5: Scatter Plot rawData results
%------------------------------------
pwd.SetMinMax_X(0,1);
pwd.SetMinMax_Y(0,0.1);
pwd.ChangeScatterWidth(4);
pwd.ChangeScatterSize(600);
%------------------------------
pwd.ChangeScatterColor('blue');
pwd.ChangeScatterShape('o');
% pwd.ScatterPlot_xVy(x_fullAlpha,y_fullMuFitted_exp,'raw data - exp');
pwd.ChangeScatterColor('red');
pwd.ChangeScatterShape('s');
pwd.ScatterPlot_xVy(x_fullAlpha,y_fullMuFitted_Flat,'raw data - unif');

%-------------------------------------------
%Stage 6: Line Plot Left Theoretical Equation
%-------------------------------------------
pwd.ChangeLineColor('black');
pwd.ChangeLineWidth(2);
pwd.ChangeLineStyle(1); %1=Solid
% pwd.Plot_xVy(x_leftHalfAlpha,y_leftHalfMuExpctd_exp,'');
pwd.Plot_xVy(x_leftHalfAlpha,y_leftHalfMuExpctd_Flat,'');

%--------------------------------------------
%Stage 7: Line Plot Right Theoretical Equation
%--------------------------------------------
% pwd.Plot_xVy(x_rightHalfAlpha,y_rightHalfMuExpctd_exp,'theory');
pwd.Plot_xVy(x_rightHalfAlpha,y_rightHalfMuExpctd_Flat,'');

%-----------------------------------------
%Stage 8: Plot Verticle Line where the meet
%-----------------------------------------
pwd.ChangeVhLineColor('magenta');
pwd.ChangeVhLineWidth(2.5);
pwd.Plot_VerticalLine(sqrt(2)-1,0.75,"");

txt = text(0.95,-0.008,"\alpha");
pwd.ChangeXlabel("");
txt(1).FontSize = 60;

% xticks([0,0.1,0.20,0.30,0.40,0.50,0.60,0.70,0.80,0.90,1])
% xticklabels({'0','10%','20%','30%','40%','50%','60%','70%','80%','90%','100%'})