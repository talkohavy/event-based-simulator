classdef Simulation < handle
    properties %(GetAccess='private', SetAccess='private')
        %----------------------------------------------
        %Explanation: The table looks like this...
        %_t_|_U_|_P_|_F_|_Alfa_|_RealTime_|_RepNumber_|
        %----------------------------------------------
        
        %-------------------------------
        %Group 1: Event-Programming Core.
        %-------------------------------
        Now;    % List 1.
        CEL;    % List 2.
        DL1;    % List 3 - Sleeping Us.
        DL2;    % List 4 - Waiting partialUs.
        FEL;    
        Us;     % Changes 1.
        Ps;     % Changes 2.
        Fs;     % Changes 3.
        Tnow;   % Updates.
        alpha = 0;% Fixed or changes
        U_Start;% Init: User Defined 1
        P_Start;% Init: User Defined 2
        F_Start;% Init: User Defined 3
        Tmax;   %=2*60; %2=Hours. 60=Minutes.
        Umax;   %num of Us to double to.
        repNumber;
        FsCreated;
        timerVal;
        
        Explosion;
        graphMatrix;% Structure
        rpPoolArr;
        rpInAssemblyArr;
        rpNeededArr;
        unTrnsDataU;
        unTrnsDataRP;
        unTrnsDataInv;
        batchProd;
        which;
        serialNumber;
        
        %Distribution Variables:
        %         [expEx , normMu , normSd , unifMin , unifMax , detConst]
        foodArr =       [-999 -999];
        uArr    =       [-999 -999];
        pArr    =       [-999 -999];
        partialUArr =   [-999 -999];
        TimeToCreateF;
        TimeToCreateP;
        TimeToCreateRP;
        TimeToSelfAssemble;
        %---------------------------
        %Group 1: Graphs and Design.
        %---------------------------
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
        function obj = Simulation()
            obj.repNumber = 0;
            obj.gauge = uigauge(uifigure,'circular');
            obj.gauge.MajorTicks = [0 10 20 30 40 50 60 70 80 90 100];
            obj.gauge.MajorTickLabels = {'0', '10', '20', '30', '40', '50', '60', '70', '80', '90', '100'};
            obj.gauge.ScaleColors = [0.470588235294118 0.670588235294118 0.188235294117647;0 1 0;1 1 0;1 0 0];
            obj.gauge.ScaleColorLimits = [50 100;50.1 75;25.1 50;0 25];
            obj.gauge.FontSize = 18;
            obj.gauge.Position = [150 90 250 250];
        end
        
        %----------------------
        %Method 2: Reset stuff.
        %----------------------
        function Reset(obj)
            obj.serialNumber = 0;
            obj.Explosion = 0;
            obj.batchProd = 1;
            %Initialize 1: Reset all Variables.
            obj.Us = obj.U_Start;
            obj.Ps = obj.P_Start;
            obj.Fs = obj.F_Start;
            obj.unTrnsDataU = DataTable(7);
            obj.unTrnsDataRP = DataTable(6);
            obj.unTrnsDataInv = DataTable(12);
            obj.FsCreated = 0;
            obj.Tnow = 0;
            obj.Now = MyList();
            obj.CEL = MyList();
            obj.DL1 = MyList();
            obj.DL2 = MyList();
            obj.FEL = MyList();
            obj.rpNeededArr = zeros(1,obj.graphMatrix.vertexes);
            obj.rpPoolArr = MyList.empty(0);
            for i = obj.graphMatrix.vertexes:-1:1
                obj.rpPoolArr(i) = MyList();
            end
            obj.rpInAssemblyArr = zeros(1,obj.graphMatrix.vertexes);
            %Initialize 2: Create P's and give them jobs.
            arr = zeros(1,2);
            arr(1) = 1;     %1= eventCode , 1=Take Care of Food arrival.
            data = -1;      %data= eventTime
            for i = 1:1:obj.Ps
                curP = Entity(data,arr);
                obj.MakeFood(curP);
            end
            %Initialize 3: Create U's and give them jobs (or sleep).
            arr = zeros(1,2);
            data = -1;      %data= eventTime
            for i = 1:1:obj.Us
                curU = Entity(data,arr);
                %To which one? U or P?
                u = rand();
                if(u <= obj.alpha && obj.Fs >= 1/obj.graphMatrix.vertexes)
                    obj.CreateRP(curU,0);
                else
                    if(u > obj.alpha && obj.Fs >= 1)
                        if (obj.Explosion == 1)
                            obj.Fs = 10000;
                            obj.CreateP_Faster(curU);
                        else
                            if (obj.Fs > 666)
                                obj.Fs = 10000;
                                obj.Explosion = 1;
                                obj.CreateP_Faster(curU);
                            else
                                obj.CreateP(curU);
                            end
                        end
                    else
                        obj.DL1.Enque(curU);
                    end
                end
            end
            %obj.FEL.InsertionSort(); %No Need!! Because we are doing smart Enque!
        end
        
        %------------------
        %Method 3: Main Run
        %------------------
        function RunOnce(obj)
            disp('Still running...')
            obj.repNumber = obj.repNumber + 1;
            %Step 1: Reset Software
            obj.Reset;
            %Step 2: Run
            EndSim = false;
            dataArr = [obj.Tnow,obj.Us,obj.Ps,obj.Fs,0,0,obj.repNumber];
            obj.unTrnsDataU.AddRow(dataArr);
            dataArr = [obj.Tnow,obj.rpPoolArr(3).size,obj.rpPoolArr(4).size,obj.rpPoolArr(5).size,obj.rpPoolArr(6).size,obj.rpInAssemblyArr(3),obj.rpInAssemblyArr(4),obj.rpInAssemblyArr(5),obj.rpInAssemblyArr(6),obj.DL2.size,obj.Us,obj.repNumber];
            obj.unTrnsDataInv.AddRow(dataArr);
            obj.timerVal = tic;
            while(EndSim == false)
                %############
                %STAGE 1: EMP
                %############
                while(obj.Now.size > 0)
                    %**************************
                    %BigStep 1: Go to Now List.
                    %**************************
                    if (obj.Tnow > obj.Tmax || obj.Us >= obj.Umax)% || obj.Ps >= obj.Pmax
                        EndSim = true;
                        break;
                    else
                        switch obj.Now.GetFirst.GetEntity.arr(1) %1= eventCode
                            case 1 % Treat Food Arrival.
                                obj.TreatFoodArrival;
                            case 2 % Treat End of U Create's P
                                obj.TreatEndOfMakingP;
                            case 3 % Treat End of U Creates RP
                                obj.TreatEndOfMakingRP;
                            case 4 % Treat End of partialU SelfAssembly
                                obj.TreatEndOfSelfAssembly;
                            otherwise
                                disp('There was an error.');
                        end
                        %obj.FEL.InsertionSort(); %No Need!! Because we are doing smart Enque!
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
        %Method 4: Pull Future Events.
        %----------------------------
        function PullFutureEvents(obj)
            obj.Now.Enque(obj.FEL.Deque.GetEntity);
            obj.Tnow = obj.Now.GetFirst.GetEntity.data; %data= eventTime
            %^^^^^^^^^^^^^
            %Gaue Version: Time/Us/Ps Ratio
            %^^^^^^^^^^^^^
            arr = zeros(1,3);
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
            x = obj.TimeToCreateF(obj.pArr(1),obj.pArr(2));
            curP.data = obj.Tnow + x; %data= eventTime 
            %Step 2: Update Entity's eventCode.
            %entity.arr(1) = 1;  %1= Treat Food Arrival -> PreDefined
            %Step 3: Add Event to Diary.
            obj.FEL.SmartEnque(curP);
        end
        
        %-----------------------------------
        %Method 5: Create Event 2 - Create P
        %-----------------------------------
        function CreateP(obj,curU)
            %Step 1: Time to Create.
            x = obj.TimeToCreateP(obj.uArr(1),obj.uArr(2));
            curU.data = obj.Tnow + x; %data = eventTime 
            %Step 2: Update Entity's eventCode.
            curU.arr(1) = 2;  %2= Treat End of P Creation.
            %Step 3: Eat Food.
            obj.Fs = obj.Fs - 1;
            %Step 4: Add Event to Diary.
			obj.FEL.SmartEnque(curU);
        end
        
        function CreateP_Faster(obj,curU)
            %Step 1: Time to Create.
            addedTime = 0;
            while (1)
                %Step 1: Fictive Creation.
                addedTime = addedTime + obj.TimeToCreateP(obj.uArr(1),obj.uArr(2));
                %curU.data = obj.Tnow + x; %data = eventTime 
                %Step 2: Supposdly we would eat F right now Food.
                %obj.Fs = obj.Fs - 1;
                %Step 3: We Would also need to update Entity's eventCode.
                %curU.arr(1) = 2;  %2= Treat End of P Creation.
                %Step 4: I'm now fake adding the fake event to Diary.
                %obj.FEL.SmartEnque(curU);
                %Step 5: Can we make RP now?
                u = rand();
                if(u <= obj.alpha)
                    %Thank you!
                    break;
                end
            end
            %Step 6: Create RP.
            obj.CreateRP(curU,addedTime);
        end
        
        %-------------------------------------------------
        %Method 5: Create Event 3 - Create Ribosom Protein
        %-------------------------------------------------
        function CreateRP(obj,curU,addedTime)
            %Step 1: Time to Create.
            x = addedTime + obj.TimeToCreateRP(obj.uArr(1),obj.uArr(2));
            curU.data = obj.Tnow + x; %data = eventTime 
            %Step 2: Update Entity's eventCode.
            curU.arr(1) = 3;  %3= Treat End of Making RP
            %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
            %------------------------------------------
            %********* Changes with structure *********
            %------------------------------------------
            %Step 3: Decide which RP to create
            %Cur Structure is:
            % r1   r2   P1   P2   P3   P4
            %  1    2    3    4    5    6
            
            %---------
            %Policy 1: Random (Between [1,size])
            %---------
            minim = 3;
            obj.which = floor(minim + (obj.graphMatrix.vertexes-minim+1)*rand());
            
            %---------
            %Policy 2: Batch Production
            %---------
