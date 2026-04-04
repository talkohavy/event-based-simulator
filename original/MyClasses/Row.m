classdef Row < handle
    properties
        array;
        prevNode;
        nextNode;
    end
    
    %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    %-------------------  Explanation -------------------
    %-------------------  Explanation -------------------
    %1) Read Explanation of DataTable...
    
    methods
        %------------
        %Constructor:
        %------------
        function obj = Row(dataArr)
            obj.array = dataArr;
        end
        
        %--------
        %Method 1: Get Element i
        %--------
        function obj = GetCol(obj,i)
            obj = obj.array(i);
        end
        
        %--------
        %Method 2: Get Prev
        %--------
        function obj = GetPrev(obj)
            obj = obj.prevNode;
        end
        
        %--------
        %Method 3: Set Prev
        %--------
        function obj = SetPrev(obj,prevNode)
            obj.prevNode = prevNode;
        end
        %--------
        %Method 4: Get Next
        %--------
        function obj = GetNext(obj)
            obj = obj.nextNode;
        end
        %--------
        %Method 5: Set Next
        %--------
        function SetNext(obj,nextNode)
            obj.nextNode = nextNode;
        end
        
        %--------
        %Method 6: Set cell j's value.
        %--------
        function SetValueAtTo(obj,j,value)
            %if (j>0 && j<obj.cols)
                obj.array(j) = value;
            %end
        end
    end
end