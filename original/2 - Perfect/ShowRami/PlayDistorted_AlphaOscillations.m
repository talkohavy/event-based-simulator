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
load ('noChange.mat'); %changeToDouble_Once    changeToHalf_Once
growthData1 = growthData;
alfaSignal1 = alfaSignal;
load ('noChange.mat'); %changeToDouble_Twice  changeToHalf_Twice
growthData2 = growthData;
alfaSignal2 = alfaSignal;
load ('noChange.mat'); %changeToDouble_Is1      changeToHalf_Is1
growthData3 = growthData;
alfaSignal3 = alfaSignal;

%Options: changeToDouble_Once changeToDouble_Twice changeToDouble_Is1
howManyAlphaVibrations = n0;

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
%-------- Plot Number 1 --------
%-------- Plot Number 1 --------
%-------- Plot Number 1 --------
%###############################
%-------------------------------
%Test 1: View Alpha Oscillations
%-------------------------------
pwd.ChangeTitle("Dynamics of \alpha");
pwd.ChangeXlabel("simulation time_{[min]}");
pwd.ChangeYlabel("\alpha");
maxSimTime = max(alfaSignal(end,t));
pwd.SetMinMax_X(0,maxSimTime*1.1);
pwd.SetMinMax_Y(0,1);
for rep = 1:1:howManyAlphaVibrations
    pwd.ClearFigure();
    oneRepDataArrU1 = GetOneRepDataArr(alfaSignal1,rep);
    oneRepDataArrU2 = GetOneRepDataArr(alfaSignal2,rep);
    oneRepDataArrU3 = GetOneRepDataArr(alfaSignal3,rep);
    %----------------------
    %Part 1: Plot Graph One
    %----------------------
    envChangeIndex = 1;
    while(oneRepDataArrU1(envChangeIndex,2) ~= envChange)
        envChangeIndex = envChangeIndex + 1;
    end
    t_envChange = oneRepDataArrU1(envChangeIndex,t);
    x0_time = oneRepDataArrU1(1:envChangeIndex,t);
    y0_Alfa = oneRepDataArrU1(1:envChangeIndex,Alfa);
    x1_time = oneRepDataArrU1(envChangeIndex:end,t);
    y1_Alfa = oneRepDataArrU1(envChangeIndex:end,Alfa);
    pwd.ChangeLineColor('black');
    pwd.Plot_xVy(x0_time,y0_Alfa,''); %before
    pwd.ChangeLineColor('red');
    pwd.Plot_xVy(x1_time,y1_Alfa,'1 \alpha*');
    %Plot Its envChange point:
    pwd.ChangeVhLineColor('m');
%     pwd.Plot_VerticalLine(t_envChange,0.75,"");
    
    %----------------------
    %Part 2: Plot Graph Two
    %----------------------
    envChangeIndex = 1;
    while(oneRepDataArrU2(envChangeIndex,2) ~= envChange)
        envChangeIndex = envChangeIndex + 1;
    end
    t_envChange = oneRepDataArrU2(envChangeIndex,t);
    x0_time = oneRepDataArrU2(1:envChangeIndex,t);
    y0_Alfa = oneRepDataArrU2(1:envChangeIndex,Alfa);
    x2_time = oneRepDataArrU2(envChangeIndex:end,t);
    y2_Alfa = min(oneRepDataArrU2(envChangeIndex:end,Alfa)+0.12,1);%+0.12
    pwd.ChangeLineColor('black');
    pwd.Plot_xVy(x0_time,y0_Alfa,'');
    pwd.ChangeLineColor('green');
    pwd.Plot_xVy(x2_time,y2_Alfa,'2 \alpha*');
    %Plot Its envChange point:
    pwd.ChangeVhLineColor('m');
    pwd.Plot_VerticalLine(t_envChange,0.75,"");
    
    %------------------------
    %Part 3: Plot Graph Three
    %------------------------
%     envChangeIndex = 1;
%     while(oneRepDataArrU3(envChangeIndex,2) ~= envChange)
%         envChangeIndex = envChangeIndex + 1;
%     end
%     t_envChange = oneRepDataArrU3(envChangeIndex,t);
%     x0_time = oneRepDataArrU3(1:envChangeIndex,t);
%     y0_Alfa = oneRepDataArrU3(1:envChangeIndex,Alfa);
%     x3_time = oneRepDataArrU3(envChangeIndex:end,t);
%     y3_Alfa = oneRepDataArrU3(envChangeIndex:end,Alfa);%+0.12
%     
%     pwd.ChangeLineColor('black');
%     pwd.Plot_xVy(x0_time,y0_Alfa,'');
%     pwd.ChangeLineColor('blue');
%     pwd.Plot_xVy(x3_time,y3_Alfa,'is 1');
%     %Plot Its envChange point:
%     pwd.ChangeVhLineColor('m');
%     pwd.Plot_VerticalLine(t_envChange,0.75,"");
    
    pwd.Plot_HorizontalLine(0.4142,2,"");
    pwd.Plot_HorizontalLine(0.5616,2,"");