%             if (obj.batchProd == 1)
%                 u = rand();
%                 if (u < 0.5)
%                     obj.which = 3;
%                 else
%                     obj.which = 4;
%                 end
%                 obj.batchProd = obj.batchProd + 1;
%             else
%                 obj.batchProd = 1;
%                 obj.which = obj.which + 2;
%             end
            
            %---------
            %Policy 3: Max Needed First
            %---------
%             minim = 3;
%             obj.which = 6;
%             maxim = obj.rpNeededArr(6);
%             for i = 6:-1:3
%                 if(maxim < obj.rpNeededArr(i))
%                     obj.which = i;
%                     maxim = obj.rpNeededArr(i);
%                 end
%             end
%             if (maxim == 0)
%                 obj.which = 3;
%             end
            
            %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
            curU.arr(2) = obj.which;  %2= what RP is created
            %Step 4: Eat Partial Food.
            obj.Fs = obj.Fs - 1/6;%obj.graphMatrix.vertexes;
            %Step 5: Add Event to Diary.
			obj.FEL.SmartEnque(curU);
        end
        
        %----------------------------------------------
        %Method 5: Create Event 4 - Create SelfAssembly
        %----------------------------------------------
        function CreateSelfAssembly(obj,partialU,curRP)
            %Step 1: Time to Assemble RP.
            x = obj.TimeToSelfAssemble(obj.partialUArr(1),obj.partialUArr(2));
            %Step 2: Update RP self-Assembly eventCode.
            curRP.arr(1) = 4;  %4= Treat End of Assembly - PreDefined
            %Step 2: Update start+finish time of RP.
            curRP.timeArr(2) = obj.Tnow;
            curRP.timeArr(3) = obj.Tnow + x;
            curRP.data = obj.Tnow + x;
            %Step 3: Update RP Owner.
            curRP.owner = partialU;
            %Step 4: Remove RP from notForced list.
            partialU.notForced.RemoveUnknown(curRP.ID);
            obj.rpNeededArr(curRP.ID) = obj.rpNeededArr(curRP.ID) - 1;
            %Step 5: Insert RP to list of partialU's jobs.
            partialU.assemblingList.SmartEnque(curRP);
            %Step 6: Add Event to Diary.
			obj.FEL.SmartEnque(curRP);
        end
        
        %--------------------------------------
        %Method 6: Treat Event 1 - Food arrival
        %--------------------------------------
        function TreatFoodArrival(obj)
            %Step 1: P - The Food Creator.
            curP = obj.Now.Deque.GetEntity;
            %Step 2: New Food Arrived.
            obj.Fs = obj.Fs + 1;
            obj.FsCreated = obj.FsCreated + 1;
            %Step 3: A sleeping U eats new Food (if there is one).
            if (obj.DL1.size > 0)
                curU = obj.DL1.Deque.GetEntity;
                %But which one he makes? U or P?
                %There is Food 100%, so we don't need to check.
                %We just got the shipping of +1 F!
                u = rand();
                if(u <= obj.alpha)
                    obj.CreateRP(curU,0);
                else
                    if (obj.Explosion == 1)
                        obj.Fs = 10000;
                        obj.CreateP_Faster(curU);
                    else
                        if (obj.Fs > 666)
                            obj.Fs = 10000;
                            obj.Explosion = 1;
                            obj.CreateP_Faster(curU);
                        else
                            obj.CreateP(curU);
                        end 
                    end
                end
            end
            %Step 3: Old P starts creating Next Food.
            if (~obj.Explosion)
                obj.MakeFood(curP);
            end
            %Step 4: Log the change.
