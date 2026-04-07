classdef PlayWithData < handle
    properties %(GetAccess='private', SetAccess='private')
        %---------------------------
        %Group 1: Graphs and Design.
        %---------------------------
        colors     = {'black','b','g','r','m','y','k'};%
        lineStyles = {'-','-','-.','--','-'};
        fonts = {'Arial','Calibri','Tahoma','Times new roman'};
        fontWeights = {'Normal','Bold'};
        fh;
        ax;
        firstLegend;
        fsHeader = 60;
        fsAxesNames = 36;
        fsAxesValues = 36;
        fsLgd = 36;
        lwMain = 4;
        lwSec = 1;
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
            
        end
        
        %---------------------------
        %Method 2: Create New Figure
        %---------------------------
        function NewFigure(obj)
            close all;
            obj.fh = figure(1);
            obj.firstLegend = true;
        end
        
        %----------------------
        %Method 3: Clear Figure
        %----------------------
        function ClearFigure(obj)
            clf(obj.fh)
            obj.ax = axes(obj.fh);
            cla(obj.ax);
            obj.maxX = 500;
            obj.maxY = 500;
            set(obj.ax,'position',[0.2 0.2 0.55 0.65],'FontName',obj.fonts{1},'FontSize',obj.fsAxesNames,'LineWidth',obj.lwMain,...
                'xlim',[0 obj.maxX],'ylim',[0 obj.maxY]);
            xlabel(obj.ax,'Time','FontSize',obj.fsAxesNames,'FontWeight',obj.fontWeights{1});
            ylabel(obj.ax,'Values','FontSize',obj.fsAxesValues);
            title(obj.ax,'Regular Plot','FontSize',obj.fsHeader,'FontWeight',obj.fontWeights{2});
            obj.firstLegend = true;
            hold(obj.ax,'on');
            grid(obj.ax,'on');
        end
        
        %---------------------
        %Method 4: Plot x Vs y
        %---------------------
        function Plot_xVy(obj,x,y,color,lineStyle,legendText)
            %x vs y: t/U/P/F/alpha vs t/U/P/F/alpha
            plot(obj.ax,x,y,strcat(obj.colors{color},obj.lineStyles{lineStyle}),'LineWidth',obj.lwMain,'MarkerSize',5);
            obj.MyLegend(legendText);
        end
        
        %----------------------------
        %Method 5: ScatterPlot x Vs y
        %----------------------------
        function ScatterPlot_xVy(obj,x,y,dotSize,color,legendText)
            %x vs y: t/U/P/F/alpha vs t/U/P/F/alpha
            scatter(obj.ax,x,y,dotSize,obj.colors{color},'linewidth',obj.lwSec); %,'filled'
            obj.MyLegend(legendText);
        end
        
        %-------------------------
        %Method 6: Set MaxX & MaxY
        %-------------------------
        function SetMaxXMaxY(obj,maxX,maxY)
            set(obj.ax,'xlim',[0 maxX],'ylim',[0 maxY]);
            obj.maxX = maxX;
            obj.maxY = maxY;
        end
        
        %---------------------------
        %Method 7: My Dynamic Legend
        %---------------------------
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
        
        %-----------------------
        %Method 8: Change X label
        %------------------------
        function ChangeXlabel(obj,newXlabel)
            xlabel(obj.ax,newXlabel);
        end
        
        %-----------------------
        %Method 9: Change Y label
        %------------------------
        function ChangeYlabel(obj,newYlabel)
            ylabel(obj.ax,newYlabel);
        end
        
        %-----------------------
        %Method 10: Change Title
        %-----------------------
        function ChangeTitle(obj,newTitle)
            title(obj.ax,newTitle);
        end
        
        
        
        
        
        
        
        %-------------------------
        %Method 888: Add scale units
        %-------------------------
        function AddScaleUnits(obj,xUnits,yUnits)
            xt = [     -0.1*obj.maxX         (obj.maxX+0.1*obj.maxX)];
            yt = [(obj.maxY+0.1*obj.maxY)               0];
            str = {xUnits , yUnits};
            text(obj.ax,xt,yt,str,'FontSize',22)
        end
        
        
        
        
        
        
        
        
        
        %------------------------
        %Method 2: Calc Mu Fitted
        %------------------------
        function obj = CalcMuFitted(obj,x,y)
            %Step 1: Find GrowthRate mu.
            [res , gof] = HisExpFit(x,y);%MyExpFit
            %fprintf('The Constant is: %.4f\n',res.a);
            %fprintf('The muFitted is: %.4f\n',res.b);
            obj = res;
        end
        
        %--------------------------
        %Method 3: Calc Mu Expected
        %--------------------------
        function obj = CalcMuExpected_Exp(obj,alpha,expEx)
            obj = alpha/expEx;
        end
        %or...
        function obj = CalcMuExpected_Unif(obj,unifMin,unifMax,alpha,vertexes)
            % STEP 1: The non-dependant.
            a = unifMin*vertexes;
            b = unifMax*vertexes;
            syms g
            % STEP 2: Left Side (The Equation)
            leftSide = (1+alpha)*(exp(-a*g)-exp(-b*g))/(g*(b-a));
            % STEP 3: Right Side
            rightSide = 1;
            % STEP 4: Solve by MATLAB'S Function.
            muExpected = double(vpasolve(leftSide == rightSide,g));
            obj = muExpected;
        end
        
        %---------------------------
        %Method 7: Plot ProveLinear.
        %---------------------------
        function Plot_ProveLinear(obj,x_fitted,y_fitted,muExpected)
            %Step 1: Plot exptd Line.
            x_expected = [0 100];
            y_expected = @(x)muExpected*x;
            fplot(obj.ax,x_expected,y_expected,'m','linewidth',obj.lwMain);
            obj.MyLegend("expctdLine");
            %Step 2: Plot fitted line - Create all Dots.
            y_line = zeros(length(y_fitted),1);
            U0 = y_fitted(1);
            for j=1:1:length(y_line)
                Uj = y_fitted(j); %2= U
                y_line(j) = log(Uj/U0);
            end
            %Step 3: Plot and hope for straight line.
            scatter(obj.ax,x_fitted,y_line,70,'black','linewidth',obj.lwSec); %,'filled'
            obj.MyLegend("fittedLine");
            %res = bigY(end)/bigX(end);
            %fprintf('The linear shipua is: %0.5f\n',res);
        end

        %---------------------------------
        %Method 9: Get Steady State Alphas
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
        
        
        %-----------------------
        %Method 9: RBS for Alpha
        %-----------------------
        function AlphaRBS(obj,steadyStateAlphas)
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
            %------------------------------
            %Step 2: Plot Gauge for ssAlpha
            %------------------------------
            low = RBS_low*100;
            hi = RBS_hi*100;
            if (low == hi)
                hi = hi + 0.000001;
            end 
            rbsGauge = uigauge(uifigure,'circular');
            rbsGauge.MajorTicks = 0:10:100;
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
            rbsGauge.ScaleColors = gaugeColors;
            rbsGauge.ScaleColorLimits = gaugeColorLimits;
            rbsGauge.FontSize = 28;
            rbsGauge.Position = [150 90 250 250];
            rbsGauge.Value = alfaMean*100; % obj.Tnow/obj.Tmax*100;
        end
        
        %---------------------------
        %Method 14: Calc R2 squared.
        %---------------------------
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
            %-----------------------------
            % STEP 3: Calc SSE,MSE,SSR,SST
            %-----------------------------
            SSE = syy - b1^2*sxx;
            SSR = b1^2*sxx;
            SST = SSE + SSR;
            %-------------------------
            % STEP 4: Calc R^2 squared
            %-------------------------
            R2 = SSR/SST;
            R2Adjusted = 1-((1-R2)*(n-1))/(n-2-1);
            res = [R2 , R2Adjusted];
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
    end
end