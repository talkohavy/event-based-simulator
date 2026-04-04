clc;
clear;
%--------------------------------------------------------------------------

FEL = MyList();

e = SpecialEntity(1,[1,2,3]);
e.serialNumber = 33;
FEL.Enque(e)

e = EntityRP(1,[1,2,3]);
e.owner = 44;
FEL.Enque(e)


first = FEL.Deque.GetEntity;
fprintf("%.2f\n",first.serialNumber);

second = FEL.Deque.GetEntity;
fprintf("%.2f\n",second.owner);