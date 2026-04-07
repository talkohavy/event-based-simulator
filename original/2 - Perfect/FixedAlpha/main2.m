clc;
% clear;
close all;
format shortG;
if(length(findall(0))>1)
    delete(findall(0));
end
addpath("MyClasses")
%-------------------------
%Stage 1: Load Sim results
%-------------------------
% load 'Model 1 - Alpha Opt.mat'

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
	pwd.ChangeXlabel("realTime_{[sec]}");
    pwd.ChangeYlabel("simTime_{[min]}");
    pwd.ChangeTitle("SimTime Vs. RealTime");
    for rep = 1:1:6%n0
% 		pwd.ClearFigure();
        pwd.ClearFigure();
		oneRepDataArrU = GetOneRepDataArr(growthData,rep);
		x_realTime = oneRepDataArrU(:,RT);
		y_simTime = oneRepDataArrU(:,t);
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
    maxSimTime = max(growthData(:,1));
    maxUs = max(growthData(:,2));
    pwd.SetMaxXMaxY(maxSimTime*1.1,maxUs*1.1);
	for rep = 1:1:6%n0
		pwd.ClearFigure();
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
        maxSimTime = max(growthData(:,1));
        pwd.SetMaxXMaxY(maxSimTime*1.1,maxUs*1.1);
		%---------------------------------
		%Part 1: Plot rawData results Only
		%---------------------------------
        firstHalf = 10;
        jump1 = 10;
        jump2 = 120;
        x_time_thinner = [  x_time(1) ;
                            x_time(4) ;
                            x_time(16) ;
                            x_time(46) ;
                            x_time(146) ;
                            x_time(356:250:end)];
        y_Us_thinner = [y_Us(1) ;
                        y_Us(4) ;
                        y_Us(16) ;
                        y_Us(46) ;
                        y_Us(146) ;
                        y_Us(356:250:end)];
		pwd.ScatterPlot_xVy(x_time_thinner,y_Us_thinner,150,1,'rawData');%150= dot size, 1= color black
		pause(0.1);
		%---------------------------
		%Part 2: Calculate mu fitted
		%---------------------------
		res = pwd.CalcMuFitted(x_time,y_Us);
		muFitted = res.b;
		constant = res.a;
		fprintf("Mu fitted is: %.5f\n",muFitted);
		pause(0.1);
		%----------------------------------------------
		%Part 3: Plot rawData results + mu fitted graph
		%----------------------------------------------
		pwd.ClearFigure();
        y_fitted = constant*exp(muFitted.*x_time);
		pwd.Plot_xVy(x_time,y_fitted,2,1,'fittedData'); %2= color blue
        pwd.ScatterPlot_xVy(x_time_thinner,y_Us_thinner,150,1,'rawData');%150= dot size, 1= color black
		pause(0.1);
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
		pwd.Plot_xVy(x_time,y_fitted,2,1,'fittedData'); %2= color blue
        pwd.Plot_xVy(x_time,y_expected,3,1,'expctdData'); %3= color green
        pwd.ScatterPlot_xVy(x_time_thinner,y_Us_thinner,150,1,'rawData');%150= dot size, 1= color black
		pause(0.1);
        %------------------------------------------------
		%Part 6: Plot mu expected graph + rawData results
		%------------------------------------------------
		pwd.ClearFigure();
        pwd.SetMaxXMaxY(300,8192);
        y_expected = constant*exp(muExpcted.*x_time);
        pwd.Plot_xVy(x_time,y_expected,3,1,'expctdData'); %3= color green
        pwd.ScatterPlot_xVy(x_time_thinner,y_Us_thinner,150,1,'rawData');%150= dot size, 1= color black
		pause(0.1);
		%--------------------------
		%Part 7: Proof of linearity
		%--------------------------
		%A: Create y_fittedLine from observed and plot it
		pwd.ClearFigure();
		pwd.ChangeTitle("Slope as \mu");
        pwd.ChangeXlabel("simTime_{[min]}");
		pwd.ChangeYlabel("ln(U(t)/U(0))"); %
        pwd.SetMaxXMaxY(200,10);
		y_fittedLine = y_Us; %array is dumb in matlab
		U0 = y_fittedLine(1);
        for j=1:1:length(y_fittedLine)
			Uj = y_fittedLine(j);
			y_fittedLine(j) = log(Uj/U0);
        end
		pwd.Plot_xVy(x_time,y_fittedLine,4,1,'fittedLine'); %4= color red
		pause(0.1);
		%B: Create exptd Line and plot it.
		y_expectedLine = muExpcted.*x_time;
		pwd.Plot_xVy(x_time,y_expectedLine,5,1,'expctdLine'); %5= color magenta
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
% 		pwd.SetMaxXMaxY(300,4096);
% 		pwd.Plot_xVy(x_time,y_Fs,1,1,'Fs');
% 		pause(0.2);
	end
end
%save 'nSP - The Workspace.mat'
fprintf("Finished.\n")