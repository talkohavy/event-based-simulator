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
        
		%33333333333333333333333333333333333333333
		%33333333333333333333333333333333333333333
		%33333333333333333333333333333333333333333
		%33333333333333333333333333333333333333333
		%--------------- Methods -----------------
		%--------------- Methods -----------------
		%--------------- Methods -----------------
        
        %------------------
        %Method 1: Get Head
        %------------------
        function obj = GetFirst(obj)
            obj = obj.first;
        end
        
        %------------------
        %Method 2: Get Tail
        %------------------
        function obj = GetLast(obj)
            obj = obj.last;
        end
        
        %---------------------
        %Method 3: Set as Head
        %---------------------
        function SetFirst(obj,node)
            obj.first = node;
        end
        
        %---------------------
        %Method 4: Set as Tail
        %---------------------
        function SetLast(obj,node)
            obj.last = node;
        end
        
        %------------------------
        %Method 5: Pull from Head
        %------------------------
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
        %  Method 7: Pull from Tail
        %----------------------------
        function dequed = DequeLast(obj)
            dequed = obj.last;
            obj.last = obj.last.GetPrev;
            if(isnan(obj.last))
                obj.first = NaN;
            else
                obj.last.SetNext(NaN);
            end
            obj.size = obj.size - 1;
        end
        
        %9999999999999999999999999999
        %9999999999999999999999999999
        %9999999999999999999999999999
        %----------------------------
        %   Method 8: Push to Tail
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
        
        %10 10 10 10 10 10 10 10 10 10
        %10 10 10 10 10 10 10 10 10 10
        %10 10 10 10 10 10 10 10 10 10
        %-----------------------------
        %    Method 9: Smart Enque
        %-----------------------------
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
                    toBeInserted.SetNext(iNod.GetNext);
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
                toBeInserted.SetNext(obj.first);
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
        
        %11 11 11 11 11 11 11 11 11 11 11
        %11 11 11 11 11 11 11 11 11 11 11
        %11 11 11 11 11 11 11 11 11 11 11
        %--------------------------------
        %     Method 10: InsertAfter
        %--------------------------------
        function ret = InsertAfter(obj,afterWho, data)
            %Return the iNod created with the entity+data inside it.
            toBeInserted = MyNode(data);
            if (isnan(afterWho))
                toBeInserted.SetPrev(NaN);
                toBeInserted.SetNext(obj.first);
                obj.first.SetPrev(toBeInserted);
                obj.first = toBeInserted;
                ret = toBeInserted;
            else
                toBeInserted.SetNext(afterWho.GetNext);
                toBeInserted.SetPrev(afterWho);
                afterWho.SetNext(toBeInserted);
                if (isnan(toBeInserted.GetNext))
                    obj.last = toBeInserted;
                else
                    toBeInserted.GetNext.SetPrev(toBeInserted);
                    ret = toBeInserted;
                end
            end
			obj.size = obj.size + 1;
        end
        
        %12 12 12 12 12 12 12 12 12 12 12
        %12 12 12 12 12 12 12 12 12 12 12
        %12 12 12 12 12 12 12 12 12 12 12
        %--------------------------------
        %     Method 11: Remove known
        %--------------------------------
        function RemoveKnown(obj,iNodRemoved)
            %Check if it's the first node:
            if (isnan(iNodRemoved.GetPrev))
                %Yes! obj.first is moved 1 up.
                obj.first = obj.first.GetNext;
                %Check if size>1:
                if (isnan(obj.first))
                    %No! size now equals to 1. Therefore...
                    obj.last = NaN;
                else
                    obj.first.SetPrev(NaN);
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
            
        %13 13 13 13 13 13 13 13 13 13 13
        %13 13 13 13 13 13 13 13 13 13 13
        %13 13 13 13 13 13 13 13 13 13 13
        %--------------------------------
        %    Method 12: Remove Unknown
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
                        ret = iNodRemoved;
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
        
        %14 14 14 14 14 14 14 14 14 14 14
        %14 14 14 14 14 14 14 14 14 14 14
        %14 14 14 14 14 14 14 14 14 14 14
        %--------------------------------
        % Method 13: Concatenate 2 Lists
        %--------------------------------
        function ConnectHead2Tail(obj,lst)
            obj.last.SetNext(lst.first);
            lst.first.SetPrev(obj.last);
            obj.SetLast(lst.last);
        end
        
        %15 15 15 15 15 15 15 15 15 15 15
        %15 15 15 15 15 15 15 15 15 15 15
        %15 15 15 15 15 15 15 15 15 15 15
        %--------------------------------
        %      Method 14: Contains
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
        
        %16 16 16 16 16 16 16 16 16 16 16
        %16 16 16 16 16 16 16 16 16 16 16
        %16 16 16 16 16 16 16 16 16 16 16
        %--------------------------------
        %      Method 15: Contains
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
        
        %17 17 17 17 17 17 17 17 17 17
        %17 17 17 17 17 17 17 17 17 17
        %17 17 17 17 17 17 17 17 17 17
        %-----------------------------
        %  Method 16: Insertion Sort
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
        
        %18 18 18 18 18 18 18 18 18 18
        %18 18 18 18 18 18 18 18 18 18
        %18 18 18 18 18 18 18 18 18 18
        %-----------------------------
        %    Method 17: Revert List
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
        
        %19 19 19 19 19 19 19 19 19 19
        %19 19 19 19 19 19 19 19 19 19
        %19 19 19 19 19 19 19 19 19 19
        %-----------------------------
        %     Method 18: To String
        %-----------------------------
        function obj = ToString(obj)
            str = '[';
            iNod = obj.first;
            while(~isnan(iNod))
                str = strcat(str,num2str(iNod.GetEntity.data));
                if(~isnan(iNod.GetNext))
                    str = strcat(str,',');
                end
                iNod = iNod.GetNext;
            end
            str = strcat(str,']');
            obj = str;
        end
        
        %20 20 20 20 20 20 20 20 20 20
        %20 20 20 20 20 20 20 20 20 20
        %20 20 20 20 20 20 20 20 20 20
        %-----------------------------
        %      Method 19: Clone
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