function obj = SetRep(fullDataArr,userRep)
    Rep = size(fullDataArr,2);
    numOfReps = fullDataArr(end,Rep);
    if (userRep > 0  &&  userRep <= numOfReps)
        %-----------------------------
        %STEP 1: Find row of beginning
        %-----------------------------
        for i=1:1:size(fullDataArr,1)
            if (fullDataArr(i,Rep) == userRep)
                st = i;
                break;
            end
        end
        %--------------------------
        %STEP 2: Find row of ending
        %--------------------------
        for i=size(fullDataArr,1):-1:1
            if (fullDataArr(i,Rep) == userRep)
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