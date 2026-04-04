classdef PlayWithData < handle
    properties %(GetAccess='private', SetAccess='private')
        %---------------------------
        %Group 1: Graphs and Design.
        %---------------------------
        colors     = {'black','r','g','b','m','y','k'};%
        lineStyles = {'-','-','-.','--','-'};
        fonts = {'Arial','Calibri','Tahoma','Times new roman'};
        fontWeights = {'Normal','Bold'};
        fh;
        ax;
        graphTitle;
        xLabel;
        yLabel;
        firstLegend;
        fsHeader = 40;
        fsAxesNames = 28;
        fsAxesValues = 16;
        fsLgd = 26;
        gridWidth = 1;
        lwMain = 2.5;
        lwSec = 1.5;
        maxX
        maxY
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
        %---------------------
        %Method 1: Constructor
        %---------------------
        function obj = PlayWithData(obj)
            obj.graphTitle = "change me";
            obj.xLabel = "change me";
            obj.yLabel = "change me";
        end
        
        %---------------------------
        %Method 2: Create New Figure
        %---------------------------
        function NewFigure(obj)
            close all;
            obj.fh = figure(1);
            obj.maxX = 500;
            obj.maxY = 500;
            obj.ClearFigure();
        end
        
        %----------------------
        %Method 3: Clear Figure
        %----------------------
        function ClearFigure(obj)
            clf(obj.fh)
            obj.ax = axes(obj.fh);
            cla(obj.ax);
            set(obj.ax,'position',[0.2 0.2 0.55 0.65],'FontName',obj.fonts{1},'FontSize',obj.fsAxesValues,'LineWidth',obj.gridWidth,...
                'xlim',[0 obj.maxX],'ylim',[0 obj.maxY]);
            xlabel(obj.ax,obj.xLabel,'FontSize',obj.fsAxesNames,'FontWeight',obj.fontWeights{1});
            ylabel(obj.ax,obj.yLabel,'FontSize',obj.fsAxesNames,'FontWeight',obj.fontWeights{1});
            title(obj.ax,obj.graphTitle,'FontSize',obj.fsHeader,'FontWeight',obj.fontWeights{1});
            obj.firstLegend = true;
            hold(obj.ax,'on');
            grid(obj.ax,'on');
            obj.ax.XAxis.MinorTick = 'on';
            obj.ax.YAxis.MinorTick = 'on';
        end
        
        %--------------------------
        %Method 4: Plot Line x Vs y
        %--------------------------
        function Plot_xVy(obj,x,y,color,lineStyle,legendText)
            plot(obj.ax,x,y,strcat(obj.colors{color},obj.lineStyles{lineStyle}),'LineWidth',obj.lwMain,'MarkerSize',5);
            if (legendText ~= "")
                obj.MyLegend(legendText);
            end
        end
        
        %----------------------------
        %Method 5: Plot Vertical Line
        %----------------------------
        function Plot_VerticalLine(obj,xValue,height,color)
            x = [xValue      xValue];
            y = [   0   height*obj.maxY];
            plot(obj.ax,x,y,strcat(obj.colors{color},obj.lineStyles{4}),'LineWidth',obj.lwSec,'MarkerSize',5);
        end
        
        %------------------------------
        %Method 6: Plot Horizontal Line
        %------------------------------
        function Plot_HorizontalLine(obj,yValue,width,color)
            x = [  0   width*obj.maxX];
            y = [yValue      yValue];
            plot(obj.ax,x,y,strcat(obj.colors{color},obj.lineStyles{4}),'LineWidth',obj.lwSec,'MarkerSize',5);
        end
        
        %----------------------------
        %Method 7: ScatterPlot x Vs y
        %----------------------------
        function ScatterPlot_xVy(obj,x,y,dotSize,color,legendText)
            scatter(obj.ax,x,y,dotSize,obj.colors{color},'linewidth',obj.lwSec); %,'filled'
            if (legendText ~= "")
                obj.MyLegend(legendText);
            end
        end
        
        %--------------------
        %Method 8: Plot Gauge
        %--------------------
        function ret = PlotGauge(obj,min,max,statistics)
            %------------------------
            %Step 1: Create new gauge
            %------------------------
            rbsGauge = uigauge(uifigure,'semicircular'); %circular, semicircular, linear
            %---------------------
            %Step 2: Set Min & Max
            %---------------------
            rbsGauge.Limits = [min max];
            %-----------------------------------
            %Step 3: Set who the Minor Ticks are 
            %-----------------------------------
            step = (max-min)/10;
            rbsGauge.MajorTicks = min:step:max;
            
            miniStep = step/5;
            rbsGauge.MinorTicks = min:miniStep:max;
            
            %-----------------------------------
            %Step 4: Set the major labels values
            %-----------------------------------
            curLabel = min;
            for i = 1:1:length(rbsGauge.MajorTickLabels)
                rbsGauge.MajorTickLabels{i} = num2str(curLabel);
                curLabel = curLabel + step;
            end
            %----------------------------------
            %Step 5: Set ranges amount & values
            %----------------------------------
            rbsGauge.ScaleColorLimits = [   min statistics(1);  %Red
                                            statistics(1) statistics(2);  %Yellow
                                            statistics(2) max]; %Yellow];%Red
            %--------------------------
            %Step 6: Set ranges' colors
            %--------------------------
            rbsGauge.ScaleColors = [1 0.5  0;
                                    0  1   0;
                                    1 0.5  0];
            %-----------------------------
            %Step 7: Big arrow point value
            %-----------------------------
            rbsGauge.Value = statistics(3);
            %----------------------------
            %Step 8: Major tick font size
            %----------------------------
            rbsGauge.FontSize = 22;
            %---------------------------------
            %Step 9: Gauge's Size and position
            %---------------------------------
            dontTouch = 10;
            size = 530; %in pixels! You can play with this
            rbsGauge.Position = [dontTouch dontTouch size size];
            ret = rbsGauge;
        end
        
        %-------------------------
        %Method 9: Set MaxX & MaxY
        %-------------------------
        function SetMaxXMaxY(obj,maxX,maxY)
            set(obj.ax,'xlim',[0 maxX],'ylim',[0 maxY]);
            obj.maxX = maxX;
            obj.maxY = maxY;
        end
        
        %----------------------------
        %Method 10: My Dynamic Legend
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
        
        %-------------------------
        %Method 11: Change X label
        %-------------------------
        function ChangeXlabel(obj,newXlabel)
            obj.xLabel = newXlabel;
            xlabel(obj.ax,obj.xLabel,'FontSize',obj.fsAxesNames,'FontWeight',obj.fontWeights{1});
        end
        
        %-----------------------
        %Method 12: Change Y label
        %------------------------
        function ChangeYlabel(obj,newYlabel)
            obj.yLabel = newYlabel;
            ylabel(obj.ax,obj.yLabel);
            ylabel(obj.ax,obj.yLabel,'FontSize',obj.fsAxesNames,'FontWeight',obj.fontWeights{1});
        end
        
        %-----------------------
        %Method 13: Change Title
        %-----------------------
        function ChangeTitle(obj,newTitle)
            obj.graphTitle = newTitle;
            title(obj.ax,obj.graphTitle,'FontSize',obj.fsHeader,'FontWeight',obj.fontWeights{1});
        end
        
        %--------------------------
        %Method 14: Calc R2 squared
        %--------------------------
        function res = R2squared(obj,xi,yi)
            %---------------------------------
            % STEP 1: Calc SUMxiyi SUMx2 SUMy2
            %---------------------------------
            n = length(yi); 
            SUMxiyi = sum(xi.*yi);
            SUMx2 = sum(xi.*xi);
            SUMy2 = sum(yi.*yi);
            %-------------------------------------
            % STEP 2: Calc sxx,sxy,syy,beta0,beta1
            %-------------------------------------
            xMean = mean(xi);
            yMean = mean(yi);
            sxy = SUMxiyi - n*xMean*yMean;
            sxx = SUMx2 - n*xMean^2;
            syy = SUMy2 - n*yMean^2;
            b1 = sxy/sxx;
            b0 = yMean-b1*xMean;
            %-----------------------------
            % STEP 3: Calc SSE,MSE,SSR,SST
            %-----------------------------
            SSE = syy - b1^2*sxx;
            SSR = b1^2*sxx;
            SST = SSE + SSR;
            MSE = SSE/(n-2);
            MSR = SSR/1;
            MST = MSR+MSE;
            fprintf('--------\n');
            fprintf('Stage 1:\n');
            fprintf('--------\n');
            fprintf('SSE= %.4f\n',SSE);
            fprintf('SSR= %.4f\n',SSR);
            fprintf('SST= %.4f\n',SST);
            fprintf('MSE= %.4f\n',MSE);
            fprintf('MSR= %.4f\n',MSR);
            fprintf('MST= %.4f\n\n',MST);
            fprintf('--------\n');
            fprintf('Stage 2:\n');
            fprintf('--------\n');
            fprintf('The betaHat0 is: %.5f\n',b0);
            fprintf('The betaHat1 is: %.5f\n',b1);
            fprintf('The fitted model is: yi=%.4f+%.4f*xi\n\n',b0,b1);
            %-------------------------
            % STEP 4: Calc R^2 squared
            %-------------------------
            R2 = SSR/SST;
            R2Adjusted = 1-((1-R2)*(n-1))/(n-2-1);
            res = [R2 , R2Adjusted];
            fprintf('--------\n');
            fprintf('Stage 3:\n');
            fprintf('--------\n');
            fprintf('The R^2 is: %.7f\n',R2);
            fprintf('The R^2 Adjusted is: %.7f\n\n',R2Adjusted);
        end
        
        %-------------------------
        %Method 15: Calc Mu Fitted
        %-------------------------
        function obj = CalcMuFitted(obj,x,y)
            %Step 1: Find GrowthRate mu.
            [res , gof] = HisExpFit(x,y);%MyExpFit
            %fprintf('The Constant is: %.4f\n',res.a);
            %fprintf('The muFitted is: %.4f\n',res.b);
            obj = res;
        end
        
        %---------------------------
        %Method 16: Calc Mu Expected
        %---------------------------
        function obj = CalcMuExpected_Exp(obj,alpha,expEx)
            obj = alpha/expEx;
        end
        %or...
        function obj = CalcMuExpected_Unif(obj,unifMin,unifMax,alpha)
            % STEP 1: The non-dependant.
            a = unifMin;
            b = unifMax;
            syms g
            % STEP 2: Left Side (The Equation)
            leftSide = (1+alpha)*(exp(-a*g)-exp(-b*g))/(g*(b-a));
            % STEP 3: Right Side
            rightSide = 1;
            % STEP 4: Solve by MATLAB'S Function.
            muExpected = double(vpasolve(leftSide == rightSide,g));
            obj = muExpected;
        end
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        %---------------------------------
        %Method 17: Get Steady State Alphas
        %---------------------------------
        function ret = getSteadyStateAlphas(obj,alfaSignal)
            %Note: alfaSignal Must have more than 1 rep!
            %it's for AlphaRBS which calcs RBS for alphas at Steady State.
            numOfReps = alfaSignal(end,end);
            Rep = size(alfaSignal,2);
            a=1;
            curRep = numOfReps + 1;
            alfaArr = zeros(1,numOfReps);
            for i = size(alfaSignal,1):-1:1
                if (curRep > alfaSignal(i,Rep))
                    curRep = curRep - 1;
                    alfaArr(a) = alfaSignal(i,5); %5= Alfa
                    a=a+1;
                end
            end
            ret = alfaArr;
        end
        
        %------------------------
        %Method 18: RBS for Alpha
        %------------------------
        function ret = AlphaRBS(obj,steadyStateAlphas)
            %----------------------------
            %Step 1: Calc RBS for ssAlpha
            %----------------------------
            n = length(steadyStateAlphas);
            alfaMean = mean(steadyStateAlphas);
            sd = std(steadyStateAlphas);
            tcr = 1.96; % == 0.9750 
            RBS_low = alfaMean - tcr*sd/sqrt(n);
            RBS_hi = alfaMean + tcr*sd/sqrt(n);
            fprintf('The RBS for alfa is: [%0.3f,%0.3f]\n',RBS_low,RBS_hi);
            ret = [RBS_low, RBS_hi, alfaMean];
        end
        
        
        

        
        
        
        
        
        %-----------------------
        %Method 19: Do Animation
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
    end
end