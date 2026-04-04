classdef MyList < handle
    %1111111111111111111111111
    %1111111111111111111111111
    %---- Class Variables ----
    properties %(GetAccess='private', SetAccess='private')
        first;
        last;
        size;
    end
    
    methods
        %222222222222222222222222222
        %222222222222222222222222222
        %222222222222222222222222222
        %---------------------------
        %   Method 1: Constructor
        %---------------------------
        function obj = MyList()
            obj.first = NaN;
            obj.last = NaN;
            obj.size = 0;
        end
        
        %333333333333333333333333333
        %333333333333333333333333333
        %333333333333333333333333333
        %---------------------------
        %     Method 2: Get Head
        %---------------------------
        function obj = GetFirst(obj)
            obj = obj.first;
        end
        
        %444444444444444444444444444
        %444444444444444444444444444
        %444444444444444444444444444
        %---------------------------
        %     Method 3: Get Tail
        %---------------------------
        function obj = GetLast(obj)
            obj = obj.last;
        end
        
        %555555555555555555555555555
        %555555555555555555555555555
        %555555555555555555555555555
        %---------------------------
        %   Method 4: Set as Head
        %---------------------------
        function SetFirst(obj,node)
            obj.first = node;
        end
        
        %666666666666666666666666666
        %666666666666666666666666666
        %666666666666666666666666666
        %---------------------------
        %   Method 5: Set as Tail
        %---------------------------
        function SetLast(obj,node)
            obj.last = node;
        end
        
        %7777777777777777777777777777
        %7777777777777777777777777777
        %7777777777777777777777777777
        %----------------------------
        %  Method 6: Pull from Head
        %----------------------------
        function dequed = Deque(obj)
            dequed = obj.first;
            if (obj.size > 1)
                obj.first = obj.first.GetNext;
                obj.first.SetPrev(NaN);
            else
                obj.first = NaN;
                obj.last = NaN;
            end
            obj.size = obj.size - 1;
        end
        
        %8888888888888888888888888888
        %8888888888888888888888888888
        %8888888888888888888888888888
        %----------------------------
        %   Method 7: Push to Tail
        %----------------------------
        function Enque(obj,entity)
            toBeInserted = MyNode(entity);
            if (obj.size > 0)
                toBeInserted.SetPrev(obj.last);
                toBeInserted.SetNext(NaN);
                obj.last.SetNext(toBeInserted);
                obj.last = toBeInserted;
            else
                obj.first = toBeInserted;
                obj.last = toBeInserted;
                obj.last.SetNext(NaN);
                obj.first.SetPrev(NaN);
            end
            obj.size = obj.size + 1;
        end
        
        %8888888888888888888888888888
        %8888888888888888888888888888
        %8888888888888888888888888888
        %----------------------------
        %   Method 7: Smart Enque
        %----------------------------
        function SmartEnque(obj,entity)
            %Note: This algorithm is starting from end to beginning.
            toBeInserted = MyNode(entity);
            iNod = obj.last;
            isInserted = false;
            %Step 1: Search insert position (n-1 places).
            for i = 1:1:obj.size
                %is this the one?
                if (entity.data >= iNod.GetEntity.data)
                    %Yes! Set 4 pointers.
                    toBeInserted.SetPrev(iNod);
                    toBeInserted.SetNext(iNod.GetNext)
                    iNod.SetNext(toBeInserted);
                    %is position last?
                    if (isnan(toBeInserted.GetNext))
                        %Yes! toBeInserted is now last.
                        obj.last = toBeInserted;
                    else
                        %No! can do SetNext to prev.
                        toBeInserted.GetNext.SetPrev(toBeInserted);
                    end
                    isInserted = true;
                    break;
                end
                iNod = iNod.GetPrev;
            end
            if (~isInserted)
                %Meaning: entity.data < obj.first.GetEntity.data
                toBeInserted.SetPrev(NaN);
                toBeInserted.SetNext(obj.first)
                %was list empty before insertion?
                if (isnan(obj.first))
                    %Yes! Update obj.last
                    obj.last = toBeInserted;
                else
                    %No! you can setPrev.
                    obj.first.SetPrev(toBeInserted);
                end
                obj.first = toBeInserted;
            end
            obj.size = obj.size + 1;
        end
        
        %9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 
        %9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 
        %9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 
        %-------------------------------
        %     Method 8: InsertAfter
        %-------------------------------
        function ret = InsertAfter(obj,afterWho, data)
            %Return the iNod created with the entity+data inside it.
            toBeInserted = MyNode(data);                % Creating new node
            if (isnan(afterWho))                        % 1) Insert in the beginning.
                toBeInserted.SetPrev(NaN);              % 1) Insert in the beginning.
                toBeInserted.SetNext(obj.first);        % 1) Insert in the beginning.
                obj.first.SetPrev(toBeInserted);        % 1) Insert in the beginning.
                obj.first = toBeInserted;               % 1) Insert in the beginning.
                ret = toBeInserted;
            else
                toBeInserted.SetNext(afterWho.GetNext);% 2) Insert after "afterWho".
                toBeInserted.SetPrev(afterWho);         % 2) Insert after "afterWho".
                afterWho.SetNext(toBeInserted);         % 2) Insert after "afterWho".
                if (isnan(toBeInserted.GetNext))        % 2) Insert after "afterWho".
                    obj.last = toBeInserted;
                else
                    toBeInserted.GetNext.SetPrev(toBeInserted);
                    ret = toBeInserted;
                end
            end
                obj.size = obj.size + 1;
        end
        
        %10 10 10 10 10 10 10 10 10 10 10
        %10 10 10 10 10 10 10 10 10 10 10
        %10 10 10 10 10 10 10 10 10 10 10
        %--------------------------------
        %     Method 9: Remove known
        %--------------------------------
        function RemoveKnown(obj,iNodRemoved)
            %Check if it's the first node:
            if (isnan(iNodRemoved.GetPrev))
                %Yes! obj.first is moved 1 up.
                obj.first = obj.first.GetNext;% 		get it's next, and set it as first.                
                %Check if size>1:
                if (isnan(obj.first))
                    %No! size now equals to 1. Therefore...
                    obj.last = NaN;
                else
                    obj.first.SetPrev(NaN);     %		You have no prev now (because heavy is the head of he who wears the crown)
                end
            else
                %No! it's not the first.
                prev = iNodRemoved.GetPrev;
                next = iNodRemoved.GetNext;
                prev.SetNext(next);
                %Check if it's the last:
                if (isnan(next))
                    %Yes! last need to move 1 before.
                    obj.last = prev;
                else
                    %No! we can set prev.
                    next.SetPrev(prev);
                end
            end
            obj.size = obj.size - 1;
        end
            
        %11 11 11 11 11 11 11 11 11 11 11
        %11 11 11 11 11 11 11 11 11 11 11
        %11 11 11 11 11 11 11 11 11 11 11
        %--------------------------------
        %    Method 10: Remove Unknown
        %--------------------------------
        function ret = RemoveUnknown(obj,data)
            %Note 1: Assumes an iNod with data exists. Therefore, a delete
            %action is guaranteed.
            %Check if it's the first node:
            removed = false;
            if (obj.first.GetEntity.data == data)
                removed = true;
                %Yes! Save the deleted iNod:
                ret = obj.first;
                %obj.first pointer is moved 1 up:
                obj.first = obj.first.GetNext;
                %Check if size>1:
                if (isnan(obj.first))
                    %No! size now equals to 1. Update obj.last:
                    obj.last = NaN;
                else
                    %Yes! can setPrev
                    obj.first.SetPrev(NaN);
                end
            else
                %No! it's not the first. We need to find it:
                iNodRemoved = obj.first.GetNext;
                for i = 2:1:obj.size
                    %Is this the one?
                    if (iNodRemoved.GetEntity.data == data)
                        %Yes!
                        prev = iNodRemoved.GetPrev;
                        next = iNodRemoved.GetNext;
                        prev.SetNext(next);
                        %Check if it's the last:
                        if (isnan(next))
                            %Yes! last need to move 1 before.
                            obj.last = prev;
                        else
                            %No! we can set prev.
                            next.SetPrev(prev);
                        end
                        removed = true;
                        ret = iNodRemoved;                         % 		Return the deleted
                        break;
                    end
                    iNodRemoved = iNodRemoved.GetNext;
                end
            end
