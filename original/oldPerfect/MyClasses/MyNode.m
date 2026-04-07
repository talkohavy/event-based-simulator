classdef MyNode < handle
    properties %(GetAccess='private', SetAccess='private')
        entity;
    end
    
    properties % Access is public by default
        prevNode;
        nextNode;
    end
    
    methods
        %-------------
        %Constructor 1:
        %-------------
        function obj=MyNode(entity)
            obj.entity = entity;
        end
        %{
        %-------------
        %Constructor 2:
        %-------------
        function obj=Node(data,nextNode,prevNext)
            obj.data = data;
            obj.nextNode = nextNode;
            obj.prevNext = prevNext;
        end
        %}
        %--------
        %Method 1: Get Entity
        %--------
        function obj=GetEntity(obj)
            obj = obj.entity;
        end
        %--------
        %Method 2: Set Entity
        %--------
        function obj=SetEntity(obj,entity)
            %assert(entity.id>0);
            obj.entity = entity;
        end
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
        %--------
        %Method 7: Clone
        %--------
        function obj=ToString(obj)
            obj = '' & obj.entity;
        end
        %--------
        %Method 8: to String
        %--------
        function obj=Clone(obj)
            obj = MyNode(obj.entity);
            obj.nextNode = obj.nextNode;
            obj.prevNode = obj.prevNode;
        end
        %--------
        %Method 9: is null
        %--------
        function ret=isnan(obj)
            if (~isempty(obj.GetEntity.data))
                ret = 0;
            else
                ret = 1;
            end
        end
        
        %--------
        %Method 10: Self-Destruct
        %--------
        %{
        function Delete(obj)
            try
                fclose(obj.key);
            catch
                disp('File couldn''t be closed.')
            end
        end
        %}
    end
end