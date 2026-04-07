classdef DataTable < handle
    properties %(GetAccess='private', SetAccess='private')
        first;
        last;
        rows;
    end
    
    
    methods
        %----------------------
        %Method 1: Constructor.
        %----------------------
        function obj=DataTable()
            obj.first = NaN;
            obj.last = NaN;
            obj.rows = 0;
        end
        
        %-------------------
        %Method 2: Get Head.
        %-------------------
        function obj=GetFirstRow(obj)
            obj = obj.first;
        end
        
        %-----------------------
        %Method 3: Get Last Row.
        %-----------------------
        function obj=GetLastRow(obj)
            obj = obj.last;
        end
        
        %------------------
        %Method 4: Add row.
        %------------------
        function AddRow(obj,t,U,P,F,alfa,realTime,replication)
            toBeInserted = Row(t,U,P,F,alfa,realTime,replication);
            if (obj.rows>0)
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
            obj.rows = obj.rows+1;
        end
        
        %------------------
        %Method 5: Add row.
        %------------------
        function Append(obj,dataTable)
            rowTBI = dataTable.GetFirstRow;
            if (obj.rows<=0)
                obj.first = rowTBI;
                obj.last = rowTBI;
                obj.first.SetPrev(NaN);
            else
                obj.last.SetNext(rowTBI);
                rowTBI.SetPrev(obj.last);
                obj.last = rowTBI;
            end
            rowTBI = rowTBI.GetNext;
            for i=1:1:dataTable.rows-1
                obj.last.SetNext(rowTBI);
                rowTBI.SetPrev(obj.last);
                obj.last = rowTBI;
                rowTBI = rowTBI.GetNext;
            end
            obj.rows = obj.rows+dataTable.rows;
        end
        
        %--------
        %Method 7: Transform DataTable to a matrix of rows X cols.
        %--------
        function matrx = TransformData(obj)
            matrx = zeros(obj.rows,7);
            row = obj.first;
            for i = 1:1:obj.rows
                matrx(i,1) = row.GetSimTime;
                matrx(i,2) = row.GetU;
                matrx(i,3) = row.GetP;
                matrx(i,4) = row.GetF;
                matrx(i,5) = row.GetAlpha;
                matrx(i,6) = row.GetRealTime;
                matrx(i,7) = row.GetReplication;
                row = row.GetNext;
            end
        end
        
        %--------------------
        %Method 5: To String.
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