classdef Entity < handle
    properties %(GetAccess='private', SetAccess='private')
        name                %Name / Type.
        id                  %Serial Number.
        eventCode           %What is happening.
        eventTime           %Time it has happened.
    end
    
    
    methods
        %-----------
        %Constructor:
        %-----------
        function obj=Entity(name, id, eventCode, eventTime)
            obj.name = name;
            obj.id = id;
            obj.eventCode = eventCode;
            obj.eventTime = eventTime;
        end
    end
    methods (Static)
        %Static Method 1: Copy.
        function obj=Clone(toBeCloned)
            obj = Entity(-1,-1,-1);
            obj.name = toBeCloned.name;
            obj.id = toBeCloned.id;
            obj.eventCode = toBeCloned.eventCode;
            obj.eventTime = toBeCloned.eventTime;
        end
        %function obj=isnan(obj)
            
        %end
    end
end
    