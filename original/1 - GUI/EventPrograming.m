classdef EventPrograming < handle
    properties (GetAccess='private', SetAccess='private')
        %-------------------------------
        %Group 1: Event-Programming Core.
        %-------------------------------
        % MyList 1: Active State.
        Now;
        % MyList 2: Ready State.
        CEL;
        % MyList 3: Condition Wait.
        DL1;%Queue of Server 1.
        % MyList 4: Time Wait.
        FEL;
        
        %-------------------------
        %Group 2: Status Variables.
        %-------------------------
        Us;
        Ps;
        Fs;
        Tnow=0;
        
        %-----------------------------
        %Group 3: Fixed Alpha or Hill.
        %-----------------------------
        alphaType="Fixed"; %'Fixed' or 'Hill'
        alpha=1;
        SetAlpha;
        
        %-------------------------------
        %Group 4: User Defined Variables.
        %-------------------------------
        U;
        P;
        F;
        Tmax; %=2*60; %2=Hours. 60=Minutes.
        h=2;
        K=1;
        
        %-------------------------
        %Group 4: Output Variables.
        %-------------------------
        %1)t. 2)Us. 3)Ps. 4)Fs. 5)Code.
        data = zeros(2000,5);
        dataRow = 1;
        
        %-----------------------
        %Group 5: Other Variables.
        %-----------------------
        Gauge;
        FsCreated = 0;
        idUs=1;
        idPs=1;
        %Distribution Variables:
        normMuFood;
        normSdFood;
        unifMinFood;
        unifMaxFood;
        expMeanFood;
        detConstFood;
        normMuDup;
        normSdDup;
        unifMinDup;
        unifMaxDup;
        expMeanDup;
        detConstDup;
        TimeToDuplicate;%Chosen Duplication Distribution
        TimeToMakeFood; %Chosen FoodMaking Distribution.
    end
    methods
        %----------------------
        %Method 1: Constructor.
        %----------------------
        function obj = EventPrograming(Gauge)
           obj.Gauge = Gauge;
        end
        
        function Set(obj,U, P, F,Tmax,alphaType,alphaVal)
            obj.U = U;
            obj.P = P;
            obj.F = F;
            obj.Tmax = Tmax;
            obj.alphaType = alphaType;
            obj.alpha = alphaVal;
            %fprintf('U=%.0f P=%.0f F=%.0f Tmax=%.1f alphaType=%.0f\n',obj.U, obj.P,obj.F,obj.Tmax,obj.alphaType);
        end
        
        %-------------------
        %Method 2: Main Run
        %-------------------
        function Run(obj)
            disp('Still running...')
            %Step 1: Reset Software
            obj.Reset;
            %Step 2: Run
            EndSim = false;
            while(EndSim==false)
                %############
                %STAGE 1: EMP
                %############
                while(obj.Now.size>0)
                    %**************************
                    %BigStep 1: Go to Now List.
                    %**************************
                    if (obj.Tnow<obj.Tmax)
                        switch obj.Now.GetFirst.GetEntity.eventCode
                            case 1 % Code 1: Treat Food Arrival.
                                obj.TreatFoodArrival;
                            case 2 % Code 2: Treat End of Duplication
                                obj.TreatEndOfDuplication;
                            otherwise
                                disp('There was an error.');
                        end
                        obj.InsertionSort();
                    else
                        EndSim = true;
                        break;
                    end%//if: Time's Up.
                end%//while: EMP    
                %#############
                %STAGE 2: CUP| Going to FEL List.
                %#############
                if (obj.FEL.size>0)
                    obj.PullFutureEvents;
                else
                    EndSim = true;
                end
            end%//while: Software
            disp('Done!')
        end
        
        %----------------------
        %Method 3: Reset stuff.
        %----------------------
        function Reset(obj)
            %Initialize 1: Reset all Variables.
            obj.Us = obj.U;
            obj.Ps = obj.P;
            obj.Fs = obj.F;
            obj.FsCreated = 0;
            obj.Tnow=0;
            if (obj.alphaType == "Hill")
                obj.SetAlpha = @obj.AlphaHill;
            end
            if (obj.alphaType == "Fixed")
                obj.SetAlpha = obj.alpha;
            end
            obj.idUs=1;
            obj.idPs=1;
            obj.data = zeros(2000,5);
            obj.dataRow = 1;
            obj.Now=MyList();
            obj.CEL=MyList();
            obj.DL1=MyList();
            obj.FEL=MyList();
            %Initialize 2: Write Ps in Diary.
            while(obj.idPs<=obj.Ps)
                obj.MakeFood(Entity('P',obj.idPs,1,-1)); %1=Take Care of Food arrival.)
                obj.idPs=obj.idPs+1;
            end
            %Initialize 3: Put all Us Queue.
            while(obj.idUs<=obj.Us)
                obj.DL1.Enque(Entity('U',obj.idUs,-1,-1));
                obj.idUs = obj.idUs + 1;
            end
            %Initialize 4: Write Us in Diary.
            while(obj.Fs>0 && obj.DL1.size>0)
                obj.Duplicate(obj.DL1.Deque.GetEntity);
            end
            obj.InsertionSort();
        end
        
        %----------------------------------
        %Method 4: Create Event - Make Food.
        %----------------------------------
        function MakeFood(obj,entity)
            x = obj.TimeToMakeFood();
            %fprintf('X=%.3f\n',x);
            entity.eventTime = obj.Tnow+x;
            obj.FEL.Enque(entity);
        end
        
        %------------------------------------
        %Method 5: Create Event - Duplication.
        %------------------------------------
        function Duplicate(obj,entity)
            %Step 1: Time to Duplicate.
            x = obj.TimeToDuplicate();
            %fprintf('X=%.3f\n',x);
            %Step 2: To which one? U or P?
            u = rand();
            %fprintf('u=%.0f. alf=%.0f.\n',obj.alpha);
            obj.SetAlpha();
            if(u <= obj.alpha)
                entity.name = 'U';
            else
                entity.name = 'P';
            end
            %Step 3: Update Entity's stuff.
            entity.eventTime = obj.Tnow+x;
            entity.eventCode = 2;%2= Treat End of Duplication.
            obj.Fs = obj.Fs-1;
            %Step 4: Add Event 2 to Diary.
            obj.FEL.Enque(entity);
        end
        
        %----------------------------
        %Method 6: Treat Food arrival.
        %----------------------------
        function TreatFoodArrival(obj)
            obj.Fs=obj.Fs+1;
            obj.FsCreated = obj.FsCreated + 1;
            %Step 1: Create Next Food.
            obj.MakeFood(obj.Now.Deque.GetEntity);
            %Step 2: Create End of Duplicatiion.
            while(obj.Fs>0 && obj.DL1.size>0)
                obj.Duplicate(obj.DL1.Deque.GetEntity);
            end
            %Step 3: Log the change.
            obj.AddRow(1);
        end
        
        %----------------------------------
        %Method 7: Treat End of Duplication.
        %----------------------------------
        function TreatEndOfDuplication(obj)
            if (obj.Now.GetFirst.GetEntity.name == 'U')
                %Step 1: U is Born!
                obj.Us=obj.Us+1;
                obj.Now.Enque(Entity('U',obj.idUs,-1,-1));
                obj.idUs = obj.idUs+1;
                for i=1:2
                    if (obj.Fs>0)
                        obj.Duplicate(obj.Now.Deque.GetEntity);
                    else
                        obj.DL1.Enque(obj.Now.Deque.GetEntity);
                    end
                end
            elseif (obj.Now.GetFirst.GetEntity.name == 'P')
                %Step 1: P is Born!
                obj.Ps=obj.Ps+1;
                %Step 2: New P creates More Food.
                obj.MakeFood(Entity('P',obj.idPs,1,-1)); %1= Food Arrival Event.
                obj.idPs = obj.idPs+1;
                %Step 3: Old U duplicates if he can or goes to sleep.
                if(obj.Fs>0)
                    obj.Duplicate(obj.Now.Deque.GetEntity);
                else
                    obj.DL1.Enque(obj.Now.Deque.GetEntity);
                end
            end%/if: U created.
            %Last Step: Log the change.
            obj.AddRow(2);
        end
            
        %----------------------------
        %Method 8: Pull Future Events.
        %----------------------------
        function PullFutureEvents(obj)
            obj.Now.Enque(obj.FEL.Deque.GetEntity);
            obj.Tnow = obj.Now.GetFirst.GetEntity.eventTime;
            obj.Gauge.Value = obj.Tnow/obj.Tmax*100;
            pause (0.0001);
            while(obj.FEL.size>0 && obj.FEL.GetFirst.GetEntity.eventTime == obj.Tnow)
                obj.CEL.Enque(obj.FEL.Deque.GetEntity);
            end
            global a_Tnow b_Us c_Ps d_Fs e_FsCreated
            a_Tnow = obj.Tnow;
            b_Us = obj.Us;
            c_Ps = obj.Ps;
            d_Fs = obj.Fs;
            e_FsCreated = obj.FsCreated;
        end
        
        %-------------------------
        %Method 9: Add Row in Data.
        %-------------------------
        function obj=AddRow(obj,eventType)
        %1)t. 2)Us. 3)Ps. 4)Fs. 5)Code.
            obj.data(obj.dataRow,1) = obj.Tnow;
            obj.data(obj.dataRow,2) = obj.Us;
            obj.data(obj.dataRow,3) = obj.Ps;
            obj.data(obj.dataRow,4) = obj.Fs;
            if (obj.Fs==-1)
                aaa=1;
            end
            obj.data(obj.dataRow,5) = eventType;
            obj.dataRow = obj.dataRow + 1;
        end
        
        %-------------------------
        %Method 10: Insertion Sort.
        %-------------------------
        function InsertionSort(obj)
            jNod=obj.FEL.GetFirst;
            if (isnan(jNod)==0 && isnan(jNod.GetNext)==0)
                jNod = jNod.GetNext;
                %Step 1: Check n-1 elements.
                while (isnan(jNod.GetNext)==0)
                    broke = false; 
                    key = jNod.Clone();
                    iNod = jNod.GetPrev;
                    if (iNod.GetEntity.eventTime>key.GetEntity.eventTime)
                        %Step 2: Then jNod needs to change.
                        jNod.GetPrev.SetNext(jNod.GetNext);
                        jNod.GetNext.SetPrev(jNod.GetPrev);
                        %Step 3: Go Backwards.
                        iNod = iNod.GetPrev;
                        while(isnan(iNod)==0)
                            if (iNod.GetEntity.eventTime<key.GetEntity.eventTime)
                                broke = true;
                                break;
                            end
                            iNod = iNod.GetPrev;
                        end
                        if (broke == true)
                            iNod.GetNext.SetPrev(key);
                            key.SetNext(iNod.GetNext);
                            iNod.SetNext(key);
                            key.SetPrev(iNod);
                        else
                            key.SetNext(obj.FEL.GetFirst);
                            key.SetPrev(NaN);
                            obj.FEL.GetFirst.SetPrev(key);
                            obj.FEL.SetFirst(key);
                        end
                    end
                    jNod = jNod.GetNext;
                end
                %Step 4: Check the last one.
                broke = false; 
                iNod = jNod.GetPrev;
                if(jNod.GetEntity.eventTime<iNod.GetEntity.eventTime)
                    %Step 5: iNod is new Last.
                    obj.FEL.SetLast(jNod.GetPrev);
                    obj.FEL.GetLast.SetNext(NaN);
                    %Step 6: Go Backwards.
                    iNod = iNod.GetPrev;
                    while(isnan(iNod)==0)
                        if (iNod.GetEntity.eventTime<jNod.GetEntity.eventTime)
                            broke = true;
                            break;
                        end
                        iNod = iNod.GetPrev;
                    end
                    if (broke == true)
                        iNod.GetNext.SetPrev(jNod);
                        jNod.SetNext(iNod.GetNext);
                        iNod.SetNext(jNod);
                        jNod.SetPrev(iNod);
                    else
                        jNod.SetNext(obj.FEL.GetFirst);
                        jNod.SetPrev(NaN);
                        obj.FEL.GetFirst.SetPrev(jNod);
                        obj.FEL.SetFirst(jNod);
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
        %---------------------------- Getters -----------------------------
        %---------------------------- Getters -----------------------------
        %---------------------------- Getters -----------------------------
        %---------------------------- Getters -----------------------------
        %---------------------------- Getters -----------------------------
        
        %-------------------
        %Method 11: Get Data.
        %-------------------
        function data=GetData(obj)
            data = obj.data(1:(obj.dataRow-1),:);
        end
        
        %------------------
        %Method 12: Get Us.
        %------------------
        function data=GetUs(obj)
            data = obj.Us;
        end
        
        %------------------
        %Method 13: Get Ps.
        %------------------
        function data=GetPs(obj)
            data = obj.Ps;
        end
        
        %------------------
        %Method 14: Get Fs.
        %------------------
        function data=GetFs(obj)
            data = obj.Fs;
        end
        
        %--------------------------
        %Method 15: Get Fs Created.
        %--------------------------
        function data=GetFsCreated(obj)
            data = obj.FsCreated;
        end
        
        %-------------------------------------
        %Method 16: Set Hill's Alpha 
        %-------------------------------------
        function AlphaHill(obj)
            obj.alpha = (obj.K^obj.h)/(obj.K^obj.h + (obj.Us/obj.Fs)^obj.h);
        end
        
        %-------------------------------------
        %Method 18: All Distribution Functions.
        %-------------------------------------
        function x = FoodDeterminist(obj)
            %Option 1: Determinist
            x=obj.detConstFood;
        end
    
        function x = FoodUnif(obj)
            %Option 2: Uniform(a,b)
            u = rand();
            x=obj.unifMinFood+(obj.unifMaxFood-obj.unifMinFood)*u;
        end
    
        function x = FoodExp(obj)
            %Option 3: exp(Ex)
            u = rand();
            x = -(obj.expMeanFood)*log(1-u);
            %fprintf('X=%.3f\n',x);
        end
    
        function x = FoodNorm(obj)
            %Option 4: Norm(mu,sd^2)
            x = max(0,normrnd(obj.normMuFood,obj.normSdFood));
        end
    
        function x = DupDeterminist(obj)
            %Option 1: Determinist
            x=obj.detConstDup;
        end
    
        function x = DupUnif(obj)
            %Option 2: Uniform(a,b)
            u = rand();
            x=obj.unifMinDup+(obj.unifMaxDup-obj.unifMinDup)*u;
        end
    
        function x = DupExp(obj)
            %Option 3: exp(exp)
            u = rand();
            x = -obj.expMeanDup*log(1-u);
        end
        
        function x = DupNorm(obj)
            %Option 4: Norm(mu,sd^2)
            x = max(0,normrnd(obj.normMuDup,obj.normSdDup));
        end
        
        function DupDist(obj,distName,par1,par2)
            %fprintf('DistName= %s   par1=%.0f   par2=%.0f\n',distName,par1,par2)
            switch distName
                case "determinist"
                    obj.detConstDup = par1;
                    obj.TimeToDuplicate = @obj.DupDeterminist;
                case "exp"
                    obj.expMeanDup = par1;
                    obj.TimeToDuplicate = @obj.DupExp;
                case "unif"
                    obj.unifMinDup = par1;
                    obj.unifMaxDup = par2;
                    obj.TimeToDuplicate = @obj.DupUnif;
                case "norm"
                    obj.normMuDup = par1;
                    obj.normSdDup = par2;
                    obj.TimeToDuplicate = @obj.DupNorm;
                otherwise
                    disp('There was an error.');
            end
        end
        
        function FoodDist(obj,distName,par1,par2)
            %fprintf('DistName= %s   par1=%.0f   par2=%.0f\n',distName,par1,par2)
            switch distName
                case "determinist"
                    obj.detConstFood = par1;
                    obj.TimeToMakeFood = @obj.FoodDeterminist;
                case "exp"
                    obj.expMeanFood = par1;
                    obj.TimeToMakeFood = @obj.FoodExp;
                case "unif"
                    obj.unifMinFood = par1;
                    obj.unifMaxFood = par2;
                    obj.TimeToMakeFood = @obj.FoodUnif;
                case "norm"
                    obj.normMuFood = par1;
                    obj.normSdFood = par2;
                    obj.TimeToMakeFood = @obj.FoodNorm;
                otherwise
                    disp('There was an error.');
            end
        end
    end
end