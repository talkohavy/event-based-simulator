classdef GraphMatrix < handle
   
    %11111111111111111111111111111111111111111111111111111
    %11111111111111111111111111111111111111111111111111111
    %11111111111111111111111111111111111111111111111111111
    %---------------  FIELD VARIABLES  -------------------
    %---------------  FIELD VARIABLES  -------------------
    properties
        %--------------------
        %Group 1: Always Have
        %--------------------
        adjacentMat;
        notForced;
        stillForced;
        forcedArray;
        infoMap;
        paths;
        names;
        vertexes;
        nullVal;
        %--------------------
        %Group 2: BFS Related
        %--------------------
        BfsRan
        source
        BfsPath;
        %--------------------
        %Group 3: DFS Related
        %--------------------
        DfsRan
        numOfTrees
        time
        topologySorted
        isDag
        %---------------------
        %Group 4: Name Helpers
        %---------------------
        vertex
        color
        discovery
        finish
        Name
        number
    end
    
    methods
        %22222222222222222222222222222222222222222222222222222
        %22222222222222222222222222222222222222222222222222222
        %22222222222222222222222222222222222222222222222222222
        %-----------------  CONSTRUCTOR  ---------------------
        %-----------------  CONSTRUCTOR  ---------------------
        function obj = GraphMatrix(matrx,names)
            %STEP 1: Set Fixed Global Variables
            obj.vertex = 1;
            obj.color = 2;
            obj.discovery = 3;
            obj.finish = 4;
            obj.nullVal = 666;
            obj.Name = 1;
            obj.number = 2;
            %STEP 2: Number of Vertexes
            obj.vertexes = length(matrx);
            %STEP 3: Read Graph
            obj.adjacentMat = zeros(obj.vertexes - 1, obj.vertexes - 1);
            for i = 1:1:obj.vertexes
                for j = 1:1:obj.vertexes
                    obj.adjacentMat(i,j) = matrx(i,j);
                end
            end
            %STEP 4: Read Names
            obj.names = strings(1, obj.vertexes);
            for j = 1:1:obj.vertexes
                obj.names(j) = names(j);
            end
        end

        %44444444444444444444444444444444444444444444444444444
        %44444444444444444444444444444444444444444444444444444
        %44444444444444444444444444444444444444444444444444444
        %----------------  ---------------------
        %----------------  ---------------------
        function MakeForcedArray(obj)
            obj.forcedArray = zeros(1,obj.vertexes);
            for j= 1:1:obj.vertexes
                for i= 1:1:obj.vertexes
                    if(obj.adjacentMat(i,j) == 1)
                        obj.forcedArray(j) = obj.forcedArray(j) + 1;
                    end
                end
            end
        end
        
        %44444444444444444444444444444444444444444444444444444
        %44444444444444444444444444444444444444444444444444444
        %44444444444444444444444444444444444444444444444444444
        %----------------  ---------------------
        %----------------  ---------------------
        function MakeStillAndNotForced(obj)
            %Step 1: Create 2 empty lists.
            obj.notForced = MyList();
            obj.stillForced = MyList();
            %Step 2: Insert All into stillForced
            for i= 1:1:obj.vertexes
                entity = Entity(i,NaN);
                obj.stillForced.Enque(entity);
            end
            %Step 3: Remove from stillForced and insert to notForced.
            iNod = obj.stillForced.GetFirst;
            for k = 1:1:obj.stillForced.size
                forced = iNod.GetEntity.data;
                isFree = true;
                for i = 1:1:obj.vertexes
                    if (obj.adjacentMat(i, forced) == 1)
                        isFree = false;
                        break;
                    end
                end
                if (isFree)
                    obj.stillForced.RemoveKnown(iNod);
                    obj.notForced.Enque(iNod.GetEntity);
                    break;
                end
                iNod = iNod.GetNext(); 
            end
        end
            
        %44444444444444444444444444444444444444444444444444444
        %44444444444444444444444444444444444444444444444444444
        %----------------  Get Info Map  ---------------------
        %----------------  Get Info Map  ---------------------
        function obj = GetInfoMap(obj)
            obj = obj.infoMap;
        end

        %55555555555555555555555555555555555555555555555555555
        %55555555555555555555555555555555555555555555555555555
        %55555555555555555555555555555555555555555555555555555
        %-----------------  BFS Algorithm  -------------------
        %-----------------  BFS Algorithm  -------------------
        function BFS(obj,s)
            queue = MyList();
            obj.source = s;
            start = Entity(s,NaN);
            %-------------------------
            %STEP 1: Init color(White)
            %-------------------------
            obj.infoMap = zeros(4, obj.vertexes);
            for i = 1:1:obj.vertexes
                obj.infoMap(obj.color, i) = 0;
            end
            %-------------------------------
            %STEP 2: Init paths(null to all)
            %-------------------------------
            obj.paths = zeros(obj.vertexes);
            obj.paths(obj.source) = obj.nullVal;
            %-------------------------------------------
            %STEP 3: Insert s to queue. Mark as visited.
            %-------------------------------------------
            queue.Enque(start);
            obj.infoMap(obj.color, s) = 1;
            %-------------------
            %STEP 4: Start loop.
            %-------------------
            while (queue.size > 0)
                %-----------------------
                %STEP 7: Pop from queue.
                %-----------------------
                cur = queue.Deque().GetEntity().data;
                curVertex = Entity(cur,NaN);
                %--------------------------------
                %STEP 8: Get his close neighbors.
                %--------------------------------
                for j = 1:1:obj.vertexes
                    if (obj.adjacentMat(cur, j) == 1)
                        %---------------------------------------
                        %STEP 9: if it wasn%t visited, visit it.
                        %---------------------------------------
                        if (obj.infoMap(obj.color, j) == 0)
                            %----------------------------------------------------------------
                            %STEP 10: visit means put in queue, mark as gray, distnace is +1.
                            %----------------------------------------------------------------
                            adjEntity = Entity(j,NaN);
                            queue.Enque(adjEntity);
                            obj.infoMap(obj.color, j) = 1;
                            obj.paths(j) = curVertex.data;
                        end
                    end
                end
                obj.infoMap(obj.color, cur) = 2;
            end
            obj.BfsRan = true;
        end

        %66666666666666666666666666666666666666666666666666666
        %66666666666666666666666666666666666666666666666666666
        %66666666666666666666666666666666666666666666666666666
        %------------------  Get Path To  --------------------
        %------------------  Get Path To  --------------------
        function obj = GetPathTo(obj,target)
            if (obj.BfsRan == 1)
                path = MyList();
                cur = target;
                while (cur ~= obj.nullVal)
                    
                    %-----------------
                    %Option 1: Letters
                    %-----------------
                    intEntity = Entity(obj.GetName(uint8(cur)),NaN);
                    
                    %-----------------
                    %Option 2: Numbers
                    %-----------------
                    %intEntity = Entity(cur,NaN);
                    
                    path.Enque(intEntity);
                    cur = obj.paths(cur);
                end 
                path.ReverseMe();
                obj.BfsPath = path;
                obj = path;
            else
                print ("BFS hasnt run yet!")
                nullList = MyList();
                obj = nullList;
            end
        end
        
        %10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10
        %10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10
        %10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10
        %-----------------  Print BfsPath  -------------------
        %-----------------  Print BfsPath  -------------------
        function PrintBfsPath(obj)
            fprintf("BFS Path:\n");
            str = '[';
            iNod = obj.BfsPath.GetFirst();
            while(isnan(iNod)==0)
                str = strcat(str,num2str(obj.GetName(iNod.GetEntity().data)));
                if(isnan(iNod.GetNext())==0)
                    str = strcat(str,',');
                end
                iNod = iNod.GetNext;
            end
            str = strcat(str,']');
            fprintf(str + "\n");
        end

        %77777777777777777777777777777777777777777777777777777
        %77777777777777777777777777777777777777777777777777777
        %77777777777777777777777777777777777777777777777777777
        %-----------------  DFS Algorithm  -------------------
        %-----------------  DFS Algorithm  -------------------
        function DFS(obj)
            %----------------
            %STEP 1: Init all
            %----------------
            obj.isDag = true;
            obj.time = 0;
            obj.numOfTrees = 0;
            obj.infoMap = zeros(4, obj.vertexes);
            obj.paths = zeros(obj.vertexes);
            for i = 1:1:obj.vertexes
                %-------------------------
                %STEP 2: Init vertexes
                %-------------------------
                obj.infoMap(obj.vertex, i) = i;
                %-------------------------
                %STEP 3: Init color(White)
                %-------------------------
                obj.infoMap(obj.color, i) = 0;
                %-------------------------
                %STEP 4: Init paths(null to all)
                %-------------------------
                obj.paths(i) = obj.nullVal;
            end
            %-----------------
            %STEP 5: Do DFS...
            %-----------------
            for i = 1:1:obj.vertexes
                if (obj.infoMap(obj.color, i) == 0)
                    obj.numOfTrees = obj.numOfTrees + 1;
                    obj.DfsVisit (i);
                end
            end
            obj.DfsRan = true;
            if (obj.isDag)
                fprintf("Graph is DAG: Yes!")
            else
                fprintf("Graph is DAG: No...\n");
            end
            fprintf ("How many trees: " + obj.numOfTrees + "\n")
        end

        %88888888888888888888888888888888888888888888888888888
        %88888888888888888888888888888888888888888888888888888
        %88888888888888888888888888888888888888888888888888888
        %------------------  DFS Visit  ----------------------
        %------------------  DFS Visit  ----------------------
        function DfsVisit(obj,cur)
            obj.infoMap(obj.color, cur) = 1;%Gray
            obj.infoMap(obj.discovery, cur) = obj.time;
            obj.time = obj.time + 1;
            for i = 1:1:obj.vertexes
                if (obj.adjacentMat(cur, i) == 1)
                    if (obj.infoMap(obj.color, i) == 0)%White
                        obj.paths(i) = cur;
                        obj.DfsVisit(i);
                    else
                        if (obj.infoMap(obj.color, i) == 1)%Gray
                            obj.isDag = false;
                        end
                    end
                end
            end
            obj.infoMap(obj.color, cur) = 2; %Black
            obj.infoMap(obj.finish, cur) = obj.time;
            obj.time = obj.time + 1;
        end

        %99999999999999999999999999999999999999999999999999999
        %99999999999999999999999999999999999999999999999999999
        %99999999999999999999999999999999999999999999999999999
        %---------------  Topological Sort  ------------------
        %---------------  Topological Sort  ------------------
        function obj = TopologicalSort(obj)
            if (obj.DfsRan)
                obj.InsertionSortBy(obj.finish);
                obj.topologySorted = zeros(obj.vertexes);
                for i = 1:1:obj.vertexes
                    obj.topologySorted(i) = obj.infoMap(obj.vertex, obj.vertexes - i + 1);
                end
                obj = obj.topologySorted;
            else
                obj = obj.nullVal;
            end
        end

        %10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10
        %10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10
        %10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10
        %------------  Print Topological Sort  ---------------
        %------------  Print Topological Sort  ---------------
        function PrintTopological(obj)
            fprintf("Topological Sort:\n");
            str = "[";
            for i = 1:1:obj.vertexes-1
                str = str + obj.GetName(obj.topologySorted(i)) + ",";
            end
            str = str + obj.GetName(obj.topologySorted(obj.vertexes)) + "]";
            fprintf(str + "\n");
        end

        function obj = GetName(obj,number)
            obj = obj.names(obj.Name, number);
        end


        %--------------  My Insertion Sort  ------------------
        %--------------  My Insertion Sort  -----------------
        function InsertionSortBy(obj, byRow)
            if (size(obj.infoMap,2) > 1)
                keys = zeros(1,size(obj.infoMap, 1));
                for j = 2:1:size(obj.infoMap,2)
                    broke = false;
                    for k = 1:1:size(obj.infoMap,1)
                        keys(k) = obj.infoMap(k, j);
                    end
                    for i = (j-1):-1:1
                        if (keys(byRow) < obj.infoMap(byRow, i))
                            for k = 1:1:size(obj.infoMap, 1)
                                obj.infoMap(k,i+1) = obj.infoMap(k, i);
                            end
                        else
                            broke = true;
                            break;
                        end
                    end
                    if (broke)
                        i=i+1;
                    end
                    for k = 1:1:size(obj.infoMap, 1)
                        obj.infoMap(k,i) = keys(k);  % NOTE! i, and not i+1, because for loop doesn't do i=i-1 and make it to i=0, hence: broke boolean is needed. (in matlab's case i=0 is like i=-1)
                    end
                end
            end
        end
    end
end