%             if (~removed)
%                 a=6;
%             end
            obj.size = obj.size - 1;
        end
        
        %12 12 12 12 12 12 12 12 12 12 12
        %12 12 12 12 12 12 12 12 12 12 12
        %12 12 12 12 12 12 12 12 12 12 12
        %--------------------------------
        % Method 11: Concatenate 2 Lists
        %--------------------------------
        function ConnectHead2Tail(obj,lst)
            obj.last.SetNext(lst.first);
            lst.first.SetPrev(obj.last);
            obj.SetLast(lst.last);
        end
        
        %13 13 13 13 13 13 13 13 13 13 13
        %13 13 13 13 13 13 13 13 13 13 13
        %13 13 13 13 13 13 13 13 13 13 13
        %--------------------------------
        %      Method 12: Contains
        %--------------------------------
        function flag = Contains(obj,data)
            iNod = obj.first;
            flag = false;
            for i = 1:1:obj.size
                if (iNod.GetEntity.data == data)
                    flag = true;
                    break;
                end
                iNod = iNod.GetNext;
            end
        end
        
        %13 13 13 13 13 13 13 13 13 13 13
        %13 13 13 13 13 13 13 13 13 13 13
        %13 13 13 13 13 13 13 13 13 13 13
        %--------------------------------
        %      Method 12: Contains
        %--------------------------------
        function flag = ContainsAt(obj,value,j)
            iNod = obj.first;
            flag = false;
            for i = 1:1:obj.size
                if (iNod.GetEntity.GetArrValue(j) == value)
                    flag = true;
                    break;
                end
                iNod = iNod.GetNext;
            end
        end
        
        %14 14 14 14 14 14 14 14 14 14
        %14 14 14 14 14 14 14 14 14 14
        %14 14 14 14 14 14 14 14 14 14
        %-----------------------------
        %  Method 13: Insertion Sort
        %-----------------------------
        function InsertionSort(obj)
            iNod = obj.first;
            if (~isnan(iNod) && ~isnan(iNod.GetNext))
                iNod = iNod.GetNext;
                %Step 1: Sort n-1 elements.
                while (~isnan(iNod.GetNext))
                    %A. Remember your place:
                    continueFrom = iNod.GetNext;
                    %B. Disconnect iNod:
                    iNod.GetPrev.SetNext(iNod.GetNext);
                    iNod.GetNext.SetPrev(iNod.GetPrev);
                    %C. Check backwards
                    jNod = iNod.GetPrev;
                    while(~isnan(jNod) && iNod.GetEntity.data < jNod.GetEntity.data)
                        jNod = jNod.GetPrev;
                    end
                    %D. if reached 0...
                    if(isnan(jNod))
                        %Connect iNod to beginning
                        iNod.SetNext(obj.first);
                        iNod.SetPrev(NaN);
                        obj.first.SetPrev(iNod);
                        obj.first = iNod;
                    else
                        %Connect iNod after jNod
                        iNod.SetNext(jNod.GetNext);
                        iNod.SetPrev(jNod);
                        jNod.GetNext.SetPrev(iNod);
                        jNod.SetNext(iNod);
                    end
                    iNod = continueFrom;
                end
                %Step 4: Check the last one.
                iNod = obj.last;
                jNod = iNod.GetPrev;
                if(iNod.GetEntity.data < jNod.GetEntity.data)
                    %Step 5: jNod is now new Last.
                    obj.last = jNod;
                    obj.last.SetNext(NaN);
                    %C. Check backwards
                    jNod = jNod.GetPrev;
                    while(~isnan(jNod) && iNod.GetEntity.data < jNod.GetEntity.data)
                        jNod = jNod.GetPrev;
                    end
                    %D. if reached 0...
                    if(isnan(jNod))
                        %Connect iNod to beginning
                        iNod.SetNext(obj.first);
                        iNod.SetPrev(NaN);
                        obj.first.SetPrev(iNod);
                        obj.first = iNod;
                    else
                        %Connect iNod after jNod
                        iNod.SetNext(jNod.GetNext);
                        iNod.SetPrev(jNod);
                        jNod.GetNext.SetPrev(iNod);
                        jNod.SetNext(iNod);
                    end
                end
            end
        end
        
        %15 15 15 15 15 15 15 15 15 15
        %15 15 15 15 15 15 15 15 15 15
        %15 15 15 15 15 15 15 15 15 15
        %-----------------------------
        %    Method 14: Revert List
        %-----------------------------
        function ReverseMe(obj)
            %Note: Nodes remain in their places! nextNode and prevNode 
            %pointers remain untouched! Only thing done here is the 
            %replacing of pointers on entities.
            howManySwitches = obj.size / 2; %it does flooring anyway because int.
            st = obj.first;
            ed = obj.last;
            for i = 1:1:howManySwitches
                saver = st.GetEntity;
                st.SetEntity(ed.GetEntity);
                ed.SetEntity(saver);
                st = st.nextNode;
                ed = ed.prevNode;
            end
        end
        
        %16 16 16 16 16 16 16 16 16 16
        %16 16 16 16 16 16 16 16 16 16
        %16 16 16 16 16 16 16 16 16 16
        %-----------------------------
        %     Method 15: To String
        %-----------------------------
        function obj = ToString(obj)
            str = '[';
            iNod = obj.first;
            while(isnan(iNod) == 0)
                str = strcat(str,num2str(iNod.GetEntity.data));
                if(isnan(iNod.GetNext) == 0)
                    str = strcat(str,',');
                end
                iNod = iNod.GetNext;
            end
            str = strcat(str,']');
            obj = str;
        end
        
        %17 17 17 17 17 17 17 17 17 17
        %17 17 17 17 17 17 17 17 17 17
        %17 17 17 17 17 17 17 17 17 17
        %-----------------------------
        %     Method 16: To String
        %-----------------------------
        function clonedList = Clone(obj)
            clonedList = MyList();
            iNod = obj.first;
            for i= 1:1:obj.size
                clonedList.Enque(iNod.GetEntity.Clone);
                iNod = iNod.GetNext;
            end
        end
    end
end