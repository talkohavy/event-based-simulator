clc;
clear;
close all;
format shortG;
if(length(findall(0))>1)
    delete(findall(0));
end
addpath("MyClasses")
%-------------------------
%Stage 1: Load Sim results
%-------------------------
load 'þþTwoAlphaOpt_LongRun_erlang_kIs1.mat'

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
    pwd.NewFigure();
    pwd.ChangeTitle("SimTime Vs. RealTime");
    pwd.ChangeXlabel("realTime_{[sec]}");
    pwd.ChangeYlabel("simTime_{[min]}");
    for rep = 1:1:n0
        pwd.ClearFigure();
        oneRepDataArrU = GetOneRepDataArr(growthData,rep);
        x_realTime = oneRepDataArrU(:,RT);
        y_simTime = oneRepDataArrU(:,t);
        pwd.Plot_xVy(x_realTime,y_simTime,1,1,'time');
        pwd.SetMaxXMaxY(0.5,100);
        pause(1);
        pwd.SetMaxXMaxY(2.5,150);
        pause(1);
        maxSimTime = max(oneRepDataArrU(:,1));
        maxRealTime = max(oneRepDataArrU(:,6));
        pwd.SetMaxXMaxY(maxRealTime*1.1,maxSimTime*1.1);
        pause(1);
    end

    %###############################
    %-------- Test Number 4 --------
    %-------- Test Number 4 --------
    %-------- Test Number 4 --------
    %###############################
    %------------------------------------
    %Test 4: Calculate and plot mu fitted
    %------------------------------------
    pwd.ChangeXlabel("simTime_{[min]}");
    pwd.ChangeYlabel("quantity_{[#]}");
    pwd.ChangeTitle("Ribosome Count");
    for rep = 1:1:n0
        oneRepDataArrU = GetOneRepDataArr(growthData,rep);
        x_time = oneRepDataArrU(:,t);
        y_Us = oneRepDataArrU(:,U);
        y_Ps = oneRepDataArrU(:,P);
        y_Fs = oneRepDataArrU(:,F);
        %----------------------------
        %Part 1: Plot rawData results
        %----------------------------
        pwd.ClearFigure();
        pwd.SetMaxXMaxY(300,8192);
        x_time_thinner = [  x_time(1);
                            x_time(3);
                            x_time(6);
                            x_time(12);
                            x_time(24);
                            x_time(50);
                            x_time(92);
                            x_time(190);
                            x_time(356:256:end)];
        y_Us_thinner = [    y_Us(1);
                            y_Us(3);
                            y_Us(6);
                            y_Us(12);
                            y_Us(24);
                            y_Us(50);
                            y_Us(92);
                            y_Us(190);
                            y_Us(356:256:end)];
        pwd.ScatterPlot_xVy(x_time_thinner,y_Us_thinner,300,4,'Us');%4= Blue Color, 20= Dot Size
        pause(1);
        %---------------------------
        %Part 2: Calculate mu fitted
        %---------------------------
        res = pwd.CalcMuFitted(x_time,y_Us);
        muFitted = res.b;
        constant = res.a;
        fprintf("Mu fitted is: %.4f\n",muFitted);
        pause(1);
        %----------------------------------------------
        %Part 3: Plot mu fitted graph + rawData results
        %----------------------------------------------
        pwd.ClearFigure();
        pwd.SetMaxXMaxY(300,8192);
        y_fitted = constant*exp(muFitted.*x_time);
        pwd.Plot_xVy(x_time,y_fitted,1,2,'fittedData'); %2= red color 
        pwd.ScatterPlot_xVy(x_time_thinner,y_Us_thinner,300,4,'Us');%1= Black Color, 20= Dot Size
        pause(1);
        %Note: Cannot calculate mu expected cause we haven't got a way.
    end
    pause(1);


    %###############################
    %-------- Test Number 5 --------
    %-------- Test Number 5 --------
    %-------- Test Number 5 --------
    %###############################
    %-------------------------------
    %Test 5: View Alpha Vibrations
    %-------------------------------
    pwd.ChangeTitle("\alpha Vibrations");
    pwd.ChangeXlabel("simTime_{[min]}");
    pwd.ChangeYlabel("\alpha");
    for rep = 1:1:n0
        pwd.ClearFigure();
        oneRepDataArrU = GetOneRepDataArr(growthData,rep);
        x_time = oneRepDataArrU(:,t);
        y_Alfa = oneRepDataArrU(:,Alfa);
        pwd.Plot_xVy(x_time,y_Alfa,1,1,'Alpha');
        pwd.SetMaxXMaxY(200,0.9);
        pause(1);
    end
    pause(1);

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
        statistics = pwd.AlphaRBS(ssAlphaArray);
%         pwd.PlotGauge(statistics(1)-0.0002,statistics(2)+0.0002,statistics);
%         pause(5);
    end
end
fprintf("Finished.\n")