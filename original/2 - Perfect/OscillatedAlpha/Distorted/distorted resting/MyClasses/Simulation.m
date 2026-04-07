classdef Simulation < handle
    properties %(GetAccess='private', SetAccess='private')
        %-------------------------------
        %Group 1: Event-Programming Core.
        %-------------------------------
        Now;    % List 1.
        CEL;    % List 2.
        FEL;    % List 3.
        DL1;    % List 4.
        DL2;    % List 5.
        Us;     % Changes 1.
        Ps;     % Changes 2.
        Fs;     % Changes 3.
        UsResting;
        Tnow;   % Updates.
        h = 2;
        k = 1;
        U_Start;% Init: User Defined 1
        P_Start;% Init: User Defined 2
        F_Start;% Init: User Defined 3
        alpha_Start;
        alpha;% Fixed or changes
        alphaSS; % Alpha at stable state.
        alphaSSNew;
        Tmax;   %=2*60; %2=Hours. 60=Minutes.
        Umax;   %num of Us to double to.
        Pmax;   %num of Ps to double to.
        envChange;
        ctrlReact;
        repNumber;
        FsCreated;
        timerVal;
        columns;
        unTrnsDataU;
        unTrnsDataAlfa;
        
        %Distribution Variables:
        %         [expEx , normMu , normSd , unifMin , unifMax , detConst]
        fArr_Start    =       [-999 -999];
        pArr_Start    =       [-999 -999];
        uArr_Start    =       [-999 -999];
        uRestArr_Start=       [-999 -999];
        fArr;
        pArr;
        uArr;
        uRestArr;
        TimeToCreateF;
        TimeToCreateP;
        TimeToCreateU;
        TimeToRestU;

        %Visual Gauge:
        gauge;
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
        function obj = Simulation(columns)
            %obj.NewFigure();
            obj.repNumber = 0;
            obj.columns = columns;
            obj.gauge = uigauge(uifigure,'circular');
            obj.gauge.MajorTicks = [0 10 20 30 40 50 60 70 80 90 100];
            obj.gauge.MajorTickLabels = {'0', '10', '20', '30', '40', '50', '60', '70', '80', '90', '100'};
            obj.gauge.ScaleColors = [0.470588235294118 0.670588235294118 0.188235294117647;0 1 0;1 1 0;1 0 0];
            obj.gauge.ScaleColorLimits = [50 100;50.1 75;25.1 50;0 25];
            obj.gauge.FontSize = 18;
            obj.gauge.Position = [150 90 250 250];
        end
        
        %----------------------
        %Method 3: Reset stuff.
        %----------------------
        function Reset(obj)
            %Initialize 1: Reset all Variables.
            obj.Us = obj.U_Start;
            obj.Ps = obj.P_Start;
            obj.Fs = obj.F_Start;
            obj.FsCreated = obj.F_Start;
            obj.UsResting = 0;
            obj.fArr = obj.fArr_Start;
            obj.pArr = obj.pArr_Start;
            obj.uArr = obj.uArr_Start;
            obj.uRestArr = obj.uRestArr_Start;
            obj.alpha = obj.alpha_Start;
            obj.Tnow = 0;
            obj.unTrnsDataU = DataTable(obj.columns);
            obj.unTrnsDataAlfa = DataTable(obj.columns);
            obj.Now = MyList();
            obj.CEL = MyList();
            obj.FEL = MyList();
            obj.DL1 = MyList();
            obj.DL2 = MyList();
            %Initialize 2: Write Ps in Diary.
            arr = zeros(1,2);
            arr(1) = 1;     %1= eventCode , 1=Take Care of Food arrival.
            data = -1;      %data= eventTime
            for i = 1:1:obj.Ps
                curP = Entity(data,arr);
                obj.MakeFood(curP);
            end
            %Initialize 3: Create U's and feed them/declare hungery.
            arr = zeros(1,2);
            data = -1;      %data= eventTime
            for i = 1:1:obj.Us
                curU = Entity(data,arr);
                obj.DL1.Enque(curU);
            end
            for i = 1:1:obj.Us
                if(obj.Us >= obj.ctrlReact)
                    obj.alpha = obj.alphaSS/(1 + (obj.DL1.size*obj.k/obj.Fs)^obj.h);
                end
                u = rand();
                if(obj.Fs > 0)
                    %To which one? U or P?
                    if(u <= obj.alpha)
                        obj.CreateU(obj.DL1.Deque.GetEntity);
                    else
                        obj.CreateP(obj.DL1.Deque.GetEntity);
                    end
                end
            end
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
            %             1        2      3      4             5             6            7      8         9       10    11
            dataArr = [obj.Tnow,obj.Us,obj.Ps,obj.FsCreated,obj.UsResting,obj.DL1.size,obj.Fs,obj.alpha,obj.alphaSS,0,obj.repNumber];
            obj.unTrnsDataU.AddRow(dataArr);
            obj.unTrnsDataAlfa.AddRow(dataArr);
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
                    if (obj.Tnow > obj.Tmax || obj.Us >= obj.Umax) % || obj.Ps >= obj.Pmax
                        EndSim = true;
                        break;
                    else
                        switch obj.Now.GetFirst.GetEntity.arr(1) %1= eventCode
                            case 1 % Code 1: Treat Food Arrival.
                                obj.TreatFArrival;
                            case 2 % Treat End of U Create's P
                                obj.TreatEndOfMakingP;
                            case 3 % Treat End of U Creates U
                                obj.TreatEndOfMakingU;
                            case 4 % Treat End of Resting U
                                obj.TreatEndOfRestingU;
                            otherwise
                                disp('There was an error.');
                        end
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
        
        %----------------------------
        %Method 8: Pull Future Events
        %----------------------------
        function PullFutureEvents(obj)
            obj.Now.Enque(obj.FEL.Deque.GetEntity);
            obj.Tnow = obj.Now.GetFirst.GetEntity.data;
            %^^^^^^^^^^^^^
            %Gaue Version: Time/Us/Ps Ratio
            %^^^^^^^^^^^^^
            arr = zeros(1,2); %,3
            arr(1) = obj.Tnow/obj.Tmax*100; % timeRatio 
            arr(2) = obj.Us/obj.Umax*100;   % uRatio 
            %arr(3) = obj.Ps/obj.Pmax*100;   % pRatio
            obj.gauge.Value = max(arr);
            
            pause (0.0000001);
            while(obj.FEL.size > 0 && obj.FEL.GetFirst.GetEntity.data == obj.Tnow) %data= eventTime
                obj.CEL.Enque(obj.FEL.Deque.GetEntity);
            end
        end
        
        %------------------------------------
        %Method 4: Create Event 1 - Make Food
        %------------------------------------
        function MakeFood(obj,curP)    
            %Step 1: Time to Create.
            x = obj.TimeToCreateF(obj.fArr(1),obj.fArr(2));
            curP.data = obj.Tnow + x;
            %Step 2: Update Entity's eventCode.
            %entity.arr(1) = 1;  %1= Treat Food Arrival -> PreDefined
            %Step 3: Add Event to Diary.
            obj.FEL.SmartEnque(curP);
        end
        
        %----------------------------------
        %Method 5: Create Event 2 - CreateP
        %----------------------------------
        function CreateP(obj,curU)
            %Step 1: Time to Create.
            x = obj.TimeToCreateP(obj.pArr(1),obj.pArr(2));
            curU.data = obj.Tnow + x; %data = eventTime 
            %Step 2: Update Entity's eventCode.
            curU.arr(1) = 2;  %2= Treat End of P Creation.
            %Step 3: Eat Food.
            obj.Fs = obj.Fs - 1;
            %Step 4: Add Event to Diary.
			obj.FEL.SmartEnque(curU);
        end
        
        %------------------------------------
        %Method 5: Create Event - Duplication.
        %------------------------------------
        function CreateU(obj,curU)
            %Step 1: Time to Create.
            x = obj.TimeToCreateU(obj.uArr(1),obj.uArr(2));
            curU.data = obj.Tnow + x; %data = eventTime 
            %Step 2: Update Entity's eventCode.
            curU.arr(1) = 3;  %3= Treat End of U Creation.
            %Step 3: Eat Food.
            obj.Fs = obj.Fs - 1;
            %Step 4: Add Event to Diary.
			obj.FEL.SmartEnque(curU);
        end
        
        %--------------------------------
        %Method 6: Create Event - Go Rest
        %--------------------------------
        function GoRest(obj,curU)
            %Step 1: Time to Create.
            x = obj.TimeToRestU(obj.uRestArr(1),obj.uRestArr(2));
            curU.data = obj.Tnow + x; %data = eventTime 
            %Step 2: Update Entity's eventCode.
            curU.arr(1) = 4;  %4= Treat End of Resting U.
            %Step 3: Add Event to Diary.
			obj.FEL.SmartEnque(curU);
        end
        
        %----------------------------
        %Method 6: Treat Food arrival.
        %----------------------------
        function TreatFArrival(obj)
            %Step 1: P - The Food Creator.
            curP = obj.Now.Deque.GetEntity;
            %Step 2: New Food Arrived.
            obj.Fs = obj.Fs + 1;
            obj.FsCreated = obj.FsCreated + 1;
            %Step 3: A hungry U eats new Food (if there is one).
            if (obj.DL1.size > 0)
                %But which one he makes? U or P?
                %There is Food 100%, so we don't need to check if we have
                %some. We just got a shipping of 1 F!
                u = rand();
                if(obj.Us >= obj.ctrlReact)
                    obj.alpha = obj.alphaSS/(1 + (obj.DL1.size*obj.k/obj.Fs)^obj.h);
                end
                if(u <= obj.alpha)
                    obj.CreateU(obj.DL1.Deque.GetEntity);
                else
                    obj.CreateP(obj.DL1.Deque.GetEntity);
                end
            end
            %Step 4: Old P starts creating Next Food.
            obj.MakeFood(curP);
            %Step 5: Log the change.
            dataArr = [obj.Tnow,obj.Us,obj.Ps,obj.FsCreated,obj.UsResting,obj.DL1.size,obj.Fs,obj.alpha,obj.alphaSS,toc(obj.timerVal),obj.repNumber];
            %obj.unTrnsDataU.AddRow(dataArr);
            obj.unTrnsDataAlfa.AddRow(dataArr);
        end
        
        %--------------------------------------------
        %Method 7: Treat Event 2 - End of P Creation
        %--------------------------------------------
        function TreatEndOfMakingP(obj)
            %Step 1: U - The Creator of P.
            curU = obj.Now.Deque.GetEntity;
            %Step 2: New P is Born!
            obj.Ps = obj.Ps + 1;
            arr = zeros(1,2);
            arr(1) = 1;     %1= eventCode , 1=Treat Food arrival.
            data = -1;      %-1= null for eventTime
            curP = Entity(data,arr);
            %Step 3: New P creates Next Food.
            obj.MakeFood(curP);
            %Step 4: Old U Goes to Rest
            obj.UsResting = obj.UsResting + 1;
            obj.GoRest(curU);
            %Step 5: Log the change.
            dataArr = [obj.Tnow,obj.Us,obj.Ps,obj.FsCreated,obj.UsResting,obj.DL1.size,obj.Fs,obj.alpha,obj.alphaSS,toc(obj.timerVal),obj.repNumber];
            %obj.unTrnsDataU.AddRow(dataArr);
            obj.unTrnsDataAlfa.AddRow(dataArr);
        end
        
        function TreatEndOfMakingU(obj)
            %Step 1: Old U Goes to Rest
            obj.GoRest(obj.Now.Deque.GetEntity);
            obj.UsResting = obj.UsResting + 1;
            %Step 2: New U is born!
            obj.Us = obj.Us + 1;
            arr = zeros(1,2);
            arr(1) = -1;     %1= eventCode , -1= currently unknown.
            data = -1;      %-1= eventTime currently unknown.
            newU = Entity(data,arr);
            if (obj.Us == obj.envChange)
                obj.fArr = obj.fArr*2;
                obj.alphaSS = obj.alphaSSNew;
            end
            %Step 3: Declare newU as hungry.
            obj.DL1.Enque(newU);
            %Step 4: New U work if it can or declared hungry.
            %But if can work, which one does it make? U or P?
            u = rand();
            if(obj.Us >= obj.ctrlReact)
                obj.alpha = obj.alphaSS/(1 + (obj.DL1.size*obj.k/obj.Fs)^obj.h);
            end
            if(obj.Fs > 0)
                if(u <= obj.alpha)
                    obj.CreateU(obj.DL1.Deque.GetEntity);
                else
                    obj.CreateP(obj.DL1.Deque.GetEntity);
                end
            end
            %Step 5: Log the change.
            dataArr = [obj.Tnow,obj.Us,obj.Ps,obj.FsCreated,obj.UsResting,obj.DL1.size,obj.Fs,obj.alpha,obj.alphaSS,toc(obj.timerVal),obj.repNumber];
            obj.unTrnsDataU.AddRow(dataArr);
            obj.unTrnsDataAlfa.AddRow(dataArr);
        end
        
        function TreatEndOfRestingU(obj)
            %Step 1: U - After Resting.
            curU = obj.Now.Deque.GetEntity;
            obj.UsResting = obj.UsResting - 1;
            %Step 2: Declare it as hungry.
            obj.DL1.Enque(curU);
            %Step 3: Feed it if theres food and remove it from hungry list,
            %and if you do, decide which one it makes: U or P.
            u = rand();
            if(obj.Us >= obj.ctrlReact)
                obj.alpha = obj.alphaSS/(1 + (obj.DL1.size*obj.k/obj.Fs)^obj.h);
            end
            if(obj.Fs > 0)
                if(u <= obj.alpha)
                    %Decided to create U and there is food.
                    obj.CreateU(obj.DL1.Deque.GetEntity);
                else
                    %Decided to create P and there is food.
                    obj.CreateP(obj.DL1.Deque.GetEntity);
                end
            end
            %Step 4: Log the change.
            dataArr = [obj.Tnow,obj.Us,obj.Ps,obj.FsCreated,obj.UsResting,obj.DL1.size,obj.Fs,obj.alpha,obj.alphaSS,toc(obj.timerVal),obj.repNumber];
            %obj.unTrnsDataU.AddRow(dataArr);
            obj.unTrnsDataAlfa.AddRow(dataArr); 
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
        
        %-------------------------------------
        %Method 20: All Distribution Functions.
        %-------------------------------------
        function x = Dist_Det(obj,const,~)
            %Option 1: Determinist
            x = const;
        end
    
        function x = Dist_Unif(obj,minim,maxim)
            %Option 2: Uniform(a,b)
            u = rand();
            x=minim+(maxim-minim)*u;
        end
    
        function x = Dist_Exp(obj,Ex,~)
            %Option 3: exp(Ex)
            x = exprnd(Ex);
        end
    
        function x = Dist_Norm(obj,mu,sd)
            %Option 4: Norm(mu,sd^2)
            x = max(0,normrnd(mu,sd));
        end
        
        function DistFood(obj,distName,par1,par2)
            switch distName
                case "determinist"
                    obj.fArr_Start(1) = par1;
                    obj.TimeToCreateF = @obj.Dist_Det;
                case "exp"
                    obj.fArr_Start(1) = par1;
                    obj.TimeToCreateF = @obj.Dist_Exp;
                case "unif"
                    obj.fArr_Start(1) = par1;
                    obj.fArr_Start(2) = par2;
                    obj.TimeToCreateF = @obj.Dist_Unif;
                case "norm"
                    obj.fArr_Start(1) = par1;
                    obj.fArr_Start(2) = par2;
                    obj.TimeToCreateF = @obj.Dist_Norm;
                otherwise
                    disp('There was an error.');
            end
        end
        
        function DistCreatingP(obj,distName,par1,par2)
            switch distName
                case "determinist"
                    obj.pArr_Start(1) = par1;
                    obj.TimeToCreateP = @obj.Dist_Det;
                case "exp"
                    obj.pArr_Start(1) = par1;
                    obj.TimeToCreateP = @obj.Dist_Exp;
                case "unif"
                    obj.pArr_Start(1) = par1;
                    obj.pArr_Start(2) = par2;
                    obj.TimeToCreateP = @obj.Dist_Unif;
                case "norm"
                    obj.pArr_Start(1) = par1;
                    obj.pArr_Start(2) = par2;
                    obj.TimeToCreateP = @obj.Dist_Norm;
                otherwise
                    disp('There was an error.');
            end
        end
            
        function DistCreatingU(obj,distName,par1,par2)
            switch distName
                case "determinist"
                    obj.uArr_Start(1) = par1;
                    obj.TimeToCreateU = @obj.Dist_Det;
                case "exp"
                    obj.uArr_Start(1) = par1;
                    obj.TimeToCreateU = @obj.Dist_Exp;
                case "unif"
                    obj.uArr_Start(1) = par1;
                    obj.uArr_Start(2) = par2;
                    obj.TimeToCreateU = @obj.Dist_Unif;
                case "norm"
                    obj.uArr_Start(1) = par1;
                    obj.uArr_Start(2) = par2;
                    obj.TimeToCreateU = @obj.Dist_Norm;
                otherwise
                    disp('There was an error.');
            end
        end
        
        function DistRestingU(obj,distName,par1,par2)
            switch distName
                case "determinist"
                    obj.uRestArr_Start(1) = par1;
                    obj.TimeToRestU = @obj.Dist_Det;
                case "exp"
                    obj.uRestArr_Start(1) = par1;
                    obj.TimeToRestU = @obj.Dist_Exp;
                case "unif"
                    obj.uRestArr_Start(1) = par1;
                    obj.uRestArr_Start(2) = par2;
                    obj.TimeToRestU = @obj.Dist_Unif;
                case "norm"
                    obj.uRestArr_Start(1) = par1;
                    obj.uRestArr_Start(2) = par2;
                    obj.TimeToRestU = @obj.Dist_Norm;
                otherwise
                    disp('There was an error.');
            end
        end 
    end
end