%             dataArr = [obj.Tnow,obj.Us,obj.Ps,obj.Fs,obj.alpha,toc(obj.timerVal),obj.repNumber];
%             obj.unTrnsDataU.AddRow(dataArr);
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
            %Step 4: Old U works if he can or goes to sleep.
            %But which one he makes? U or P?
            u = rand();
            if(u <= obj.alpha && obj.Fs >= 1/obj.graphMatrix.vertexes)
                obj.CreateRP(curU,0);
            else
                if(u > obj.alpha && obj.Fs >= 1)
                    if (obj.Explosion == 1)
                        obj.Fs = 10000;
                        obj.CreateP_Faster(curU);
                    else
                        if (obj.Fs > 666)
                            obj.Fs = 10000;
                            obj.Explosion = 1;
                            obj.CreateP_Faster(curU);
                        else
                            obj.CreateP(curU);
                        end
                    end
                else
                    obj.DL1.Enque(curU);
                end
            end
            %Step 4: Log the change.
%             dataArr = [obj.Tnow,obj.Us,obj.Ps,obj.Fs,obj.alpha,toc(obj.timerVal),obj.repNumber];
%             obj.unTrnsDataU.AddRow(dataArr);
        end
        
        %------------------------------------------
        %Method 7: Treat Event 3 - End of Making RP
        %------------------------------------------
        function TreatEndOfMakingRP(obj)
            %############################################################
            %Note 1: Once a RP has arrived, there might be some partialUs
            %that need it. Find one of them, and give RP to it.
            %############################################################
            %-------------------------------------
            %STEP 1: Get U - The Creator of the RP
            %-------------------------------------
            curU = obj.Now.Deque.GetEntity;
            
            %--------------------------
            %STEP 2: Add New RP to Pool
            %--------------------------
            curRP = EntityRP(obj.Tnow,-1);
            curRP.timeArr = [obj.Tnow -1 -1 -1];
            curRP.ID = curU.arr(2);  %2= what RP was created
