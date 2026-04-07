classdef Row < handle
    properties
        t;
        U;
        P;
        F;
        alpha;
        realTime;
        replication;
        prevNode;
        nextNode;
    end
    
    
    methods
        %-------------
        %Constructor 1:
        %-------------
        function obj=Row(t,U,P,F,alpha,realTime,replication)
            obj.t = t;
            obj.U = U;
            obj.P = P;
            obj.F = F;
            obj.alpha = alpha;
            obj.realTime = realTime;
            obj.replication = replication;
        end

        %--------
        %Method 1: Get t
        %--------
        function obj=GetSimTime(obj)
            obj = obj.t;
        end
        
        %--------
        %Method 2: Get U
        %--------
        function obj=GetU(obj)
            obj = obj.U;
        end
        
        %--------
        %Method 3: Get P
        %--------
        function obj=GetP(obj)
            obj = obj.P;
        end
        
        %--------
        %Method 4: Get F
        %--------
        function obj=GetF(obj)
            obj = obj.F;
        end
        
        %--------
        %Method 5: Get Alpha
        %--------
        function obj=GetAlpha(obj)
            obj = obj.alpha;
        end
        
        %--------
        %Method 6: Get Real Time
        %--------
        function obj=GetRealTime(obj)
            obj = obj.realTime;
        end
        
        %--------
        %Method 7: Get Replication
        %--------
        function obj=GetReplication(obj)
            obj = obj.replication;
        end
        
        %--------
        %Method 8: Get Prev
        %--------
        function obj=GetPrev(obj)
            obj = obj.prevNode;
        end
        
        %--------
        %Method 9: Set Prev
        %--------
        function obj=SetPrev(obj,prevNode)
            obj.prevNode = prevNode;
        end
        %--------
        %Method 10: Get Next
        %--------
        function obj=GetNext(obj)
            obj = obj.nextNode;
        end
        %--------
        %Method 11: Set Next
        %--------
        function SetNext(obj,nextNode)
            obj.nextNode = nextNode;
        end
    end
end