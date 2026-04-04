clc;
clear;
load('Serial - Workspace.mat')
close all;
format shortG;
if(length(findall(0))>1)
    delete(findall(0));
end
addpath("MyClasses")
%------------------------------------
%Stage 1: Create PlayWithData instance
%------------------------------------
pwd = PlayWithData();

%---------------------------
%Stage 2: Use Help Vairables
%---------------------------
t=1; U=2; P=3; F=4; Alfa=5; RT=6; Rep=7;

%---------------------------------------
%Stage 3: Calculate muFitted for all reps
%---------------------------------------
muFitted = zeros(1,n0);
for rep = 1:1:n0
    oneRepDataArrU = GetOneRepDataArr(growthData,rep);
    x_time = oneRepDataArrU(:,t);
    y_Us = oneRepDataArrU(:,U);
    res = pwd.CalcMuFitted(x_time,y_Us);
    muFitted(rep) = res.b;
end

%----------------------------------------------
%Stage 4: Plots & Calculations after simulation
%----------------------------------------------

%##################################################################
%##################################################################
%##################################################################
%##################################################################
%------------------------ Test Number 1 ---------------------------
%------------------------ Test Number 1 ---------------------------
%------------------------ Test Number 1 ---------------------------
%------------------- Finding Mu - growthRate ----------------------
%------------------- Finding Mu - growthRate ----------------------
%------------------- Finding Mu - growthRate ----------------------
%------------ By Solving this equation and finding mu -------------
%Equation 1: 1 = 1/(1+mu*tRP)*(1 + alfa/4*Ppooli*PSAi) ------------
%##################################################################
%##################################################################
%##################################################################
if (questdlg("Run Tests number 1? (find mu with Eq. 1)") == "Yes")    
    muArr_Eq1 = zeros(5,n0);
    %Row 1: mu got from P1
    %Row 2: mu got from P2
    %Row 3: mu got from P3
    %Row 4: mu got from P4
    %Row 5: Avg mu from P1-P4
    for rep = 1:1:n0
        fprintf('****** Results of Rep: %.0f ******\n', rep)
        fprintf("muFitted used was: %.6f\n", muFitted(rep));
        distOfPi = MyList();
        distOfPi.Enque(Entity(1,GetOneRepDataArr(distOfP1,rep)));
        distOfPi.Enque(Entity(2,GetOneRepDataArr(distOfP2,rep)));
        distOfPi.Enque(Entity(3,GetOneRepDataArr(distOfP3,rep)));
        distOfPi.Enque(Entity(4,GetOneRepDataArr(distOfP4,rep)));
        for i= 1:1:4
            %---------------------------------------------------------
            %Step 2: Estimate LT_Pool_Pi & LT_SA_Pi - From Raw DataSet
            %---------------------------------------------------------
            %Using the formula: sum(e^(-muFitted*ti))/n
            distOfPi_rep = distOfPi.Deque.GetEntity.GetArr;
            n = length(distOfPi_rep);
            ti_Pool = distOfPi_rep(:,1);
            ti_SA = distOfPi_rep(:,2);
            LT_Pool = sum(exp(-muFitted(rep)*ti_Pool))/n;
            LT_SA = sum(exp(-muFitted(rep)*ti_SA))/n;
            
            %-----------------------------------------------
            %Step 3: Calc the expected mu by using fitted mu
            %-----------------------------------------------
            muArr_Eq1(i,rep) = SolveEq1(tRP,LT_Pool,LT_SA,alpha);
            fprintf("Eq. 1 - muExpected from P1 is: %.6f\n", muArr_Eq1(i,rep));
        end
            
        muArr_Eq1(5,rep) = mean(muArr_Eq1(1:4,rep));
        fprintf("Eq. 1 - Avg muExpected: %.6f\n", muArr_Eq1(5,rep));
        fprintf("-------------------------------\n");
    end
end

