classdef Row2 < handle
    properties
        array;
        prevNode;
        nextNode;
    end
    
    methods
        %-------------
        %Constructor 1:
        %-------------
        function obj=Row2(size)
            obj.array = zeros(1,size);
        end

        %--------
        %Method 1: Get Value at col j
        %--------
        function obj=GetValueAt(obj,j)
            obj = obj.array(j);
        end
        
        %--------
        %Method 2: Set Value at col j
        %--------
        function SetValueAt(obj,j,value)
            obj.array(j) = value;
        end
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %--------
        %Method 3: Get Prev
        %--------
        function obj=GetPrev(obj)
            obj = obj.prevNode;
        end
        
        %--------
        %Method 4: Set Prev
        %--------
        function obj=SetPrev(obj,prevNode)
            obj.prevNode = prevNode;
        end
        %--------
        %Method 5: Get Next
        %--------
        function obj=GetNext(obj)
            obj = obj.nextNode;
        end
        %--------
        %Method 6: Set Next
        %--------
        function SetNext(obj,nextNode)
            obj.nextNode = nextNode;
        end
    end
end