%             curRP.owner = NaN; %Commented because already NaN.
            obj.rpPoolArr(curRP.ID).Enque(curRP);
            dataArr = [obj.Tnow,obj.rpPoolArr(3).size,obj.rpPoolArr(4).size,obj.rpPoolArr(5).size,obj.rpPoolArr(6).size,obj.rpInAssemblyArr(3),obj.rpInAssemblyArr(4),obj.rpInAssemblyArr(5),obj.rpInAssemblyArr(6),obj.DL2.size,obj.Us,obj.repNumber];
            
            %---------------------------------
            %STEP 3: Check if someone needs it
            %---------------------------------
            %Does anyone need curRP?
            if (obj.rpNeededArr(curRP.ID) > 0)
                %Yes! Find out who! Check partialUs Pool:
                %----------------
                %Policy 1: Random
                %----------------
                iNod = obj.DL2.GetFirst;
                optionsList = MyList();
                for i = 1:1:obj.DL2.size
                    %Check if curPartialU needs curRP:
                    if (iNod.GetEntity.notForced.Contains(curRP.ID))
                        %Yes! save as an option.
                        optionsList.Enque(Entity(i,NaN));
                    end
                    iNod = iNod.GetNext;
                end
                whichOne = floor(optionsList.size*rand());
                jNod = optionsList.GetFirst;
                for i = 1:1:whichOne
                    jNod = jNod.GetNext;
                end
                iNod = obj.DL2.GetFirst;
                for i=1:1:(jNod.GetEntity.data - 1)
                    iNod = iNod.GetNext;
                end
                %Now, assemble it.
                obj.rpPoolArr(curRP.ID).DequeLast;
                obj.rpInAssemblyArr(curRP.ID) = obj.rpInAssemblyArr(curRP.ID) + 1;
				dataArr = [obj.Tnow,obj.rpPoolArr(3).size,obj.rpPoolArr(4).size,obj.rpPoolArr(5).size,obj.rpPoolArr(6).size,obj.rpInAssemblyArr(3),obj.rpInAssemblyArr(4),obj.rpInAssemblyArr(5),obj.rpInAssemblyArr(6),obj.DL2.size,obj.Us,obj.repNumber];
                obj.CreateSelfAssembly(iNod.GetEntity,curRP);
                %--------------------------------------------------
                %---------------  Until Here  ---------------------
                %--------------------------------------------------
                
                %--------------
                %Policy 2: FIFO
                %--------------