%##################################################################
%##################################################################
%##################################################################
%##################################################################
%------------------------ Test Number 2 ---------------------------
%------------------------ Test Number 2 ---------------------------
%------------------------ Test Number 2 ---------------------------
%------------------- Finding Mu - growthRate ----------------------
%------------------- Finding Mu - growthRate ----------------------
%------------------- Finding Mu - growthRate ----------------------
%------------ By Solving this equation and finding mu -------------
%Equation 2: 1=((alfa/n)*(1/n)*sum(e^(-mu*[tSAi+tPooli])+1)*(1/N)*sum(e^(-mu*tRPi)))
if (questdlg("Run Tests number 2? (find mu with Eq. 3)") == "Yes")    
    muArr_Eq3 = zeros(5,n0);
    %Row 1: mu got from P1
    %Row 2: mu got from P2
    %Row 3: mu got from P3
    %Row 4: mu got from P4
    %Row 5: Avg mu from P1-P4
    for rep = 1:1:n0        
        distOfPi = MyList();
        distOfPi.Enque(Entity(1,GetOneRepDataArr(distOfP1,rep)));
        distOfPi.Enque(Entity(2,GetOneRepDataArr(distOfP2,rep)));
        distOfPi.Enque(Entity(3,GetOneRepDataArr(distOfP3,rep)));
        distOfPi.Enque(Entity(4,GetOneRepDataArr(distOfP4,rep)));
        for i = 1:1:4
            distOfPi_rep = distOfPi.Deque.GetEntity.GetArr;
            ti_Pool = distOfPi_rep(:,1);
            ti_SA = distOfPi_rep(:,2);
            muArr_Eq3(i,rep) = SolveEq3(ti_Pool,ti_SA,tRP,alpha);
        end
        muArr_Eq3(5,rep) = mean(muArr_Eq3(1:4,rep));
        fprintf("Eq. 3 - muExpected from P1 is: %.6f\n", muArr_Eq3(1));
        fprintf("Eq. 3 - muExpected from P2 is: %.6f\n", muArr_Eq3(2));
        fprintf("Eq. 3 - muExpected from P3 is: %.6f\n", muArr_Eq3(3));
        fprintf("Eq. 3 - muExpected from P4 is: %.6f\n", muArr_Eq3(4));
        fprintf("Eq. 3 - Avg muExpected: %.6f\n", muArr_Eq3(5,rep));
        fprintf("###############################\n");
    end
end


%##################################################################
%##################################################################
%##################################################################
%##################################################################
%------------------------- Test Number 3 --------------------------
%------------------------- Test Number 3 --------------------------
%-------------------- Finding Phi - Inventory ---------------------
%-------------------- Finding Phi - Inventory ---------------------
%-------------------- Finding Phi - Inventory ---------------------
%------------- Solving this equation and finding mu ---------------
%------------------- Phi = 1/(Ppooli*PSAi1) - 1 -------------------
if (questdlg("Run Test number 3? (Phi equation gives 1)") == "Yes")    
    phiArr_Eq2 = zeros(5,n0);
    for rep = 1:1:n0
        %----------------------------------
        %Step 1: Get Phi - From Raw DataSet
        %----------------------------------
        oneRepInventory = GetOneRepDataArr(inventoryList,rep);        
        allRpsInPool = sum(oneRepInventory (end,2:5));
        allRpsInAssembly = sum(oneRepInventory (end,6:9));
        Us = oneRepInventory(end,11);
        phi_last = (allRpsInPool + allRpsInAssembly)/(Us*4);%Note: Us*4 because there are four in the structure.
        fprintf("Phi from raw data is: %.4f\n",phi_last);
        
        distOfPi = MyList();
        distOfPi.Enque(Entity(1,GetOneRepDataArr(distOfP1,rep)));
        distOfPi.Enque(Entity(2,GetOneRepDataArr(distOfP2,rep)));
        distOfPi.Enque(Entity(3,GetOneRepDataArr(distOfP3,rep)));
        distOfPi.Enque(Entity(4,GetOneRepDataArr(distOfP4,rep)));
        for i = 1:1:4
            %---------------------------------------------------------
            %Step 2: Estimate LT_Pool_Pi & LT_SA_Pi - From Raw DataSet
            %---------------------------------------------------------
            %Using the formula: sum(e^(-muFitted*ti))/n
            distOfPi_rep = distOfPi.Deque.GetEntity.GetArr;
            n = length(distOfPi_rep);
            ti_Pool = distOfPi_rep(:,1);
            ti_SA = distOfPi_rep(:,2);
            LT_Pool = sum(exp(-muFitted(rep)*ti_Pool))/n;
            LT_SA = sum(exp(-muFitted(rep)*ti_SA))/n;
            %----------------------------------------------
            %Step 3: In theory, we should get a result of 1
            %----------------------------------------------
            shouldBeOne = (phi_last+1)*LT_Pool*LT_SA;
            fprintf("Phi+Ppool+PSA of P%.0f gave a result of: %.4f\n",i,shouldBeOne);
        end
        pause(0.4);
        
