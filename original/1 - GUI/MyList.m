classdef MyList < handle
    properties %(GetAccess='private', SetAccess='private')
        first;
        last;
        size;
    end
    
    
    methods
        %----------------------
        %Method 1: Constructor.
        %----------------------
        function obj=MyList()
            obj.first = NaN;
            obj.last = NaN;
            obj.size = 0;
        end
        
        %-------------------
        %Method 2: Get Head.
        %-------------------
        function obj=GetFirst(obj)
            obj = obj.first;
        end
        
        %-------------------
        %Method 3: Get Tail.
        %-------------------
        function obj=GetLast(obj)
            obj = obj.last;
        end
        
        %----------------------
        %Method 4: Set as Head.
        %----------------------
        function SetFirst(obj,node)
            obj.first = node;
        end
        
        %----------------------
        %Method 5: Set as Tail.
        %----------------------
        function SetLast(obj,node)
            obj.last = node;
        end
        
        %-------------------------
        %Method 6: Pull from Head.
        %-------------------------
        function dequed=Deque(obj)
            % Does NOT, I repeat, Does NOT delete "who".
            % Garbage collector will do that.
            dequed = obj.first;             % 		Return 1 after oldFirst!
            if (obj.size>1)
                obj.first = obj.first.GetNext();% 		get it's next, and set it as first.
                obj.first.SetPrev(NaN);        %		You have no prev now (because heavy is the head of he who wears the crown)
            else
                obj.first = NaN;
                obj.last = NaN;
            end
            obj.size = obj.size-1;
        end
        
        %-----------------------
        %Method 7: Push to Tail.
        %-----------------------
        function Enque(obj,entity)
            toBeInserted = MyNode(entity);
            if (obj.size>0)
                obj.last.SetNext(toBeInserted);
                toBeInserted.SetPrev(obj.last);
                obj.last = toBeInserted;
                toBeInserted.SetNext(NaN);                
            else
                obj.first = toBeInserted;
                obj.last = toBeInserted;
                obj.last.SetNext(NaN);
                obj.first.SetPrev(NaN);
            end
            obj.size = obj.size+1;
        end
        
        %------------------------------------------------------------------
        %------------------------------------------------------------------
        %-----------------------  Never Used %-----------------------------
        %-----------------------  Never Used %-----------------------------
        %-----------------------  Never Used %-----------------------------
        %-----------------------  Never Used %-----------------------------
        %-----------------------  Never Used %-----------------------------
        %------------------------------------------------------------------
        %------------------------------------------------------------------
        %{
        %-------------------
        %Method 3: Is Empty.
        %-------------------
        function ret=IsEmpty(obj)
            ret = isnan(obj.first);
        end
        
        %-----------------
        %Method 4: Insert.
        %-----------------
        function obj=Insert(obj,afterWho, data)
            toBeInserted = MyNode(data);          % Creating new node
            if (isnan(afterWho))                   % 1) Insert in the beginning.
                obj.first.SetPrev(toBeInserted);        % 1) Insert in the beginning.
                toBeInserted.SetNext(obj.first);	% 1) Insert in the beginning.
                obj.first = toBeInserted;			% 1) Insert in the beginning.
                toBeInserted.SetPrev(NaN);			% 1) Insert in the beginning.
                obj = toBeInserted;
            else
                afterAfterWho = afterWho.GetNext();     % 2) Insert after "afterWho".
                toBeInserted.SetNext(afterAfterWho);	% 2) Insert after "afterWho".
                afterWho.SetNext(toBeInserted);			% 2) Insert after "afterWho".
                toBeInserted.SetPrev(afterWho);			% 2) Insert after "afterWho".
                if (isnan(afterAfterWho)==0)				% 2) Insert after "afterWho".
                    afterAfterWho.SetPrev(toBeInserted);% 2) Insert after "afterWho".
                    obj = toBeInserted;
                end
            end
                obj.size = obj.size + 1;
        end
        
        %-----------------
        %Method 5: Delete.
        %-----------------
        function obj=Remove(obj,who)
            % Does NOT, I repeat, Does NOT delete "who".
            % Garbage collector will do that.
            if (obj.first == who)			% If it's the first node:
                obj.first = who.GetNext();  % 		get it's next, and set it as first.
                obj.first.SetPrev(NaN);     %		You have no prev now (because heavy is the head of he who wears the crown)
                obj = obj.first;            % 		Return 1 after oldFirst!
            else
                prev = who.getPrev();
                next = who.GetNext();
                prev.SetNext(next);
                if (isnan(next)==0)
                    next.SetPrev(prev);
                    obj = next;				% Return 1 after deleted.
                end
            end
            obj.size = obj.size - 1;
        end
        %}
        %--------------------
        %Method 6: To String.
        %--------------------
        function obj=ToString(obj)
            str = '[';
            iNod = obj.first;
            while(isnan(iNod)==0)
                str = strcat(str,num2str(iNod.GetEntity.eventTime));
                if(isnan(iNod.GetNext)==0)
                    str = strcat(str,',');
                end
                iNod = iNod.GetNext;
            end
            str = strcat(str,']');
            obj = str;
        end
    end
end