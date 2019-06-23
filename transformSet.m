function parSet = transformSet(optimpar)
%TRANSFORMSET Summary of this function goes here
%   Detailed explanation goes here

parSet(1) = optimpar(1);
parSet(2) = optimpar(2);
parSet(3) = 0.54*optimpar(3);
parSet(4) = optimpar(3);
parSet(5) = optimpar(4);
parSet(6) = optimpar(5);
parSet(7) = 0.33*optimpar(3);
parSet(8) = optimpar(3);

end

