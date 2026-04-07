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
load ('changeToDouble_Once.mat'); %changeToDouble_Once
growthData1 = growthData;
alfaSignal1 = alfaSignal;
load ('changeToDouble_Twice.mat');  %changeToDouble_Twice
growthData2 = growthData;
alfaSignal2 = alfaSignal;
load ('changeToDouble_Is1.mat');  %changeToDouble_Is1
growthData3 = growthData;
alfaSignal3 = alfaSignal;

howManySpecials = n0;
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
% maxAlfa = max(oneRepDataArrU(:,5));

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
            
            % --------------------
            % Option 7: Ratio Zoom
            % --------------------
            % maxX = max(dataSet(:,1));
            % maxY = max(dataSet(:,2));
            % pwd.SetMaxXMaxY(maxX*1.1,maxY*1.1);


%###############################
%-------- Plot Number 1 --------
%-------- Plot Number 1 --------
%-------- Plot Number 1 --------
%###############################
%------------------------------------
%Test 4: Calculate (1/t)*log(Ut/U0)
%------------------------------------
pwd.ChangeXlabel("simTime_{[min]}");
pwd.ChangeYlabel("(1/t)*log(Ut/U0)");
pwd.ChangeTitle("Growth Rate");
maxSimTime = max(growthData(:,1));
pwd.SetMinMax_X(0,200);
pwd.SetMinMax_Y(0,0.2);
for rep = 1:1:howManySpecials
    pwd.ClearFigure();
    %----------------------
    %Part 1: Plot Graph One
    %----------------------
    oneRepDataArrU1 = GetOneRepDataArr(growthData1,rep);
    x1_time = oneRepDataArrU1(1:end,t);
    y1_Us = oneRepDataArrU1(1:end,U);
    y1_Special = zeros(length(x1_time),1);
    for i=1:1:length(x1_time)
        ti = x1_time(i);
        Ui = y1_Us(i);
        value = log(Ui/4)/ti;
        y1_Special(i) = value;
    end
    pwd.ChangeLineColor('red');
    pwd.Plot_xVy(x1_time,y1_Special,'1 \alpha*');
    %Plot Its envChange point:
    tChange = oneRepDataArrU1(envChange-3,t);
    pwd.ChangeVhLineStyle(2); %2=Dashed
    pwd.ChangeVhLineColor('magenta');
    pwd.Plot_VerticalLine(tChange,0.85,"");
    %----------------------
    %Part 2: Plot Graph Two
    %----------------------
    oneRepDataArrU2 = GetOneRepDataArr(growthData2,rep);
    x2_time = oneRepDataArrU2(1:end,t);
    y2_Us = oneRepDataArrU2(1:end,U);
    y2_Special = zeros(1,length(x2_time));
    for i=1:1:length(x2_time)
        ti = x2_time(i);
        Ui = y2_Us(i);
        value = log(Ui/4)/ti;
        y2_Special(i) = value;
    end
    pwd.ChangeLineColor('green');
    pwd.Plot_xVy(x2_time,y2_Special,'2 \alpha*');
    %Plot Its envChange point:
%     tChange = oneRepDataArrU2(envChange-3,t);
%     pwd.ChangeVhLineStyle(2); %2=Dashed
%     pwd.ChangeVhLineColor('magenta');
%     pwd.Plot_VerticalLine(tChange,0.85,"");
    
    
    %------------------------
    %Part 3: Plot Graph Three
    %------------------------
    oneRepDataArrU3 = GetOneRepDataArr(growthData3,rep);
    x3_time = oneRepDataArrU3(1:end,t);
    y3_Us = oneRepDataArrU3(1:end,U);
    y3_Special = zeros(1,length(x3_time));
    for i=1:1:length(x3_time)
        ti = x3_time(i);
        Ui = y3_Us(i);
        value = log(Ui/4)/ti;
        y3_Special(i) = value;
    end
    pwd.ChangeLineColor('blue');
    pwd.Plot_xVy(x3_time,y3_Special,'is 1');
    %Plot Its envChange point:
%     tChange = oneRepDataArrU3(envChange-3,t);
%     pwd.ChangeVhLineStyle(2); %2=Dashed
%     pwd.ChangeVhLineColor('magenta');
%     pwd.Plot_VerticalLine(tChange,0.85,"");
    
    %------------------------
    %Part 4: Plot Finish Line
    %------------------------
    finishLine = min([x1_time(end), x2_time(end), x3_time(end)]);
    pwd.ChangeVhLineStyle(3); %1=Solid
    pwd.ChangeVhLineColor('black');
    pwd.Plot_VerticalLine(finishLine,1,"");
end
fprintf("Finished.\n")