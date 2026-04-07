classdef Entity < handle
    properties %(GetAccess='private', SetAccess='private')
        %Main Fields:
        name                %Name / Type.
        eventCode           %What is happening.
        eventTime           %Time it has happened.
        %-----------------------------------------
        %Special Attributes:
        %doubleTime
    end
    
    
    methods
        %-----------
        %Constructor:
        %-----------
        function obj=Entity(name, eventCode, eventTime) %, doubleTime
            obj.name = name;
            obj.eventCode = eventCode;
            obj.eventTime = eventTime;
        end
    end
    methods (Static)
        %Static Method 1: Copy.
        function obj=Clone(toBeCloned)
            obj = Entity(-1,-1,-1);
            obj.name = toBeCloned.name;
            obj.eventCode = toBeCloned.eventCode;
            obj.eventTime = toBeCloned.eventTime;
        end
        %function obj=isnan(obj)
            
        %end
    end
end
    