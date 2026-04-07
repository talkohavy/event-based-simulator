clc;
%clear;
close all;
format shortG;
if(length(findall(0))>1)
    delete(findall(0));
end
addpath("MyClasses")
%-------------------------
%Stage 1: Load Sim results
%-------------------------
load 'Model 1 - Workspace.mat'

%----------------------------
%Stage 2: Create PlayWithData
%----------------------------
pwd = PlayWithData();


%------------------
%Stage 3: Run Tests
%------------------
if (questdlg("Run Plots?") == "Yes")    
    %Explanation: After sim you'll have growthData and the function
    %SetRep, which accepts an array and the number of rep. SetRep returns
    %a results array of the chosen Rep.
    t=1; U=2; P=3; F=4; Alfa=5; RT=6; Rep=7;
    pwd.NewFigure();
    if (~isHill)
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %@@@@@@@@@@@@------------  Fixed Alpha  ---------------@@@@@@@@@@@@
        %@@@@@@@@@@@@------------  Fixed Alpha  ---------------@@@@@@@@@@@@
        %@@@@@@@@@@@@------------  Fixed Alpha  ---------------@@@@@@@@@@@@
        %@@@@@@@@@@@@------------  Fixed Alpha  ---------------@@@@@@@@@@@@
        %@@@@@@@@@@@@------------  Fixed Alpha  ---------------@@@@@@@@@@@@
        %@@@@@@@@@@@@------------  Fixed Alpha  ---------------@@@@@@@@@@@@
        %@@@@@@@@@@@@------------  Fixed Alpha  ---------------@@@@@@@@@@@@
        %@@@@@@@@@@@@------------  Fixed Alpha  ---------------@@@@@@@@@@@@
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        
        %###############################
        %-------- Test Number 1 --------
        %-------- Test Number 1 --------
        %-------- Test Number 1 --------
        %###############################
        %----------------------------
        %Test 1: SimTime Vs. RealTime
        %----------------------------
        for rep = 1:1:1%n0
            pwd.ClearFigure();
            oneRepDataArrU = GetOneRepDataArr(growthData,rep);
            x_realTime = oneRepDataArrU(:,RT);
            y_simTime = oneRepDataArrU(:,t);
            pwd.ChangeXlabel("simTime_{[min]}");
            pwd.ChangeYlabel("realTime_{[sec]}");
            pwd.ChangeTitle("SimTime Vs. RealTime");
            pwd.Plot_xVy(x_realTime,y_simTime,1,1,'time');
            pwd.SetMaxXMaxY(0.5,100);
            pause(0.1);
            pwd.SetMaxXMaxY(2.5,150);
            pause(0.1);
            pwd.SetMaxXMaxY(220,200);
            pause(0.2);
        end
        
        %###############################
        %-------- Test Number 2 --------
        %-------- Test Number 2 --------
        %-------- Test Number 2 --------
        %###############################
        %----------------------------------------------
        %Test 2: Calculate and plot Fitted Vs. Expected
        %----------------------------------------------
        
        for rep = 1:1:n0
            pwd.ClearFigure();
            oneRepDataArrU = GetOneRepDataArr(growthData,rep);
            fprintf('-------------------\n')
            fprintf('Results of Rep: %.0f\n', rep)
            x_time = oneRepDataArrU(:,t);
            y_Us = oneRepDataArrU(:,U);
            y_Ps = oneRepDataArrU(:,P);
            y_Fs = oneRepDataArrU(:,F);
            %----------------------------
            %Part 1: Plot rawData results
            %----------------------------
            pwd.ChangeXlabel("simTime_{[min]}");
            pwd.ChangeYlabel("quantity_{[#]}");
            pwd.ChangeTitle("Ribosome Count");
            pwd.SetMaxXMaxY(300,8192);
            pwd.ScatterPlot_xVy(x_time,y_Us,150,1,'rawData');%150= dot size, 1= color black
            pause(0.1);
            %---------------------------
            %Part 2: Calculate mu fitted
            %---------------------------
            res = pwd.CalcMuFitted(x_time,y_Us);
            muFitted = res.b;
            constant = res.a;
            fprintf("Mu fitted is: %.5f\n",muFitted);
            pause(0.1);
            %----------------------------
            %Part 3: Plot mu fitted graph
            %----------------------------
            y_fitted = constant*exp(muFitted.*x_time);
            pwd.Plot_xVy(x_time,y_fitted,2,1,'fittedData'); %2= color blue
            pause(0.1);
            %-----------------------------
            %Part 4: Calculate mu expected
            %-----------------------------
            muExpcted = pwd.CalcMuExpected_Exp(alpha,tU);
            fprintf("Mu expected is: %.4f\n",muExpcted );
            pause(0.1);
            %------------------------------
            %Part 5: Plot mu expected graph
            %------------------------------
            y_expected = constant*exp(muExpcted.*x_time);
            pwd.Plot_xVy(x_time,y_expected,3,1,'expctdData'); %3= color green
            pause(0.1);
            %--------------------------
            %Part 6: Proof of linearity
            %--------------------------
            %A: Create y_fittedLine from observed and plot it
            pwd.ClearFigure();
            pwd.ChangeXlabel("simTime_{[min]}");
            pwd.ChangeYlabel("U(t)/U(0)"); %
            y_fittedLine = y_Us; %array is dumb in matlab
            U0 = y_fittedLine(1);
            for j=1:1:length(y_fittedLine)
                Uj = y_fittedLine(j);
                y_fittedLine(j) = log(Uj/U0);
            end
            pwd.SetMaxXMaxY(300,15);
            pwd.Plot_xVy(x_time,y_fittedLine,4,1,'fittedLine'); %4= color red
            pause(0.1);
            %B: Create exptd Line and plot it.
            y_expectedLine = muExpcted.*x_time;
            pwd.Plot_xVy(x_time,y_expectedLine,5,1,'expctdLine'); %5= color magenta
            pause(0.1);
            %C: Print best shipua (last dot)
            res = y_expectedLine(end)/x_time(end);
            fprintf('The linear shipua is: %0.5f\n',res);
            pause(1);
            %----------------------------------------------------
            %Part 7: R2Squared - Linear Regression on fitted line 
            %----------------------------------------------------
            %A: Create y_fittedLine from observed and plot it
            y_fittedLine = y_Us; %array is dumb in matlab
            U0 = y_fittedLine(1);
            for j=1:1:length(y_fittedLine)
                Uj = y_fittedLine(j);
                y_fittedLine(j) = log(Uj/U0);
            end
            R2Square = pwd.R2squared(x_time,y_fittedLine); %5= color magenta
            fprintf('The R2Square: %0.5f\n',R2Square(1));
            fprintf('The R2Square Adjusted: %0.5f\n',R2Square(2));
            %-----------------------
            %Part 8: Show food state
            %-----------------------
            pwd.SetMaxXMaxY(300,4096);
            pwd.Plot_xVy(x_time,y_Fs,1,1,'Fs');
            pause(2);
        end
    else
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %@@@@@@@@@@------------  oscillated Alpha  ---------------@@@@@@@@@
        %@@@@@@@@@@------------  oscillated Alpha  ---------------@@@@@@@@@
        %@@@@@@@@@@------------  oscillated Alpha  ---------------@@@@@@@@@
        %@@@@@@@@@@------------  oscillated Alpha  ---------------@@@@@@@@@
        %@@@@@@@@@@------------  oscillated Alpha  ---------------@@@@@@@@@
        %@@@@@@@@@@------------  oscillated Alpha  ---------------@@@@@@@@@
        %@@@@@@@@@@------------  oscillated Alpha  ---------------@@@@@@@@@
        %@@@@@@@@@@------------  oscillated Alpha  ---------------@@@@@@@@@
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        
        %###############################
        %-------- Test Number 3 --------
        %-------- Test Number 3 --------
        %-------- Test Number 3 --------
        %###############################
        %-------------------------------
        %Test 3: SimTime Vs. RealTime
        %-------------------------------
        for rep = 1:1:n0
            pwd.ClearFigure();
            oneRepDataArrU = GetOneRepDataArr(growthData,rep);
            x_realTime = oneRepDataArrU(:,RT);
            y_simTime = oneRepDataArrU(:,t);
            pwd.ChangeXlabel("simTime_{[min]}");
            pwd.ChangeYlabel("realTime_{[sec]}");
            pwd.ChangeTitle("SimTime Vs. RealTime");
            pwd.Plot_xVy(x_realTime,y_simTime,1,1,'time');
            pwd.SetMaxXMaxY(0.5,100);
            pause(0.1);
            pwd.SetMaxXMaxY(2.5,150);
            pause(0.1);
            pwd.SetMaxXMaxY(8,200);
            pause(0.3);
        end
        
        %###############################
        %-------- Test Number 4 --------
        %-------- Test Number 4 --------
        %-------- Test Number 4 --------
        %###############################
        %------------------------------------
        %Test 4: Calculate and plot mu fitted
        %------------------------------------
        for rep = 1:1:n0
            pwd.ClearFigure();
            oneRepDataArrU = GetOneRepDataArr(growthData,rep);
            x_time = oneRepDataArrU(:,t);
            y_Us = oneRepDataArrU(:,U);
            y_Ps = oneRepDataArrU(:,P);
            y_Fs = oneRepDataArrU(:,F);
            %----------------------------
            %Part 1: Plot rawData results
            pwd.ChangeXlabel("simTime_{[min]}");
            pwd.ChangeYlabel("quantity_{[#]}");
            pwd.ChangeTitle("Ribosome Count");
            pwd.SetMaxXMaxY(300,8192);
            pwd.Plot_xVy(x_time,y_Us,1,1,'Us');%1= Black Color, 1= LineStyle Solid
            pause(0.1);
            %Part 2: Calculate mu fitted
            res = pwd.CalcMuFitted(x_time,y_Us);
            muFitted = res.b;
            constant = res.a;
            fprintf("Mu fitted is: %.4f\n",muFitted);
            pause(0.1);
            %Part 3: Plot mu fitted graph
            y_fitted = constant*exp(muFitted.*x_time);
            pwd.Plot_xVy(x_time,y_fitted,2,1,'fittedData'); %2= color blue
            pause(0.1);
            %Note: Cannot calculate mu expected cause we haven't got a way.
        end
        pause(0.1);

        
        %###############################
        %-------- Test Number 5 --------
        %-------- Test Number 5 --------
        %-------- Test Number 5 --------
        %###############################
        %-------------------------------
        %Test 5: View Alpha Vibrations
        %-------------------------------
        for rep = 1:1:n0
            pwd.ClearFigure();
            oneRepDataArrU = GetOneRepDataArr(growthData,rep);
            x_time = oneRepDataArrU(:,t);
            y_Alfa = oneRepDataArrU(:,Alfa);
            pwd.Plot_xVy(x_time,y_Alfa,1,1,'Alpha');
            pwd.SetMaxXMaxY(200,0.9);
            pause(0.1);
        end
        pause(0.2);
        
        %################################
        %-------- Test Number 6 ---------
        %-------- Test Number 6 ---------
        %-------- Test Number 6 ---------
        %################################
        %--------------------------------
        %Test 6: RBS gauge for Alpha Hill
        %--------------------------------
        if (n0 > 1)
            %A. Get ssAlphaArray
            ssAlphaArray = pwd.getSteadyStateAlphas(alfaSignal);
            %B. Calc ssAlpha RBS
            pwd.AlphaRBS(ssAlphaArray);
            pause(5);
            delete(findall(0));
            pwd.NewFigure();
        end
        pause(1);
    end
end
%save 'nSP - The Workspace.mat'
fprintf("Finished.\n")