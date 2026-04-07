classdef PlayWithData < handle
    properties %(GetAccess='private', SetAccess='private')
        %---------------------------
        %Group 1: Graphs and Design.
        %---------------------------
        colors     = {'black','r','g','b','m','y','k'};
        lineStyles = {'-','--','-.'};
        fonts = {'Calibri','Arial','Tahoma','Times new roman'};
        fontWeights = {'Normal','Bold'};
        fh;
        ax;
        lgd;
        lgdIndexArr;
        txt;
        %Axes+Title+Legend:
        graphTitle;
        xLabel;
        yLabel;
        fsHeader = 40;
        fsAxesNames = 42;%28
        fsAxesValues = 32;%14
        fsLgd = 26;%26
        fsText = 30;
        %Font Family:
        ffTitle = "Calibri";
        ffAxes = "Calibri";
        ffText = "Calibri";
        
        %Regular Line Plot:
        lineColor = 'black';
        lineStyle = '-';
        lineWidth = 2.5;
        
        %Vertical/Horizontal Plot:
        vhColor = 'b';
        vhStyle = '--';
        vhWidth = 1.5;
        
        %Scatter Plot:
        scatterShape = 'o';
        scatterSize = 300;
        scatterWidth = 1;
        scatterColor = 'b';
        
        %Misc:
        firstLegend;
        gridWidth = 1;
        maxX;
        minX;
        maxY;
        minY;
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
            obj.lgdIndexArr = [];
        end
        
        %---------------------------
        %Method 2: Create New Figure
        %---------------------------
        function NewFigure(obj)
            close all;
            obj.fh = figure(1);
            obj.maxX = 500;
            obj.maxY = 500;
            obj.minX = 0;
            obj.minY = 0;
            obj.ClearFigure();
        end
        
        %----------------------
        %Method 3: Clear Figure
        %----------------------
        function ClearFigure(obj)
            clf(obj.fh)
            obj.ax = axes(obj.fh);
            cla(obj.ax);%          left bot  right  top
            set(obj.ax,'position',[0.1  0.12 0.85  0.80],'FontName',obj.ffTitle,'FontSize',obj.fsAxesValues,'LineWidth',obj.gridWidth,...
                'xlim',[obj.minX obj.maxX],'ylim',[obj.minY obj.maxY]);
            xlabel(obj.ax,obj.xLabel,'FontSize',obj.fsAxesNames,'FontWeight',obj.fontWeights{1},'FontName',obj.ffAxes);
            ylabel(obj.ax,obj.yLabel,'FontSize',obj.fsAxesNames,'FontWeight',obj.fontWeights{1},'FontName',obj.ffAxes);
            title(obj.ax,obj.graphTitle,'FontSize',obj.fsHeader,'FontWeight',obj.fontWeights{2},'FontName',obj.ffTitle);
            obj.firstLegend = true;
            hold(obj.ax,'on');
            grid(obj.ax,'on');
            obj.ax.XAxis.MinorTick = 'on';
            obj.ax.YAxis.MinorTick = 'on';
            obj.lgdIndexArr = [];
        end
        
        %---------------------------
        %Method 4: Line Plot  x Vs y
        %---------------------------
        function Plot_xVy(obj,x,y,legendText)
            plot(obj.ax,x,y,strcat(obj.lineColor,obj.lineStyle),'LineWidth',obj.lineWidth,'MarkerSize',5);
            if (legendText ~= "")
                obj.MyLegend(legendText);
            else
                obj.lgdIndexArr(end+1) = 0;
            end
        end
        
        %-----------------------------
        %Method 5: Scatter Plot x Vs y
        %-----------------------------
        function ScatterPlot_xVy(obj,x,y,legendText)
            scatter1 = scatter(obj.ax,x,y,obj.scatterSize,obj.scatterShape,'linewidth',obj.scatterWidth,'MarkerEdgeColor',obj.scatterColor,'MarkerFaceColor',[1 0 0]); %
            scatter1.MarkerFaceAlpha = 1; % Inside
            scatter1.MarkerEdgeAlpha = 1; % Outside
            if (legendText ~= "")
                obj.MyLegend(legendText);
            else
                obj.lgdIndexArr(end+1) = 0;
            end
        end
        
        %-------------------------------
        %Method 6: Turn to semilogY Plot
        %-------------------------------
        function Plot_TurnToSemiLogY(obj)
            obj.ax.YScale = 'log';
        end
        
        %-------------------------------
        %Method 7: Turn to semilogX Plot
        %-------------------------------
        function Plot_TurnToSemiLogX(obj)
            obj.ax.XScale = 'log';
        end
        
        %----------------------------
        %Method 8: Plot Vertical Line
        %----------------------------
        function Plot_VerticalLine(obj,xValue, minY, maxY, legendText)
            x = [xValue    xValue];
            y = [minY       maxY];
            plot(obj.ax,x,y,strcat(obj.vhColor,obj.vhStyle),'LineWidth',obj.vhWidth,'MarkerSize',5);
            if (legendText ~= "")
                obj.MyLegend(legendText);
            else
                obj.lgdIndexArr(end+1) = 0;
            end
        end
        
        %------------------------------
        %Method 9: Plot Horizontal Line
        %------------------------------
        function Plot_HorizontalLine(obj,yValue, minX, maxX, legendText)
            x = [minX         maxX];
            y = [yValue      yValue];
            plot(obj.ax,x,y,strcat(obj.vhColor,obj.lineStyles{2}),'LineWidth',obj.vhWidth,'MarkerSize',5);
            if (legendText ~= "")
                obj.MyLegend(legendText);
            else
                obj.lgdIndexArr(end+1) = 0;
            end
        end
        
        %--------------------
        %Method 10: Plot Gauge
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
        %Method 11: Set MaxX & MaxY
        %-------------------------
        function SetMinMax_Y(obj,minY,maxY)
            obj.minY = minY;
            obj.maxY = maxY;
            set(obj.ax,'xlim',[obj.minX obj.maxX],'ylim',[obj.minY obj.maxY]);
        end
        
        %-------------------------
        %Method 12: Set MinX & MinY
        %-------------------------
        function SetMinMax_X(obj,minX,maxX)
            obj.minX = minX;
            obj.maxX = maxX;
            set(obj.ax,'xlim',[obj.minX obj.maxX],'ylim',[obj.minY obj.maxY]);
        end
        
        %
        %
        %
        function AddText(obj,xCord,yCord,textStr)
            obj.txt = text(xCord,yCord,textStr,'FontName',obj.ffText);
            obj.txt(1).FontSize = 32;
        end
        
        %----------------------------
        %Method 12: My Dynamic Legend
        %----------------------------
        function MyLegend(obj,newStr)
            if (obj.firstLegend)
                obj.lgd = legend(obj.ax,newStr,'AutoUpdate','off');
                title(obj.lgd,'Legend');
                obj.lgd.FontSize = obj.fsLgd;
                obj.firstLegend = false;
                obj.lgdIndexArr(end+1) = 1;
            else
                obj.lgdIndexArr(end+1) = 1;
                newVal = [obj.lgd.String {newStr}];
                plottedGraphs = flipud(get(gca,'children')); 
                %a = matlab.graphics.chart.primitive.Line;
                a=1;
                for i=1:1:length(plottedGraphs)
                    if(obj.lgdIndexArr(i) == 1)
                        graphsToLabel(a) = plottedGraphs(i);
                        a = a + 1;
                    end
                end
                obj.lgd.PlotChildren = graphsToLabel; 
                obj.lgd.String = newVal;
            end
        end
        
        %-------------------------
        %Method 13: Change X label
        %-------------------------
        function ChangeXlabel(obj,newXlabel)
            obj.xLabel = newXlabel;
            xlabel(obj.ax,obj.xLabel,'FontSize',obj.fsAxesNames,...
            'FontWeight',obj.fontWeights{1},'FontName',obj.ffAxes);
        end
        
        %-----------------------
        %Method 14: Change Y label
        %------------------------
        function ChangeYlabel(obj,newYlabel)
            obj.yLabel = newYlabel;
            ylabel(obj.ax,obj.yLabel,'FontSize',obj.fsAxesNames,...
                'FontWeight',obj.fontWeights{1},'FontName',obj.ffAxes);
        end
        
        %-----------------------
        %Method 15: Change Title
        %-----------------------
        function ChangeTitle(obj,newTitle)
            obj.graphTitle = newTitle;
            title(obj.ax,obj.graphTitle,'FontSize',obj.fsHeader,...
                'FontWeight',obj.fontWeights{2},'FontName',obj.ffTitle);
        end
        
        %----------------------------
        %Method 16: Change Line Width
        %----------------------------
        function ChangeLineWidth(obj,newWidth)
            obj.lineWidth = newWidth;
        end
        
        %----------------------------
        %Method 17: Change Line Color
        %----------------------------
        function ChangeLineColor(obj,newLineColor)
            obj.lineColor = newLineColor;
        end
        
        %-------------------------------------------
        %Method 18: Change Vertical/Horizontal Color
        %-------------------------------------------
        function ChangeVhLineColor(obj,newVHColor)
            obj.vhColor = newVHColor;
        end
        
        %-------------------------------------------
        %Method 18: Change Vertical/Horizontal Style
        %-------------------------------------------
        function ChangeVhLineStyle(obj, newStyleNumber)
            obj.vhStyle = obj.lineStyles{newStyleNumber};
        end
        
        %-------------------------------------------
        %Method 19: Change Vertical/Horizontal Width
        %-------------------------------------------
        function ChangeVhLineWidth(obj,newVHWidth)
            obj.vhWidth = newVHWidth;
        end
        
        %----------------------------
        %Method 20: Change Line Color
        %----------------------------
        function ChangeLineStyle(obj,newStyleNumber)
            obj.lineStyle = obj.lineStyles{newStyleNumber};
        end
        
        %-------------------------------
        %Method 21: Change Scatter Shape
        %-------------------------------
        function ChangeScatterShape(obj,newScatterShape)
            obj.scatterShape = newScatterShape;
        end
        
        %-------------------------------
        %Method 22: Change Scatter Size
        %-------------------------------
        function ChangeScatterSize(obj,newScatterSize)
            obj.scatterSize = newScatterSize;
        end
        
        %-------------------------------
        %Method 23: Change Scatter Color
        %-------------------------------
        function ChangeScatterColor(obj,newScatterColor)
            obj.scatterColor = newScatterColor;
        end
        
        %-------------------------------
        %Method 24: Change Scatter Width
        %-------------------------------
        function ChangeScatterWidth(obj,newScatterWidth)
            obj.scatterWidth = newScatterWidth;
        end
        
        %-------------------------------------
        %Method 25: Change Font Family - Title
        %-------------------------------------
        function ChangeFontFamilyTitle(obj,num)
            obj.ffTitle = obj.fonts{num};
        end
        
        %------------------------------------
        %Method 25: Change Font Family - Axes
        %------------------------------------
        function ChangeFontFamilyAxes(obj,num)
            obj.ffAxes = obj.fonts{num};
        end
        
        %------------------------------------
        %Method 25: Change Font Family - Text
        %------------------------------------
        function ChangeFontFamilyText(obj,num)
            obj.ffText = obj.fonts{num};
        end
        
        %------------------------------------
        %Method 25: Change Font Family - Text
        %------------------------------------
        function xGridEvery(obj,jump)
            xticks(0:jump:obj.maxX);
        end
        
        %-----------------------
        %Method 25: Reset Styles
        %-----------------------
        function ResetStyles(obj)
            obj.ChangeLineStyle(1);
            obj.ChangeLineColor('black');
            obj.ChangeLineWidth(4);
            %---------------------
            obj.ChangeScatterShape();
            obj.ChangeScatterColor();
            obj.ChangeScatterSize();
        end
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        %--------------------------
        %Method 25: Calc R2 squared
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
        %Method 26: Calc Mu Fitted
        %-------------------------
        function obj = CalcMuFitted(obj,x,y)
            %Step 1: Find GrowthRate mu.
            [res , gof] = HisExpFit(x,y);%MyExpFit
            %fprintf('The Constant is: %.4f\n',res.a);
            %fprintf('The muFitted is: %.4f\n',res.b);
            obj = res;
        end
        
        %---------------------------
        %Method 27: Calc Mu Expected
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
        %Method 28: Get Steady State Alphas
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
        %Method 29: RBS for Alpha
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
        
        
        

        
		%------------------------------------------------------------------
		%------------------------------------------------------------------
		%------------------------------------------------------------------
		%------------------------------------------------------------------
		%------------------------------------------------------------------
		%------------------  How to use Play With Data  -------------------
		%------------------  How to use Play With Data  -------------------
		%------------------  How to use Play With Data  -------------------
		%------------------  How to use Play With Data  -------------------
		%------------------  How to use Play With Data  -------------------
		%------------------------------------------------------------------
		%------------------------------------------------------------------
		%------------------------------------------------------------------
		%------------------------------------------------------------------
		%------------------------------------------------------------------
		function HowToUse(obj)
			%---------------------------
			%Stage 1: Declare new figure
			%---------------------------
            pwd.NewFigure();
            
            %----------------------------------------------
			%Stage 2: Define x/y labels, title & zoom level
			%----------------------------------------------
			pwd.ChangeFontFamilyTitle(1);
            pwd.ChangeFontFamilyAxes(1);
            pwd.ChangeFontFamilyText(1);
            
            pwd.ChangeTitle("Regular Plot");
            pwd.ChangeXlabel("time");
			pwd.ChangeYlabel("Cost");
			
            %-----------------------------
			%Stage 3: Plot what you desire
			%-----------------------------
            %Option 1: Line Plot
			pwd.ChangeLineColor('black');
			pwd.ChangeLineWidth(3);
			pwd.ChangeLineStyle(1); %1=Solid
			pwd.Plot_xVy(x1,y1,'Quantity');
			
            %Option 2: ScatterPlot
            pwd.ChangeScatterColor('black');
			pwd.ChangeScatterSize(100);
			pwd.ChangeScatterWidth(1);
			pwd.ChangeScatterShape('o');
			pwd.ScatterPlot_xVy(x1,y1,'Quantity');

            %Option 3: Horizontal/Vertical Line
            pwd.ChangeVhLineColor('magenta');
			pwd.ChangeVhLineStyle(2); %2=Dashed
			pwd.ChangeVhLineWidth(1.5);
			pwd.Plot_VerticalLine(xValue,minY,maxY,"");
            pwd.Plot_HorizontalLine(yValue,minX,maxX);

            %Option 4: Turn to SemiLogX / SemiLogY
            pwd.Plot_TurnToSemiLogX();
			pwd.Plot_TurnToSemiLogY();
            
            %Option 5: Ratio Zoom
            maxX = max(dataSet(:,1));
            maxY = max(dataSet(:,2));
            pwd.SetMinMax_X(0,maxX*1.1);
            pwd.SetMinMax_Y(0,maxY*1.1);
		end  
    end
end