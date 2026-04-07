classdef DataTable2 < handle
    properties %(GetAccess='private', SetAccess='private')
        first;
        last;
        rows;
        %----------------
        cols;
        curRow;
    end
    
    
    methods
        %----------------------
        %Method 1: Constructor.
        %----------------------
        function obj=DataTable2(cols)
            obj.first = NaN;
            obj.last = NaN;
            obj.rows = 0;
            obj.cols = cols;
        end
        
        %------------------------
        %Method 2: Get First Row.
        %------------------------
        function obj=GetFirstRow(obj)
            obj = obj.first;
        end
        
        %-----------------------
        %Method 3: Get Last Row.
        %-----------------------
        function obj=GetLastRow(obj)
            obj = obj.last;
        end
        
        %----------------------------
        %Method 4: Add new Empty row.
        %----------------------------
        function AddRow(obj)
            obj.curRow = Row2(obj.cols);
            if (obj.rows>0)
                obj.last.SetNext(obj.curRow);
                obj.curRow.SetPrev(obj.last);
                obj.last = obj.curRow;
                obj.curRow.SetNext(NaN);                
            else
                obj.first = obj.curRow;
                obj.last = obj.curRow;
                obj.last.SetNext(NaN);
                obj.first.SetPrev(NaN);
            end
            obj.rows = obj.rows+1;
        end
        
        %--------
        %Method 5: In new row, Set cell j's value.
        %--------
        function SetValueAt(obj,j,value)
            obj.curRow.SetValueAt(j,value);
        end
        
        %--------
        %Method 6: In new row, Get cell j's value.
        %--------
        function obj = GetValueAt(obj,j)
            obj = obj.curRow.GetValueAt(j);
        end
        
        %--------
        %Method 7: Transform DataTable to a matrix of rows X cols.
        %--------
        function matrx = TransformData(obj)
            matrx = zeros(obj.rows,obj.cols);
            row = obj.first;
            for i = 1:1:obj.rows
                for j = 1:1:obj.cols
                    matrx(i,j) = row.GetValueAt(j);
                end
                row = row.GetNext;
            end
        end
        
        %-----------------
        %Method 8: Append: Adding a table to current structure.
        %-----------------
        %Explain: When you have a table with many rows, and 
        %also a table which you want to attach to this one.
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
        
        %--------------------
        %Method 9: To String.
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