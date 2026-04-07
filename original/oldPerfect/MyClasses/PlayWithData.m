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
        function obj = PlayWithData(obj)
            
        end
        
        %-------------------------
        %Method 2: Calc Mu Fitted.
        %-------------------------
        function obj = CalcMuFitted(obj,oneRepDataArr,forWho)
            %forWho: 2=U, 3=P
            t = 1;
            %Step 1: Find GrowthRate mu.
            x = oneRepDataArr(10:end,t);
            y = oneRepDataArr(10:end,forWho);
            [res , gof] = HisExpFit(x,y);
            %fprintf('The Constant is: %.4f\n',res.a);
            %fprintf('The muFitted is: %.4f\n',res.b);
            obj = res;
        end
        
        %---------------------------
        %Method 3: Calc Mu Expected.
        %---------------------------
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
        
        %------------------------------
        %Method 4: Plot t Vs U/P/F/Alfa
        %------------------------------
        function Plot_xVy(obj,x,y,color,lineStyle,legendText)
            %x vs y: t/U/P/F/alpha vs t/U/P/F/alpha
            plot(obj.ax,x,y,strcat(obj.colors{color},obj.lineStyles{lineStyle}),'LineWidth',obj.lwMain,'MarkerSize',5);
            obj.MyLegend(legendText);
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
        function Plot_fittedU(obj,muFitted, constant)
            %Step 1: Plot Pure constant*e^(muFitted*t)
            ramiFun = @(x)constant*exp(muFitted.*x);
            fplot(obj.ax,ramiFun,[0 500],'r','linewidth',obj.lwMain);
            obj.MyLegend("fittedU");            
        end
        
        %---------------------------
        %Method 7: Plot ProveLinear.
        %---------------------------
        function Plot_ProveLinear(obj,muExpectedU,oneRepDataArrU)
            %Step 1: Plot exptd Line.
            exptdLine = @(x)muExpectedU*x;
            fplot(obj.ax,exptdLine,[0 100],'m','linewidth',obj.lwMain);
            obj.MyLegend("expctdLine");
            %Step 2: Plot fitted line - Create all Dots.
            t=1;
            bigX = oneRepDataArrU(:,t);
            bigY = zeros(size(oneRepDataArrU,1),1);
            who0 = oneRepDataArrU(1,2); %2= U
            for j=1:1:size(oneRepDataArrU,1)
                whoj = oneRepDataArrU(j,2); %2= U
                bigY(j) = log(whoj/who0);
            end
            %Step 3: Plot and hope for straight line.
            scatter(obj.ax,bigX,bigY,70,'black','linewidth',1.2); %,'filled'
            obj.MyLegend("fittedLine");
            %res = bigY(end)/bigX(end);
            %fprintf('The linear shipua is: %0.5f\n',res);
        end

        %-----------------------
        %Method 8: Plot Expected
        %-----------------------
        function Plot_expectedU(obj,muExpected)
            %Step 1: Plot Pure e^(muExp*t)
            ramiFun = @(x)exp(muExpected.*x);
            fplot(obj.ax,ramiFun,[0 500],'g','linewidth',obj.lwMain);
            obj.MyLegend("expctdU");
        end
                
        %------------------------
        %Method 9: RBS for Alpha.
        %------------------------
        function AlphaRBS(obj,fullDataArr)
            %Note: trnsFullData Must have more than 1 rep (i guess?)
            %AlphaRBS: Calcs RBS for alpha at Steady State.
            alfaArr = zeros(1,obj.repNumber);
            a=1; Rep = 7; Alfa = 5;
            curRep = fullDataArr(end,Rep) + 1;
            for i=size(obj.trnsFullData,1):-1:1
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
            obj.firstLegend = true;
        end
        
        %---------------------------
        %Method 14: Calc R2 squared.
        %---------------------------
        function res = R2squared(obj,oneRepDataArr,onWho)
            %Explanation: onWho= 2-U   3-P
            %t/U/P/F/alpha
            t=1; 
            %^^^^^^^
            % STEP 1: Set initial data.
            %^^^^^^^
            xi = oneRepDataArr(10:end,t);
            whoi = oneRepDataArr(10:end,onWho);
            sz = length(xi);
            yi = zeros(sz,1);
            for j=1:1:sz
                yi(j) = log(whoi(j)/whoi(1));
            end
            n = size(yi,2); 
            SUMxiyi = sum(xi.*yi);
            SUMx2 = sum(xi.*xi);
            SUMy2 = sum(yi.*yi);
            %^^^^^^^
            % STEP 2: Calc sxx,sxy,syy,beta0,beta1.
            %^^^^^^^
            xMean = mean(xi);
            yMean = mean(yi);
            sxy = SUMxiyi - n*xMean*yMean;
            sxx = SUMx2 - n*xMean^2;
            syy = SUMy2 - n*yMean^2;
            b1 = sxy/sxx;
            %^^^^^^^
            % STEP 3: Calc SSE,MSE,SSR,SST.
            %^^^^^^^
            SSE = syy - b1^2*sxx;
            SSR = b1^2*sxx;
            SST = SSE + SSR;
            %^^^^^^^
            % STEP 4: Calc R^2 squared.
            %^^^^^^^
            R2 = SSR/SST;
            res = R2;
            %R2Adjusted = 1-((1-R2)*(n0-1))/(n0-2-1);
        end
    end
end