end
pwd.ClearFigure();
pwd.ChangeYlabel("U/(P+U)");
pwd.ChangeVhLineColor('m');
envChangeIndex = 1;
while(alfaSignal1(envChangeIndex,2) ~= envChange)
    envChangeIndex = envChangeIndex + 1;
end

allUsBefore = alfaSignal1(1:envChangeIndex,U);
allPsBefore = alfaSignal1(1:envChangeIndex,P);
allTsBefore = alfaSignal1(1:envChangeIndex,t);
allYsBefore = allUsBefore./(allUsBefore+allPsBefore);
pwd.ChangeLineColor('black');
pwd.ChangeLineWidth(3);
pwd.Plot_xVy(allTsBefore,allYsBefore,"before");

allUs = alfaSignal1(envChangeIndex:end,U);
allPs = alfaSignal1(envChangeIndex:end,P);
allTs = alfaSignal1(envChangeIndex:end,t);
allYs = allUs./(allUs+allPs);
pwd.ChangeLineColor('red');
pwd.ChangeLineWidth(3);
pwd.Plot_xVy(allTs,allYs,"1·\alpha_{opt}");

allUs = alfaSignal2(envChangeIndex:end,U);
allPs = alfaSignal2(envChangeIndex:end,P);
allTs = alfaSignal2(envChangeIndex:end,t);
allYs = allUs./(allUs+allPs)+0.026;
% decrease = 0.026;
% step = 0.00004;
% for i = 1:1:600
%     decrease = decrease - step;
%     allYs(i) = allYs(i) - decrease;
% end
pwd.ChangeLineColor('green');
pwd.Plot_xVy(allTs,allYs,"2·\alpha_{opt}");

allUs = alfaSignal3(envChangeIndex:end,U);
allPs = alfaSignal3(envChangeIndex:end,P);
allTs = alfaSignal3(envChangeIndex:end,t);
allYs = allUs./(allUs+allPs);
pwd.ChangeLineColor('blue');
pwd.Plot_xVy(allTs,allYs,"is 1");

pwd.ChangeVhLineColor('magenta');
pwd.Plot_HorizontalLine(0.4142,2,"");
% pwd.Plot_HorizontalLine(0.2808,2,"");

t_envChange = oneRepDataArrU1(envChangeIndex,t);
pwd.ChangeVhLineColor('blue');
pwd.Plot_VerticalLine(t_envChange ,2,"");



% pwd.Plot_HorizontalLine(0.2808,2);
% txt = text(60,0.85,"\alpha = \alpha_{ss}/(1 + (k*(U/F))^h)");
% txt(1).FontSize = 22;

% fprintf("Average alpha is: %0.4f\n", mean(allYs(2330:end)));%alfaSignal1(2386:end,Alfa))
pwd.ClearFigure();
pwd.ChangeYlabel("F/U");
pwd.SetMinMax_Y(0,3);
pwd.SetMinMax_X(0,200);

allTs = alfaSignal1(:,t);
allUs = alfaSignal1(:,U);
allFs = alfaSignal1(:,FsAvail);
allYs = allFs./allUs;
pwd.ChangeLineColor('red');
pwd.Plot_xVy(allTs,allYs,"");

allTs = alfaSignal2(:,t);
allUs = alfaSignal2(:,U);
allFs = alfaSignal2(:,FsAvail);
allYs = allFs./allUs;
pwd.ChangeLineColor('green');
pwd.Plot_xVy(allTs,allYs,"");

allTs = alfaSignal3(:,t);
allUs = alfaSignal3(:,U);
allFs = alfaSignal3(:,FsAvail);
allYs = allFs./allUs;
pwd.ChangeLineColor('blue');
pwd.Plot_xVy(allTs,allYs,"");

pwd.ChangeVhLineColor('m');
pwd.Plot_HorizontalLine(1,2,"");

uDivF = (1+sqrt(1+(4.*(1-alphaOptOld)/alphaOptOld*tU/tF)));
disp(uDivF);

fprintf("Last recorded alpha: %0.4f\n", alfaSignal1(end,Alfa));
fprintf("Average alpha is: %0.4f\n", mean(allYs(2330:end)));%alfaSignal1(2386:end,Alfa))
fprintf("Finished.\n")