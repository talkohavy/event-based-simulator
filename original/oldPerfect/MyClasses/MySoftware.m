classdef MySoftware < handle
    properties %(GetAccess='private', SetAccess='private')
        %-------------------------------
        %Group 1: Event-Programming Core.
        %-------------------------------
        Now;    % List 1.
        CEL;    % List 2.
        DL1;    % List 3.
        FEL;    % List 4.
        Us;     % Changes 1.
        Ps;     % Changes 2.
        Fs;     % Changes 3.
        Tnow;   % Updates.
        alpha = 0;% Fixed or changes
        isHill; % Hill or Fixed.
        U_Start;% Init: User Defined 1
        P_Start;% Init: User Defined 2
        F_Start;% Init: User Defined 3
        Tmax;   %=2*60; %2=Hours. 60=Minutes.
        Umax;   %num of Us to double to.
        Pmax;   %num of Ps to double to.
        unTrnsData;
        repNumber;
        alphaSS = 0.28; % Alpha at stable state.
        h = 2;
        k = 1;
        timerVal;
        FsCreated;
        
        %Distribution Variables:
        expExFood = 6.3; %E(x) of exp
        normMuFood;
        normSdFood;
        unifMinFood;
        unifMaxFood;
        detConstFood;
        TimeToCreateFood
        %----------
        expExDup = 6.3; %E(x) of exp
        normMuDup;
        normSdDup;
        unifMinDup;
        unifMaxDup;
        detConstDup;
        TimeToCreateDup;%Chosen Duplication Distribution
        gauge;
        
        %---------------------------
        %Group 1: Graphs and Design.
        %---------------------------
        colors     = {'black','b','g','r','black'};%,'m','y','k'
        lineStyles = {'-','-','-.','--','-'};
        fonts = {'Arial','Calibri','Tahoma','Times new roman'};
        fontWeights = {'Normal','Bold'};
        lgdTxt = {'t','U','P','F','alpha','RT'};
        fh;
        ax;
        firstLegend;
        fsHeader = 60;
        fsAxesNames = 36;
        fsAxesValues = 36;
        fsLgd = 36;
        lwMain = 4;
        lwSec = 1;
        
        %----------------------------
        %Group 2: Fitness Parameters.
        %----------------------------
        CalcMuExpected
    end
    %######################################################################
    %######################################################################
    %######################################################################
    %######################################################################
    %######################################################################
    %######################################################################
    %######################################################################
    %######################################################################
    %######################################################################
    %######################################################################
    %######################################################################
    %######################################################################
    methods
        %----------------------
        %Method 1: Constructor.
        %----------------------
        function obj = MySoftware()
            %obj.NewFigure();
            obj.repNumber = 0;
            obj.isHill = 1;
            obj.gauge = uigauge(uifigure,'circular');
            obj.gauge.MajorTicks = [0 10 20 30 40 50 60 70 80 90 100];
            obj.gauge.MajorTickLabels = {'0', '10', '20', '30', '40', '50', '60', '70', '80', '90', '100'};
            obj.gauge.ScaleColors = [0.470588235294118 0.670588235294118 0.188235294117647;0 1 0;1 1 0;1 0 0];
            obj.gauge.ScaleColorLimits = [50 100;50.1 75;25.1 50;0 25];
            obj.gauge.FontSize = 18;
            obj.gauge.Position = [150 90 250 250];
        end
        
        %------------------
        %Method 2: Main Run
        %------------------
        function RunOnce(obj)
            disp('Still running...')
            obj.repNumber = obj.repNumber + 1;
            %Step 1: Reset Software
            obj.Reset;
            %Step 2: Run
            EndSim = false;
            dataArr = [obj.Tnow,obj.Us,obj.Ps,obj.Fs,0,0,obj.repNumber];
            obj.unTrnsData.AddRow(dataArr);
            obj.timerVal = tic;
            while(EndSim == false)
                %############
                %STAGE 1: EMP
                %############
                while(obj.Now.size>0)
                    %**************************
                    %BigStep 1: Go to Now List.
                    %**************************
                    %if (obj.Tnow<obj.Tmax)
                    if (obj.Tnow > obj.Tmax || obj.Us >= obj.Umax || obj.Ps >= obj.Pmax)
                        EndSim = true;
                        break;
                    else
                        switch obj.Now.GetFirst.GetEntity.arr(2) %2= eventCode
                            case '1' % Code 1: Treat Food Arrival.
                                obj.TreatFoodArrival;
                            case '2' % Code 2: Treat End of Duplication
                                obj.TreatEndOfDuplication;
                            otherwise
                                disp('There was an error.');
                        end
                        obj.FEL.InsertionSort();
                    end%//if: Time's Up.
                    while(obj.CEL.size > 0)
                        obj.Now.Enque(obj.CEL.Deque.GetEntity);
                    end
                end%//while: EMP    
                %#############
                %STAGE 2: CUP| Going to FEL List.
                %#############
                if (obj.FEL.size > 0)
                    obj.PullFutureEvents;
                else
                    EndSim = true;
                end
            end%//while: Software
            fprintf('Rep %.0f is Done!\n',obj.repNumber)
        end
        
        %----------------------
        %Method 3: Reset stuff.
        %----------------------
        function Reset(obj)
            %Initialize 1: Reset all Variables.
            obj.Us = obj.U_Start;
            obj.Ps = obj.P_Start;
            obj.Fs = obj.F_Start;
            obj.FsCreated = 0;
            obj.Tnow = 0;
            obj.unTrnsData = DataTable(7);
            obj.Now = MyList();
            obj.CEL = MyList();
            obj.DL1 = MyList();
            obj.FEL = MyList();
            %Initialize 2: Write Ps in Diary.
            i=0;
            arr = strings(1,3);
            arr(1) = 'P';   %1= name
            arr(2) = 1;     %2= eventCode , 1=Take Care of Food arrival.
            data = -1;     %data= eventTime
            while(i < obj.Ps)
                obj.MakeFood(Entity(data,arr));
                i=i+1;
            end
            %Initialize 3: Put all Us Queue.
            i=0;
            arr(1) = 'U';   %1= name
            arr(2) = 2;     %2= eventCode , 2= Treat End of Duplication.
            data = -1;     %data= eventTime
            while(i < obj.Us)
                obj.DL1.Enque(Entity(data,arr)); 
                i=i+1;
            end
            %Initialize 4: Write Us in Diary.
            while(obj.Fs > 0 && obj.DL1.size > 0)
                obj.Duplicate(obj.DL1.Deque.GetEntity);
            end
            obj.FEL.InsertionSort();
        end
        
        %----------------------------------
        %Method 4: Create Event - Make Food.
        %----------------------------------
        function MakeFood(obj,entity)
            x = obj.TimeToCreateFood();
            entity.data = obj.Tnow + x;
            obj.FEL.Enque(entity);
        end
        
        %------------------------------------
        %Method 5: Create Event - Duplication.
        %------------------------------------
        function Duplicate(obj,entity)
            %Step 1: Time to Duplicate.
            x = obj.TimeToCreateDup();
            %Step 2: To which one? U or P?
            u = rand();
            if (obj.isHill)
                obj.alpha = obj.alphaSS/(1 + (obj.Us*obj.k/obj.Fs)^obj.h);%(obj.k^obj.h)/(obj.k^obj.h + (obj.Us/obj.Fs)^obj.h);
            end
            if(u <= obj.alpha)
                entity.arr(1) = 'U'; %1= name
            else
                entity.arr(1) = 'P'; %1= name
            end
            %Step 3: Update Entity's stuff.
            entity.data = obj.Tnow+x; %data = eventTime 
            entity.arr(2) = 2;%(2)= eventCode. 2= Treat End of Duplication.
            obj.Fs = obj.Fs - 1;
            %Step 4: Add Event 2 to Diary.
			obj.FEL.Enque(entity);
        end
        
        %----------------------------
        %Method 6: Treat Food arrival.
        %----------------------------
        function TreatFoodArrival(obj)
            obj.Fs = obj.Fs + 1;
            obj.FsCreated = obj.FsCreated + 1;
            %Step 1: Create Next Food.
            obj.MakeFood(obj.Now.Deque.GetEntity);
            %Step 2: Create End of Duplication.
            while(obj.Fs > 0 && obj.DL1.size > 0)
                obj.Duplicate(obj.DL1.Deque.GetEntity);
            end
            %Step 3: Log the change.
            dataArr = [obj.Tnow,obj.Us,obj.Ps,obj.Fs,obj.alpha,toc(obj.timerVal),obj.repNumber];
            obj.unTrnsData.AddRow(dataArr);
        end
        
        %----------------------------------
        %Method 7: Treat End of Duplication.
        %----------------------------------
        function TreatEndOfDuplication(obj)
            if (obj.Now.GetFirst.GetEntity.arr(1) == 'U')
                %Step 1: U is Born!
                obj.Us = obj.Us + 1;
                arr = strings(1,3);
                arr(1) = 'U';   %1= name
                arr(2) = 2;     %2= eventCode , 2= Treat End of Duplication.
                data = -1;     %data= eventTime
                obj.Now.Enque(Entity(data,arr));
                for i=1:2
                    if (obj.Fs > 0)
                        obj.Duplicate(obj.Now.Deque.GetEntity);
                    else
                        obj.DL1.Enque(obj.Now.Deque.GetEntity);
                    end
                end
            elseif (obj.Now.GetFirst.GetEntity.arr(1) == 'P')
                %Step 1: P is Born!
                obj.Ps=obj.Ps+1;
                %Step 2: New P creates More Food.
                arr = strings(1,3);
                arr(1) = 'P';   %1= name
                arr(2) = 1;     %2= eventCode , 1=Take Care of Food arrival.
                data = -1;     %data= eventTime
                obj.MakeFood(Entity(data,arr)); %1= Food Arrival Event.
                %Step 3: Old U duplicates if he can or goes to sleep.
                if(obj.Fs > 0)
                    obj.Duplicate(obj.Now.Deque.GetEntity);
                else
                    obj.DL1.Enque(obj.Now.Deque.GetEntity);
                end
            end%/if: U created.
            %Last Step: Log the change.
            dataArr = [obj.Tnow,obj.Us,obj.Ps,obj.Fs,obj.alpha,toc(obj.timerVal),obj.repNumber];
            obj.unTrnsData.AddRow(dataArr);
        end
            
        %----------------------------
        %Method 8: Pull Future Events.
        %----------------------------
        function PullFutureEvents(obj)
            obj.Now.Enque(obj.FEL.Deque.GetEntity);
            obj.Tnow = obj.Now.GetFirst.GetEntity.data;
            %^^^^^^^^^^^^^
            %Gaue Version: Time/Us/Ps Ratio
            %^^^^^^^^^^^^^
            arr = zeros(1,3);
            arr(1) = obj.Tnow/obj.Tmax*100; % timeRatio 
            arr(2) = obj.Us/obj.Umax*100;   % uRatio 
            arr(3) = obj.Ps/obj.Pmax*100;   % pRatio
            obj.gauge.Value = max(arr);
            
            pause (0.0000001);
            while(obj.FEL.size > 0 && obj.FEL.GetFirst.GetEntity.data == obj.Tnow)
                obj.CEL.Enque(obj.FEL.Deque.GetEntity);
            end
        end
        
        %##################################################################
        %##################################################################
        %##################################################################
        %##################################################################
        %##################################################################
        %##################################################################
        %##################################################################
        %##################################################################
        %##################################################################
        %##################################################################
        %##################################################################
        %##################################################################
        %##################################################################
        %##################################################################
        
        %-------------------------
        %Method 2: Calc Mu Fitted.
        %-------------------------
        function obj = CalcMuFitted(obj,oneRepDataArr)
            t=1; U=2; P=3;
            %Step 1: Find GrowthRate mu.
            if (size(oneRepDataArr,1) > 10)
                x = oneRepDataArr(10:end,t);
                y = oneRepDataArr(10:end,P);
                [res , gof] = HisExpFit(x,y);
                %fprintf('The Constant is: %.4f\n',res.a);
                %fprintf('The fitted mu is: %.4f\n',res.b);
                obj = res;
            else
                fprintf("Less than 10 rows in oneRepDataArr!\nAbort! Abort! Abort!\n")
            end
        end
        
        %---------------------------
        %Method 3: Calc Mu Expected.
        %---------------------------
        function obj = ExpLaplace(obj)
            obj = obj.alpha/obj.expExDup;
        end
        %or...
        function obj = UnifLaplace(obj)
            % STEP 1: The non-dependant.
            a = obj.unifMinDup;
            b = obj.unifMaxDup;
            alfa = obj.alpha;
            syms g
            % STEP 2: Left Side (The Equation)
            leftSide = (1+alfa)*(exp(-a*g)-exp(-b*g))/(g*(b-a));
            % STEP 3: Right Side
            rightSide = 1;
            % STEP 4: Solve by MATLAB'S Function.
            muExpected = double(vpasolve(leftSide==rightSide,g));
            obj = muExpected;
        end
        
        %------------------------------
        %Method 4: Plot t Vs U/P/F/Alfa
        %------------------------------
        function Plot_xVy(obj,oneRepDataArr,i,j)
            %x vs y: t/U/P/F/alpha vs t/U/P/F/alpha
            plot(obj.ax,oneRepDataArr(:,i),oneRepDataArr(:,j),strcat(obj.colors{j},obj.lineStyles{j}),'LineWidth',obj.lwMain,'MarkerSize',5);
            obj.MyLegend(obj.lgdTxt{j});
        end
        
        %------------------------------
        %Method 5: Plot t Vs U/P/F/Alfa
        %------------------------------
        function ScatterPlot_xVy(obj,oneRepDataArr,i,j)
            %x vs y: t/U/P/F/alpha vs t/U/P/F/alpha
            scatter(obj.ax,oneRepDataArr(:,i),oneRepDataArr(:,j),300,obj.colors{j},'linewidth',obj.lwSec); %,'filled'
            obj.MyLegend(obj.lgdTxt{j});
        end
        
        %-----------------------
        %Method 6: Plot Fitted U
        %-----------------------
        function Plot_fittedU(obj,oneRepDataArr)
            %Step 1: Fit Data.
            res = obj.CalcMuFitted(oneRepDataArr); %not exactly... res.b is muFitted.
            fprintf('The fitted mu is: %.4f\n',res.b);
            %Step 2: Plot Pure e^(mu_fit*t)
            ramiFun = @(x)res.a*exp(res.b.*x);
            fplot(obj.ax,ramiFun,[0 500],'r','linewidth',obj.lwMain);
            obj.MyLegend("fittedU");            
        end
        
        %---------------------------
        %Method 7: Plot ProveLinear.
        %---------------------------
        function Plot_ProveLinear(obj,oneRepDataArr,i)
            %Step 1: Calc muExpected and plot exptd Line.
            muExpected = obj.CalcMuExpected();
            exptdLine = @(x)muExpected*x;
            fplot(obj.ax,exptdLine,[0 100],'m','linewidth',obj.lwMain);
            obj.MyLegend("expctdLine");
            %Step 2: Plot fitted line - Create all Dots.
            t=1;
            bigX = oneRepDataArr(1:end,t);
            bigY = zeros(size(oneRepDataArr,1),1);
            y0 = oneRepDataArr(1,i);
            for j=1:1:size(oneRepDataArr,1)
                yj = oneRepDataArr(j,i);
                bigY(j) = log(yj/y0);
            end
            %Step 3: Plot and hope for straight line.
            scatter(obj.ax,bigX,bigY,70,'black','linewidth',1.2); %,'filled'
            obj.MyLegend("fittedLine");
            res = bigY(end)/bigX(end);
            %fprintf('The linear shipua is: %0.5f\n',res);
        end

        %-----------------------
        %Method 8: Plot Expected
        %-----------------------
        function Plot_expectedU(obj)
            %Step 1: Find GrowthRate mu.
            muExpected = obj.CalcMuExpected();
            fprintf('The expected g is: %.4f\n',muExpected);
            %Step 2: Plot Pure e^(muExp*t)
            ramiFun= @(x)exp(muExpected.*x);
            fplot(obj.ax,ramiFun,[0 500],'g','linewidth',obj.lwMain);
            obj.MyLegend("expctdU");
        end
                
        %------------------------
        %Method 9: RBS for Alpha.
        %------------------------
        function AlphaRBS(obj,fullDataArr)
            %RBS for alpha at Steady State:
            alfaArr = zeros(1,obj.repNumber);
            a=1; Rep = 7; Alfa = 5;
            curRep = fullDataArr(end,Rep)+1;
            for i=size(fullDataArr,1):-1:1
                if (curRep > fullDataArr(i,Rep))
                    curRep = curRep - 1;
                    alfaArr(a) = fullDataArr(i,Alfa);
                    a=a+1;
                end
            end
            n = obj.repNumber;
            alfaMean = mean(alfaArr);
            sd = std(alfaArr);
            tcr = 1.96;
            RBS_low = alfaMean - tcr*sd/sqrt(n);
            RBS_hi = alfaMean + tcr*sd/sqrt(n);
            fprintf('The RBS for alfa is: [%0.3f,%0.3f]\n',RBS_low,RBS_hi);
            %-----------------------------------------------------
            low = RBS_low*100;
            hi = RBS_hi*100;
            rbsGauge = uigauge(uifigure,'circular');
            rbsGauge.MajorTicks = 0:10:100;
            if (obj.isHill)
                gaugeColorLimits = [0 low/2;               %Red
                                    low/2 low;             %Yellow
                                    low hi;                %Green
                                    hi min(hi+low/2,100);  %Yellow
                                    min(hi+low/2,100) 100];%Red
                                rbsGauge.MajorTickLabels = {'0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1'};
                gaugeColors = [1 0 0;
                               1 1 0;
                               0 1 0;
                               1 1 0;
                               1 0 0];
            else
                gaugeColorLimits = [0 low-0.05;             %Red
                                    low-0.05 low+0.05;      %Green
                                    low+0.05 100];          %Red
                                rbsGauge.MajorTickLabels = {'0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1'};
                gaugeColors = [1 0 0;
                               0 1 0;
                               1 0 0];
            end
            rbsGauge.ScaleColors = gaugeColors;
            rbsGauge.ScaleColorLimits = gaugeColorLimits;
            rbsGauge.FontSize = 28;
            rbsGauge.Position = [150 90 250 250];
            rbsGauge.Value = alfaMean*100; % obj.Tnow/obj.Tmax*100;
        end
        
        %-----------------------
        %Method 10: Do Animation.
        %-----------------------
        function Animation(obj,oneRepDataArr)
            t=1; U=2; P=3; F=4;
            t1 = oneRepDataArr(:,t);
            y1 = oneRepDataArr(:,U);
            y2 = oneRepDataArr(:,P);
            y3 = oneRepDataArr(:,F);
            curve1 = animatedline(obj.ax,'Color',obj.colors{1},'linestyle',obj.lineStyles{1},'linewidth',obj.lwMain);
            curve2 = animatedline(obj.ax,'Color',obj.colors{2},'linestyle',obj.lineStyles{2},'linewidth',obj.lwMain);
            curve3 = animatedline(obj.ax,'Color',obj.colors{3},'linestyle',obj.lineStyles{3},'linewidth',obj.lwMain);
            addpoints(curve1,t1(1),y1(1));
            addpoints(curve2,t1(1),y2(1));
            addpoints(curve3,t1(1),y3(1));
            for i=1:100:length(t1)
                %Step 1: Draw lines + heads.
                addpoints(curve1,x1(i),y1(i));
                head1 = scatter(obj.ax,x1(i),y1(i),'filled','MarkerFaceColor',obj.colors{1},'MarkerEdgeColor',obj.colors{1});
                addpoints(curve2,x1(i),y2(i));
                head2 = scatter(obj.ax,x1(i),y2(i),'filled','MarkerFaceColor',obj.colors{2},'MarkerEdgeColor',obj.colors{2});
                addpoints(curve3,x1(i),y3(i));
                head3 = scatter(obj.ax,x1(i),y3(i),'filled','MarkerFaceColor',obj.colors{3},'MarkerEdgeColor',obj.colors{3});
                legend(obj.ax,'Us','Ps','Fs');
                drawnow;
                %Step 2: Delete head.
                delete(head1);
                delete(head2);
                delete(head3);
            end
        end
        
        %----------------------------
        %Method 11: My Dynamic Legend.
        %----------------------------
        function MyLegend(obj,newStr)
            if (obj.firstLegend)
                lgd = legend(obj.ax,newStr,'AutoUpdate','off');
                lgd.FontSize = obj.fsLgd;
                obj.firstLegend = false;
            else
                hh = findobj(gcf, 'Type', 'legend'); 
                newVal = [hh.String {newStr}]; 
                allDatah = flipud(get(gca,'children')); 
                hh.PlotChildren = allDatah; 
                hh.String = newVal;
            end
        end

        %----------------------
        %Method 12: Clear Figure
        %----------------------
        function ClearFigure(obj)
            clf(obj.fh)
            obj.ax = axes(obj.fh);
            cla(obj.ax);
            set(obj.ax,'position',[0.2 0.2 0.55 0.65],'FontName',obj.fonts{1},'FontSize',obj.fsAxesNames,'LineWidth',obj.lwMain,...
                'xlim',[0 500],'ylim',[0 500]);
            xlabel(obj.ax,'Time','FontSize',obj.fsAxesNames,'FontWeight',obj.fontWeights{1});
            ylabel(obj.ax,'Values','FontSize',obj.fsAxesValues);
            title(obj.ax,'Regular Plot','FontSize',obj.fsHeader,'FontWeight',obj.fontWeights{2});
            obj.firstLegend = true;
            hold(obj.ax,'on');
            grid(obj.ax,'on');
        end
        
        %---------------------------
        %Method 13: Set MaxX & MaxY.
        %---------------------------
        function SetMaxXMaxY(obj,maxX,maxY)
            set(obj.ax,'xlim',[0 maxX],'ylim',[0 maxY]);
        end
        
        function NewFigure(obj)
            close all;
            obj.fh = figure(1);
        end
        
        %---------------------------
        %Method 14: Calc R2 squared.
        %---------------------------
        function res = R2squared(obj,oneRepDataArr)
            %t/U/P/F/alpha
            t=1; U=2; P=3;
            %^^^^^^^
            % STEP 1: Set initial data.
            %^^^^^^^
            xi = oneRepDataArr(10:end,t);
            ui = oneRepDataArr(10:end,P);
            sz = length(xi);
            yi = zeros(sz,1);
            for j=1:1:sz
                yi(j) = log(ui(j)/ui(1));
            end
            n=size(yi,2); 
            SUMxiyi=sum(xi.*yi);
            SUMx2=sum(xi.*xi);
            SUMy2=sum(yi.*yi);
            %^^^^^^^
            % STEP 2: Calc sxx,sxy,syy,beta0,beta1.
            %^^^^^^^
            xMean=mean(xi);
            yMean=mean(yi);
            sxy=SUMxiyi-n*xMean*yMean;
            sxx=SUMx2-n*xMean^2;
            syy=SUMy2-n*yMean^2;
            b1 = sxy/sxx;
            %^^^^^^^
            % STEP 3: Calc SSE,MSE,SSR,SST.
            %^^^^^^^
            SSE = syy-b1^2*sxx;
            SSR = b1^2*sxx;
            SST = SSE+SSR;
            %^^^^^^^
            % STEP 4: Calc R^2 squared.
            %^^^^^^^
            R2 = SSR/SST;
            res = R2;
            %R2Adjusted = 1-((1-R2)*(n0-1))/(n0-2-1);
        end