%         %The Phi received are...
%         phiArr_Eq2(1,rep) = SolveEq2(LT_P1_Pool,LT_P1_Assembly);
%         phiArr_Eq2(2,rep) = SolveEq2(LT_P2_Pool,LT_P2_Assembly);
%         phiArr_Eq2(3,rep) = SolveEq2(LT_P3_Pool,LT_P3_Assembly);
%         phiArr_Eq2(4,rep) = SolveEq2(LT_P4_Pool,LT_P4_Assembly);
%         phiArr_Eq2(5,rep) = mean(phiArr_Eq2(1:4,rep));
%         fprintf('****** Results of Rep: %.0f ******\n', rep)
%         fprintf("muFitted used: %.6f\n", muFitted(rep));
%         fprintf("Eq. 2 - phiExpected from P1 is: %.6f\n", phiArr_Eq2(1,rep));
%         fprintf("Eq. 2 - phiExpected from P2 is: %.6f\n", phiArr_Eq2(2,rep));
%         fprintf("Eq. 2 - phiExpected from P3 is: %.6f\n", phiArr_Eq2(3,rep));
%         fprintf("Eq. 2 - phiExpected from P4 is: %.6f\n", phiArr_Eq2(4,rep));
%         fprintf("Eq. 2 - Average phi is: %.6f\n", phiArr_Eq2(5,rep));
    end
end


%##################################################################
%##################################################################
%##################################################################
%##################################################################
%------------------------- Test Number 4 --------------------------
%------------------------- Test Number 4 --------------------------
%-------------------- Show that Phi is Mitkanes -------------------
%-------------------- Show that Phi is Mitkanes -------------------
%-------------------- Show that Phi is Mitkanes -------------------
%------------------ Using plot to inventory table -----------------
%------------------ Using plot to inventory table -----------------
if (questdlg("Run Test number 4? (Show that Phi Mitkanes)") == "Yes")    
	pwd.NewFigure();
    for rep = 1:1:n0
        %--------------------------------------
        %Calc Phi for each t - From Raw DataSet
        %--------------------------------------
        oneRepInventory = GetOneRepDataArr(inventoryList,rep);
        x_time = oneRepInventory(:,1);
        y_phi = zeros(1,length(oneRepInventory));
        for i = 1:1:length(oneRepInventory)
            allRpsInPool = sum(oneRepInventory (i,2:5));
            allRpsInAssembly = sum(oneRepInventory (i,6:9));
            Us = oneRepInventory(i,11);
            y_phi(i) = (allRpsInPool + allRpsInAssembly)/(Us*4);
            %Note: Us*4 because there are four in the structure.
        end
        pwd.ClearFigure();
        pwd.Plot_xVy(x_time,y_phi,1,1,'Phi');
        pwd.SetMaxXMaxY(220,1);
        pause(1);
    end
end