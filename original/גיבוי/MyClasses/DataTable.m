classdef DataTable < handle
    properties %(GetAccess='private', SetAccess='private')
        firstRow;
        lastRow;
        rows;
        cols;
    end
    %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    %-------------------  Explanation -------------------
    %-------------------  Explanation -------------------
    %1) First you create a table, like so: dt = DataTable(columnNumber)
    %2) Next, you probably have an array with data: dataArr.
    %3) So you create a new row from that array, like so: row = Row(arr)
    %4) The row has features: nextRow & prevRow which are null on creation.
    %5) To our dataTable we add rows 1 by one with: dt.AddRow(row)
    %6) When you add the new row to the dataTable, it automatically sets
    %   those features accordingly.
    %7) Note!!! THIS DataTable REPRESENTATION DOES NOT SUPPORT A COLUMNAR
    % SEARCH!!! THIS DataTable REPRESENTATION IS ALL STRING TYPE!!!
    
    methods
        %---------------------
        %Method 1: Constructor
        %---------------------
        function obj = DataTable(cols)
            obj.firstRow = NaN;
            obj.lastRow = NaN;
            obj.rows = 0;
            obj.cols = cols;
        end
        
        %---------------------------
        %Method 2: Get Get First Row
        %---------------------------
        function obj = GetFirstRow(obj)
            obj = obj.firstRow;
        end
        
        %----------------------
        %Method 3: Get Last Row
        %----------------------
        function obj = GetLastRow(obj)
            obj = obj.lastRow;
        end
        
        %----------------------
        %Method 4: Add Full Row
        %----------------------
        function AddRow(obj,arr)
            toBeInserted = Row(arr);
            if (obj.rows>0)
                obj.lastRow.SetNext(toBeInserted);
                toBeInserted.SetPrev(obj.lastRow);
                obj.lastRow = toBeInserted;
                toBeInserted.SetNext(NaN);                
            else
                obj.firstRow = toBeInserted;
                obj.lastRow = toBeInserted;
                obj.lastRow.SetNext(NaN);
                obj.firstRow.SetPrev(NaN);
            end
            obj.rows = obj.rows+1;
        end
        
        %---------------------------
        %Method 5: Add new Empty row
        %---------------------------
        function AddNewEmptyRow(obj)
            newRow = Row(zeros(1,obj.cols));
            if (obj.rows>0)
                obj.lastRow.SetNext(newRow);
                newRow.SetPrev(obj.lastRow);
                obj.lastRow = newRow;
                newRow.SetNext(NaN);                
            else
                obj.firstRow = newRow;
                obj.lastRow = newRow;
                obj.lastRow.SetNext(NaN);
                obj.firstRow.SetPrev(NaN);
            end
            obj.rows = obj.rows+1;
        end
        
        %---------------------------
        %Method 6: Add Multiple Rows
        %---------------------------
        function Append(obj,dataTable)
            if (obj.rows>0)
                obj.lastRow.SetNext(dataTable.GetFirstRow);
                dataTable.GetFirstRow.SetPrev(obj.lastRow);
                obj.lastRow = dataTable.GetLastRow;
            else
                obj.firstRow = dataTable.GetFirstRow;
                obj.lastRow = dataTable.GetLastRow;
                obj.cols = dataTable.cols;
            end
            obj.rows = obj.rows+dataTable.rows;
        end
        
        %--------
        %Method 7: Transform DataTable to a matrix of rows X cols.
        %--------
        function matrx = TransformData(obj)
            matrx = zeros(obj.rows,obj.cols);
            row = obj.firstRow;
            for i = 1:1:obj.rows
                for j = 1:1:obj.cols
                    matrx(i,j) = row.GetCol(j);
                end
                row = row.GetNext;
            end
        end
        
        %--------------------
        %Method 8: To String.
        %--------------------
        function obj = ToString(obj)
            str = '';
            row = obj.firstRow;
            for i=1:1:obj.rows
                for j=1:1:obj.cols
                    str = strcat(str,row.GetCol(j));
                end
                row = row.GetNext;
            end
            obj = str;
        end
    end
end