%-----------------------------------------------------------------
%-----------------------------------------------------------------
%-----------------------------------------------------------------
%-----------------------------------------------------------------
%-----------------------------------------------------------------
%-----------------------------------------------------------------
%-----------------------------------------------------------------
%-----------------------------------------------------------------
%-----------------------------------------------------------------
%-----------------------------------------------------------------
%-----------------------------------------------------------------
%-----------------------------------------------------------------
%{
% ########## OPTION 2 ###########
% ########## OPTION 2 ###########
% --- only outcomes are given ---
% --- only outcomes are given ---

% STEP 1: Given data.
% STEP 1: Given data.
n=40;
SUMxi=1971.99;
SUMyi=21888.02;
SUMxiyi=1113184.628;
SUMx2=101773.9637;
SUMy2=12344085.91;
% STEP 2: Calc initial stuff
% STEP 2: Calc initial stuff
xMean=SUMxi/n;
yMean=SUMyi/n;
sxy=SUMxiyi-n*xMean*yMean;
sxx=SUMx2-n*xMean^2;
syy=SUMy2-n*yMean^2;
% STEP 3: Find ARAP
% STEP 3: Find ARAP
b1 = sxy/sxx;
b0 = yMean-b1*xMean;
% STEP 4: Use your Line's Omed to test
% STEP 4: Use your Line's Omed to test
x0=11;
y0 = b0+b1*x0;
% STEP 5: Calc SSE, MSE, SSR, SST, R2
% STEP 5: Calc SSE, MSE, SSR, SST, R2
SSE = syy-b1^2*sxx;
MSE = SSE/(n-2)
SSR = b1^2*sxx
SST = SSE+SSR
R2 = SSR/SST
%}
        
        
        %-------------------------------------
        %Method 20: All Distribution Functions.
        %-------------------------------------
        function x = DetDistFood(obj)
            %Option 1: Determinist
            x=obj.detConstFood;
        end
    
        function x = UnifDist(obj)
            %Option 2: Uniform(a,b)
            u = rand();
            x=obj.unifMinFood+(obj.unifMaxFood-obj.unifMinFood)*u;
        end
    
        function x = ExpDistFood(obj)
            %Option 3: exp(Ex)
            x = exprnd(obj.expExFood);
        end
    
        function x = NormDistFood(obj)
            %Option 4: Norm(mu,sd^2)
            x = max(0,normrnd(obj.normMuFood,obj.normSdFood));
        end
        
        function x = DetDistDup(obj)
            %Option 1: Determinist
            x=obj.detConstDup;
        end
    
        function x = UnifDistDup(obj)
            %Option 2: Uniform(a,b)
            u = rand();
            x=obj.unifMinDup+(obj.unifMaxDup-obj.unifMinDup)*u;
        end
    
        function x = ExpDistDup(obj)
            %Option 3: exp(Ex)
            x = exprnd(obj.expExDup);
        end
    
        function x = NormDistDup(obj)
            %Option 4: Norm(mu,sd^2)
            x = max(0,normrnd(obj.normMuDup,obj.normSdDup));
        end
        
        function FoodDist(obj,distName,par1,par2)
            switch distName
                case "determinist"
                    obj.detConstFood = par1;
                    obj.TimeToCreateFood = @obj.DetDistFood;
                case "exp"
                    obj.expExFood = par1;
                    obj.TimeToCreateFood = @obj.ExpDistFood;
                case "unif"
                    obj.unifMinFood = par1;
                    obj.unifMaxFood = par2;
                    obj.TimeToCreateFood = @obj.UnifDistFood;
                case "norm"
                    obj.normMuFood = par1;
                    obj.normSdFood = par2;
                    obj.TimeToCreateFood = @obj.NormDistFood;
                otherwise
                    disp('There was an error.');
            end
        end
        
        function DupDist(obj,distName,par1,par2)
            switch distName
                case "determinist"
                    obj.detConstDup = par1;
                    obj.TimeToCreateDup = @obj.DetDistDup;
                case "exp"
                    obj.expExDup = par1;
                    obj.TimeToCreateDup = @obj.ExpDistDup;
                    obj.CalcMuExpected = @obj.ExpLaplace;
                case "unif"
                    obj.unifMinDup = par1;
                    obj.unifMaxDup = par2;
                    obj.TimeToCreateDup = @obj.UnifDistDup;
                    obj.CalcMuExpected = @obj.UnifLaplace;
                case "norm"
                    obj.normMuDup = par1;
                    obj.normSdDup = par2;
                    obj.TimeToCreateDup = @obj.NormDistDup;
                otherwise
                    disp('There was an error.');
            end
        end
    end
end