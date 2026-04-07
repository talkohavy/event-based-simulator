clc;
clear;
close all;
format shortG;
if(length(findall(0))>1)
    delete(findall(0));
end
addpath("MyClasses");

%----------------------------
%Stage 1: Create PlayWithData
%----------------------------
pwd = PlayWithData();
pwd.NewFigure();
n0 = 10;
t=1; U=2;

%-------------------------
%Stage 2: Load Sim results
%-------------------------
    %---------------------------
    %Distribution 1: Exponential
    %---------------------------
% load 'diffAlphasExp.mat'
% tU=6; tP=6; tF=6;

    %-----------------------
    %Distribution 2: Uniform
    %-----------------------
load 'diffAlphasFlat.mat'
unifMin = 3;
unifMax = 9;

%--------------------------------------
%Stage 3: Calculate Left Theoretical Mu
%--------------------------------------
y_expctdLeftMuVec = zeros(1,4);
curAlfa = -0.05;
for i = 1:1:10
    curAlfa = curAlfa + 0.05;
    
    %---------------------------
    %Distribution 1: Exponential
    %---------------------------
%     y_expctdLeftMuVec(i) = pwd.CalcMuExpected_Exp(curAlfa,tU);  %exponent distribution
    
    %-----------------------
    %Distribution 2: Uniform
    %-----------------------
    y_expctdLeftMuVec(i) = pwd.CalcMuExpected_Unif(unifMin,unifMax,curAlfa);  %flat distribution

end
x_alfaLeft = 0.00:0.05:curAlfa;

%---------------------------------------
%Stage 4: Calculate Right Theoretical Mu
%---------------------------------------
howMany = 14;
y_expctdRightMuVec = zeros(1,howMany);
alpha = 0.35;
x_alfaRight = alpha:0.05:1;
muExpected = NaN;
for i = 1:1:howMany
    p = [1-alpha 1 -1];
    r = roots(p);
    for j = 1:1:length(r)
        %---------------------------
        %Distribution 1: Exponential
        %---------------------------
        %Assumption: tF = tP
%         if (r(j)>=-0.0001 && r(j)<=1.0001)
%             muExpected = (1-r(j))/(r(j)*tP); %exponent distribution
%         end
        
        %-----------------------
        %Distribution 2: Uniform
        %-----------------------
        % STEP 1: The non-dependant.
        syms mu
        % STEP 2: Left Side (The Equation)
        a = unifMin;
        b = unifMax;
        leftSide = (exp(-a*mu)-exp(-b*mu))/(mu*(b-a));
        % STEP 3: Right Side
        rightSide = r(j);
        % STEP 4: Solve by MATLAB'S Function.
        muExpected = double(vpasolve(leftSide == rightSide,mu));
        
        %-------------------
        %Save theoretical mu
        %-------------------
        if (~isnan(muExpected))
            if (muExpected > -0.001 && muExpected < 1.001)
                y_expctdRightMuVec(i) = muExpected;
            end
        end
    end
    alpha = alpha + 0.05;
end
y_expctdRightMuVec(howMany) = 0;

%------------------
%Stage 5: Run Tests
%------------------
if (questdlg("Run Plots?") == "Yes")    
    pwd.ClearFigure();
    x_alfa = 0.05:0.05:1;
    y_fittedMu = alfaMuArr(11,:);
    
    %--------------------------
    %Part 1: Setup Axis & stuff
    %--------------------------
    pwd.ChangeXlabel("\alpha");
    pwd.ChangeYlabel("\mu");
    pwd.ChangeTitle("Uniform Distribution");
    pwd.SetMaxXMaxY(1,0.1);
    
    %------------------------------------
    %Part 2: Scatter Plot rawData results
    %------------------------------------
    pwd.ScatterPlot_xVy(x_alfa,y_fittedMu,150,1,'rawData');%150= dot size, 1= color black
    
    %-------------------------------------------
    %Part 3: Line Plot Left Theoretical Equation
    %-------------------------------------------
    pwd.Plot_xVy(x_alfaLeft,y_expctdLeftMuVec,3,1,''); %3= color green
    
    %--------------------------------------------
    %Part 4: Line Plot Right Theoretical Equation
    %--------------------------------------------
    pwd.Plot_xVy(x_alfaRight,y_expctdRightMuVec,3,1,''); %3= color green
    
    %-----------------------------------------
    %Part 5: Plot Verticle Line where the meet
    %-----------------------------------------
    pwd.Plot_VerticalLine(sqrt(2)-1,0.75,4);
end


%     alfaMuArr = zeros(11,20);
%     b=16;
%     for rep = 1:1:n0
%         %---------------------------
%         %Part 1: Calculate mu fitted
%         %---------------------------
%         oneRepDataArrU = GetOneRepDataArr(growthData_080,rep);
%         x_time = oneRepDataArrU(:,t);
%         y_Us = oneRepDataArrU(:,U);
%         res = pwd.CalcMuFitted(x_time,y_Us);
%         muFitted = res.b;
%         
%         alfaMuArr(rep,b) = muFitted;
%     end
%     alfaMuArr(11,b) = mean(alfaMuArr(1:10,b));
% save 'diffAlphas.mat' alfaMuArr