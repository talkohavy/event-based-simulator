function obj = GetOneRepDataArr(fullDataArr,repNum)
    RepCol = size(fullDataArr,2);
    numOfRows = size(fullDataArr,1);
    numOfReps = fullDataArr(numOfRows,RepCol);
    if (repNum >= 1  &&  repNum <= numOfReps)
        %-----------------------------
        %STEP 1: Find row of beginning
        %-----------------------------
        for i = 1:1:numOfRows
            if (fullDataArr(i,RepCol) == repNum)
                st = i;
                break;
            end
        end
        %--------------------------
        %STEP 2: Find row of ending
        %--------------------------
        for i = size(fullDataArr,1):-1:1
            if (fullDataArr(i,RepCol) == repNum)
                ed = i;
                break;
            end
        end
        %---------------------------------------
        %STEP 3: Copy lines from begining to end
        %---------------------------------------
        obj = fullDataArr(st:ed,:);
    else
        disp("Out of bounds index.");
    end
end