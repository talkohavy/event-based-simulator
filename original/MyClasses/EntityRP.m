classdef EntityRP < handle
    properties %(GetAccess='private', SetAccess='private')
        %111111111111111111111111111
        %111111111111111111111111111
        %111111111111111111111111111
        %----- Class Variables -----
        data        %1) compare Value
        arr         %2) [eventCode]
        timeArr     %3) [enterPool, startOwnAssemble, endOwnAssemble, endPartialUassemble]
        ID          %4)      1              2                3              4
        
        
        %@@@@@@@@@@@@ Specific to this Simulation @@@@@@@@@@@@
        owner;
    end
    
    methods
        %-----------
        %Constructor:
        %-----------
        function obj = EntityRP(data,arr)
            obj.data = data;
            obj.arr = arr;
        end
        
        %------------------
        %Method 1: Get Data
        %------------------
        function obj = GetData(obj)
            obj = obj.data;
        end
        
        %-----------------
        %Method 2: Get Arr
        %-----------------
        function obj = GetArr(obj)
            obj = obj.arr;
        end
        
        %-----------------
        %Method 3: Get Arr Value j
        %-----------------
%         function obj = GetArrValue(obj,j)
%             obj = obj.arr(j);
%         end
        
        %------------------
        %Method 4: ToString
        %------------------
%         function obj = ToString(obj)
%             obj = "" + obj.data;
%         end
        
        %---------------
        %Method 5: Clone
        %---------------
%         function clonedEntity = Clone(obj)
%             clonedEntity = EntityRP(obj.data,obj.arr);
%         end
    end
end
    