%                 iNod = obj.DL2.GetFirst;
%                 for i = 1:1:obj.DL2.size
%                     %Check if curPartialU needs curRP:
%                     if (iNod.GetEntity.notForced.Contains(curRP.ID))
%                         %Yes! Assemble it.
%                         obj.rpPoolArr(othrRP).DequeLast;
%                         obj.rpInAssemblyArr(othrRP) = obj.rpInAssemblyArr(othrRP) + 1;
%                         obj.CreateSelfAssembly(iNod.GetEntity,curRP);
%                         break;
%                     end
%                     iNod = iNod.GetNext;
%                 end
                %--------------------------------------------------
                %---------------  Until Here  ---------------------
                %--------------------------------------------------
            else
                %------------------------------------------
                %********* Changes with structure *********
                %------------------------------------------
                if (curRP.ID == 3 || curRP.ID == 4) %P1 or P2
                    %Create New Initialized partialU:
                    data = -1;
                    arr = zeros(1,2);
                    arr(1) = 4; %1= EventCode. 4= Treat end of Assembly.
                    newPartialU = SpecialEntity(data,arr);
                    newPartialU.serialNumber = obj.serialNumber + 1;
                    obj.serialNumber = obj.serialNumber + 1;
                    newPartialU.doneList = MyList();
                    newPartialU.notForced = obj.graphMatrix.notForced.Clone;
                    newPartialU.stillForced = obj.graphMatrix.stillForced.Clone;
                    newPartialU.dynamicArray = obj.graphMatrix.forcedArray;
                    newPartialU.assemblingList = MyList();
                    iNod = newPartialU.notForced.GetFirst;
                    for i = 1:1:newPartialU.notForced.size
                        obj.rpNeededArr(iNod.GetEntity.data) = obj.rpNeededArr(iNod.GetEntity.data) + 1;
                        iNod = iNod.GetNext;
                    end
                    r1 = EntityRP(obj.Tnow,-1);
                    r1.timeArr = [obj.Tnow   obj.Tnow   obj.Tnow   -1];
                    r1.ID = 1;
                    r2 = EntityRP(obj.Tnow,-1);
                    r2.timeArr = [obj.Tnow   obj.Tnow   obj.Tnow   -1];
                    r2.ID = 2;
                    P1 = 3;
                    P2 = 4;
                    %Give him r1:
%                     obj.rpPoolArr(r1).Deque an r1 which was created by U1
%                     obj.rpInAssemblyArr(r1) = obj.rpInAssemblyArr(r1) + 1;
                    newPartialU.notForced.RemoveUnknown(r1.ID);
                    obj.rpNeededArr(r1.ID) = obj.rpNeededArr(r1.ID) - 1;
                    newPartialU.doneList.Enque(r1);
                    %Free r2 & P1: (Move r2&P1 from stillForced to notForced)
                    newPartialU.dynamicArray(r2.ID) = newPartialU.dynamicArray(r2.ID) - 1;
                    newPartialU.stillForced.RemoveUnknown(r2.ID);
                    newPartialU.notForced.Enque(Entity(r2.ID,NaN));
                    obj.rpNeededArr(r2.ID) = obj.rpNeededArr(r2.ID) + 1;
                    newPartialU.dynamicArray(P1) = newPartialU.dynamicArray(P1) - 1;
                    newPartialU.stillForced.RemoveUnknown(P1);
                    newPartialU.notForced.Enque(Entity(P1,NaN));
                    obj.rpNeededArr(P1) = obj.rpNeededArr(P1) + 1;
                    %Give him r2:
%                     obj.rpPoolArr(r2).Deque an r2 which was created by U1
                    newPartialU.notForced.RemoveUnknown(r2.ID);
                    obj.rpNeededArr(r2.ID) = obj.rpNeededArr(r2.ID) - 1;
                    newPartialU.doneList.Enque(r2);
                    %Free P2: (Move P2 from stillForced to notForced)
                    newPartialU.dynamicArray(P2) = newPartialU.dynamicArray(P2) - 1;
                    newPartialU.stillForced.RemoveUnknown(P2);
                    newPartialU.notForced.Enque(Entity(P2,NaN));
                    obj.rpNeededArr(P2) = obj.rpNeededArr(P2) + 1;
                    %Send curRP to be assembled:
                    obj.rpPoolArr(curRP.ID).DequeLast;
                    obj.rpInAssemblyArr(curRP.ID) = obj.rpInAssemblyArr(curRP.ID) + 1;
                    obj.CreateSelfAssembly(newPartialU,curRP);
                    obj.DL2.Enque(newPartialU);
                    dataArr = [obj.Tnow,obj.rpPoolArr(3).size,obj.rpPoolArr(4).size,obj.rpPoolArr(5).size,obj.rpPoolArr(6).size,obj.rpInAssemblyArr(3),obj.rpInAssemblyArr(4),obj.rpInAssemblyArr(5),obj.rpInAssemblyArr(6),obj.DL2.size,obj.Us,obj.repNumber];
                    newPartialU.nodeDL2 = obj.DL2.GetLast;
                end
            end
            obj.unTrnsDataInv.AddRow(dataArr);
            
            %---------------------------
            %STEP 4: U creates next RP/P
            %---------------------------
            %To which one? U or P?
            u = rand();
            if(u <= obj.alpha && obj.Fs >= 1/obj.graphMatrix.vertexes)
                obj.CreateRP(curU,0);
            else
                if(u > obj.alpha && obj.Fs >= 1)
                    if (obj.Explosion == 1)
                        obj.Fs = 10000;
                        obj.CreateP_Faster(curU);
                    else
                        if (obj.Fs > 666)
                            obj.Fs = 10000;
                            obj.Explosion = 1;
                            obj.CreateP_Faster(curU);
                        else
                            obj.CreateP(curU);
                        end
                    end
                else
                    obj.DL1.Enque(curU);
                end
            end
        end
        
        %-----------------------------------------
        %Method 7: Treat Event 4 - End of Assembly
        %-----------------------------------------
        function TreatEndOfSelfAssembly(obj)
            %------------------------------------------
            %STEP 1: Get partialU & the assembled curRP
            %------------------------------------------
            curRP = obj.Now.Deque.GetEntity;
            partialU = curRP.owner;
            partialU.assemblingList.Deque;
            
            %---------------------------------------------------------
            %STEP 2: Remove curRP from stillForced and Mark it as Done
            %---------------------------------------------------------
            %Explanation: Once a RP was assembled inside partialU, there 
            %might be some other parts inside partialU whom was forced by 
            %it, that can now be assembled. Find them, REMOVE them from 
            %stillForced and ADD them to notForced.
            partialU.doneList.Enque(curRP);
            
            %----------------------------
            %STEP 3: Check Chain Reaction (Releasing other RPs)
            %----------------------------
            %Meaning: Check if curRP unForces other RP spots in this partialU.
            iNod = partialU.stillForced.GetFirst;
            for i = 1:1:partialU.stillForced.size
                othrRP = iNod.GetEntity.data;
                %Did the released curRP forced curOthrRP?
                if (obj.graphMatrix.adjacentMat(curRP.ID, othrRP) == 1)
                    %Yes! Release it from THIS RP.
                    partialU.dynamicArray(othrRP) = partialU.dynamicArray(othrRP) - 1;
                    %But is it free though?
                    if (partialU.dynamicArray(othrRP) <= 0)%Actually is it ==, but this catches errors
                        %Yes! Move otherRP from stillForced to notForced:
                        partialU.stillForced.RemoveKnown(iNod);
                        partialU.notForced.Enque(iNod.GetEntity);
                        obj.rpNeededArr(othrRP) = obj.rpNeededArr(othrRP) + 1;%Alert Cell of partialU's need for otherRP.
                        %Self-Assemble if you can:
                        if (obj.rpPoolArr(othrRP).size > 0)
                            %Yes! We Can! and we don't need to check if 
                            %he's currently assembling it or not, cause
                            %we JUST freed him from stillForced!
                            %Attach 1 random RP from pool to partialU
                            %We need to select 1 from RP pool:
                            whichOne = floor(obj.rpPoolArr(othrRP).size*rand());
                            jNod = obj.rpPoolArr(othrRP).GetFirst;
                            for i = 1:1:whichOne
                                jNod = jNod.GetNext;
                            end
                            obj.rpPoolArr(othrRP).RemoveKnown(jNod);
                            obj.rpInAssemblyArr(othrRP) = obj.rpInAssemblyArr(othrRP) + 1;
                            %Selected! Now we can assemble it:
                            obj.CreateSelfAssembly(partialU,jNod.GetEntity);
                        end
                    end
                end
                iNod = iNod.GetNext;
            end
            
            %------------------------------
            %STEP 5: Check if new U is Done
            %------------------------------
            if (partialU.doneList.size < obj.graphMatrix.vertexes)
                %Log the change:
                %dataArr = [obj.Tnow,obj.Us,obj.Ps,obj.Fs,obj.alpha,toc(obj.timerVal),obj.repNumber];
                %obj.unTrnsDataU.AddRow(dataArr);
            else
                %U is Born!
                obj.DL2.RemoveKnown(partialU.nodeDL2);
                obj.Us = obj.Us + 1;
                obj.rpInAssemblyArr = obj.rpInAssemblyArr - 1;
                iNod = partialU.doneList.GetFirst;
                for i = 1:1:partialU.doneList.size
                    curRP = iNod.GetEntity;
                    curRP.timeArr(4) = obj.Tnow;
                    rpDataArr = [curRP.ID curRP.timeArr(1) curRP.timeArr(2)  curRP.timeArr(3)  curRP.timeArr(4)  obj.repNumber];
                    obj.unTrnsDataRP.AddRow(rpDataArr);
                    iNod = iNod.GetNext;
                end
                %Log the change.
                dataArr = [obj.Tnow,obj.Us,obj.Ps,obj.Fs,obj.alpha,toc(obj.timerVal),obj.repNumber];
                obj.unTrnsDataU.AddRow(dataArr);
                dataArr = [obj.Tnow,obj.rpPoolArr(3).size,obj.rpPoolArr(4).size,obj.rpPoolArr(5).size,obj.rpPoolArr(6).size,obj.rpInAssemblyArr(3),obj.rpInAssemblyArr(4),obj.rpInAssemblyArr(5),obj.rpInAssemblyArr(6),obj.DL2.size,obj.Us,obj.repNumber];
                obj.unTrnsDataInv.AddRow(dataArr);
                arr = zeros(1,2);
                data = -1;      %data= eventTime
                newU = Entity(data,arr);
                %Give him a job:
                %To which one? U or P?
                u = rand();
                if(u <= obj.alpha && obj.Fs >= 1/obj.graphMatrix.vertexes)
                    obj.CreateRP(newU,0);
                else
                    if(u > obj.alpha && obj.Fs >= 1)
                        if (obj.Explosion == 1)
                            obj.Fs = 10000;
                            obj.CreateP_Faster(newU);
                        else
                            if (obj.Fs > 666)
                                obj.Fs = 10000;
                                obj.Explosion = 1;
                                obj.CreateP_Faster(newU);
                            else
                                obj.CreateP(newU);
                            end
                        end
                    else
                        obj.DL1.Enque(newU);
                    end
                end
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
                    obj.foodArr(1) = par1;
                    obj.TimeToCreateF = @obj.Dist_Det;
                case "exp"
                    obj.foodArr(1) = par1;
                    obj.TimeToCreateF = @obj.Dist_Exp;
                case "unif"
                    obj.foodArr(1) = par1;
                    obj.foodArr(2) = par2;
                    obj.TimeToCreateF = @obj.Dist_Unif;
                case "norm"
                    obj.foodArr(1) = par1;
                    obj.foodArr(2) = par2;
                    obj.TimeToCreateF = @obj.Dist_Norm;
                otherwise
                    disp('There was an error.');
            end
        end
        
        function DistCreatingP(obj,distName,par1,par2)
            switch distName
                case "determinist"
                    obj.pArr(1) = par1;
                    obj.TimeToCreateP = @obj.Dist_Det;
                case "exp"
                    obj.pArr(1) = par1;
                    obj.TimeToCreateP = @obj.Dist_Exp;
                case "unif"
                    obj.pArr(1) = par1;
                    obj.pArr(2) = par2;
                    obj.TimeToCreateP = @obj.Dist_Unif;
                case "norm"
                    obj.pArr(1) = par1;
                    obj.pArr(2) = par2;
                    obj.TimeToCreateP = @obj.Dist_Norm;
                otherwise
                    disp('There was an error.');
            end
        end
            
        function DistCreatingRP(obj,distName,par1,par2)
            switch distName
                case "determinist"
                    obj.uArr(1) = par1;
                    obj.TimeToCreateRP = @obj.Dist_Det;
                case "exp"
                    obj.uArr(1) = par1;
                    obj.TimeToCreateRP = @obj.Dist_Exp;
                case "unif"
                    obj.uArr(1) = par1;
                    obj.uArr(2) = par2;
                    obj.TimeToCreateRP = @obj.Dist_Unif;
                case "norm"
                    obj.uArr(1) = par1;
                    obj.uArr(2) = par2;
                    obj.TimeToCreateRP = @obj.Dist_Norm;
                otherwise
                    disp('There was an error.');
            end
        end
        
        function DistSelfAssembly(obj,distName,par1,par2)
            switch distName
                case "determinist"
                    obj.partialUArr(1) = par1;
                    obj.TimeToSelfAssemble = @obj.Dist_Det;
                case "exp"
                    obj.partialUArr(1) = par1;
                    obj.TimeToSelfAssemble = @obj.Dist_Exp;
                case "unif"
                    obj.partialUArr(1) = par1;
                    obj.partialUArr(2) = par2;
                    obj.TimeToSelfAssemble = @obj.Dist_Unif;
                case "norm"
                    obj.partialUArr(1) = par1;
                    obj.partialUArr(2) = par2;
                    obj.TimeToSelfAssemble = @obj.Dist_Norm;
                otherwise
                    disp('There was an error.');
            end
        end
    end
end