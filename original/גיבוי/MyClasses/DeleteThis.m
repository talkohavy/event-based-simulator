clc;
clear;
%--------------------------------------------------------------------------

%Step 1: Random 100,000 times using uint8.
x = zeros(1,100000);
for i = 1:1:length(x)
    x(i) = floor(3 + 4*rand());
end

%Step 2: count number of 3's.
numOf3 = 0;
for i = 1:1:length(x)
    if (x(i) == 3)
        numOf3 = numOf3 + 1;
    end
end

%Step 3: count number of 4's.
numOf4 = 0;
for i = 1:1:length(x)
    if (x(i) == 4)
        numOf4 = numOf4 + 1;
    end
end

%Step 4: count number of 5's.
numOf5 = 0;
for i = 1:1:length(x)
    if (x(i) == 5)
        numOf5 = numOf5 + 1;
    end
end

%Step 5: count number of 6's.
numOf6 = 0;
for i = 1:1:length(x)
    if (x(i) == 6)
        numOf6 = numOf6 + 1;
    end
end

numOf3
numOf4
numOf5
numOf6