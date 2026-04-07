clc;
clear;
load('nSP - The Workspace.mat')
close all;
format shortG;
if(length(findall(0))>1)
    delete(findall(0));
end
addpath("MyClasses")
%-------
%Step 0: If sim did NOT run, and data needs to be uploaded.
%-------
pwd = PlayWithData();
n0 = 30;
alpha = 0.285;
tRP = 6.3/4*1.1;

%--------------------------------------
%STAGE 1: Use Static Class PlayWithData
%--------------------------------------
t=1; U=2; P=3; F=4; Alfa=5; RT=6; Rep=7;
%------------------------------
%STAGE 2: Plot after simulation
%------------------------------
if (questdlg("Run Test number 1? (mu growth)") == "Yes")    
    %-------
    %Step 5: Rami's Format
    %-------
    %Row Alpha MuFitted_Run.1 R2Squared_Run.1 MuFitted_Run.2 R2Squared_Run.2
    % 1  0.05      0.079           0.99            0.081           0.99
    
     alfaMin = 0.05;
     alfaMax = 1;
     step = 0.05;
     curAlfa = alfaMin;
     rows = uint8((alfaMax-alfaMin)/step)+1;
     toRami = zeros(rows,2+2*n0);
     for i= 1:1:rows
         cells.alpha = curAlfa;
         toRami(i,1) = i;
         toRami(i,2) = cells.alpha;
         disp(cells.alpha);
         cells.repNumber = 0;
         for j = 1:1:n0
             rng(CRN+j)
             cells.RunOnce;
             oneRepDataArr = cells.unTrnsData.TransformData();
             toRami(i,3+2*(j-1)) = cells.CalcMuFitted(oneRepDataArr).b;
             toRami(i,4+2*(j-1)) = cells.R2squared(oneRepDataArr);
             %---------------------------------------
             %cells.ClearFigure();
             %cells.Plot_expectedU();
             %cells.Plot_fittedU(oneRepDataArr);
             %pause(0.00005);
         end
         curAlfa = curAlfa + step;
     end    
     delete(findall(0));
     filename = 'C:\\Users\\\blacksoul\\Desktop\\values.xlsx';
     xlswrite(filename,toRami);
end