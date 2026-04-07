
%#############################################################
%#############################################################
%#############################################################
%#############################################################
%#############################################################
%#############################################################
%#############################################################
%#############################################################
%#############################################################
%#############################################################
%Explanation: After sim you'll have fullDataArr and the function
%SetRep, which accepts arr and number of rep. SetRep returns an
%arr of the certain Rep results.
t=1; U=2; P=3; F=4; Alfa=5; RT=6; Rep=7;
numOfReps = fullDataArr(end,Rep);

%-------
%Step 0: If sim did NOT run, and data needs to be uploaded.
%-------
%filename = 'C:\\Users\\talkohavy\\Desktop\\Values 2.xlsx';
%fullData = xlsread(filename);
%cells.fullData = fullData;
%cells.numOfReps = fullData(end,7);
%cells.fixedAlpha = 0.7;


if (questdlg("Run Plots?") == "Yes")
    cells.NewFigure();
    if (cells.isHill)
        %----------------------------
        %VERSION 1: Alfa is osillated
        %----------------------------
        %Step 2: Plot n0 Graphs
        for i = 1:1:numOfReps
            cells.ClearFigure();
            oneRepDataArr = SetRep(fullDataArr,i);
            cells.Plot_xVy(oneRepDataArr,t,U);%cells.data
            cells.Plot_xVy(oneRepDataArr,t,P);
            cells.Plot_xVy(oneRepDataArr,t,F);
            pause(1);
        end
        pause(1);

        %-------
        %Step 2: RBS gauge for Alpha Hill
        %-------
        if (numOfReps > 1)
            cells.AlphaRBS(fullDataArr);
            pause(5);
            delete(findall(0));
            cells.NewFigure();
        end
        pause(1);
        
        %-------
        %Step 3: View Alpha Vibrations
        %-------
        for i = 1:1:numOfReps
            cells.ClearFigure();
            oneRepDataArr = SetRep(fullDataArr,i);
            cells.Plot_xVy(oneRepDataArr,t,Alfa);
            cells.SetMaxXMaxY(200,0.9);
            pause(1);
        end
        pause(2);
        
        %-------
        %Step 5: SimTime Vs. RealTime
        %-------
        for i = 1:1:numOfReps
            cells.ClearFigure();
            oneRepDataArr = SetRep(fullDataArr,i);
            cells.Plot_xVy(oneRepDataArr,RT,t);
            cells.SetMaxXMaxY(0.5,100);
            pause(1);
            cells.SetMaxXMaxY(2.5,150);
            pause(1);
            cells.SetMaxXMaxY(8,200);
            pause(3);
        end
    else
        %------------------------
        %VERSION 2: Alfa is Fixed
        %------------------------
        %Step 1: SimTime Vs. RealTime
        for i = 1:1:numOfReps
            cells.ClearFigure();
            oneRepDataArr = SetRep(fullDataArr,i);
            cells.Plot_xVy(oneRepDataArr,RT,t);
            cells.SetMaxXMaxY(0.5,100);
            pause(1);
            cells.SetMaxXMaxY(2.5,150);
            pause(1);
            cells.SetMaxXMaxY(8,200);
            pause(3);
        end
        
        %-------
        %Step 2: Fitted Vs. Expected
        %-------
        for i = 1:1:numOfReps
            cells.ClearFigure();
            oneRepDataArr = SetRep(fullDataArr,i);
            fprintf('-------------------\n')
            fprintf('Results of Rep: %.0f\n', i)
            cells.ScatterPlot_xVy(oneRepDataArr,t,U);
            pause(2);
            cells.Plot_expectedU();
            pause(2);
            cells.Plot_fittedU(oneRepDataArr);
            pause(2);
            cells.Plot_ProveLinear(oneRepDataArr,U);
            pause(2);
            cells.SetMaxXMaxY(100,20);
            pause(2);
            cells.SetMaxXMaxY(600,600);
            pause(2);
            cells.Plot_xVy(oneRepDataArr,t,F);
            pause(2);
        end
    end
end
%delete(findall(0));
%cells.Animation();
%cells.SetRep(i);
% xi = cells.data(:,t);
% ui = cells.data(:,U);
% sz = length(xi);
% yi = zeros(sz,1);
% for j=1:1:sz
%     yi(j) = log(ui(j)/ui(1));
% end
% disp('Finished.'); 


% toRami = DataTable2(2+3*25);        
% for i= 1:1:100
%     toRami.AddNewEmptyRow();
%     toRami.GetLast().SetValueAt(1,i);
%     toRami.GetLast().SetValueAt(2,cells.alpha);
%     cells.numOfReps = 0;
%     disp(cells.alpha);
%     for j= 1:1:n0
%         rng(CRN+j)
%         cells.RunOnce;
%         toRami.SetValueAt(3+3*(j-1),cells.CalcMuExpected());
%         toRami.SetValueAt(4+3*(j-1),cells.CalcMuFitted().b);
%         toRami.SetValueAt(5+3*(j-1),cells.R2squared());    
%     end
% end