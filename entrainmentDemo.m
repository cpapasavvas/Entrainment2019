load('optimSets.mat')
optimSet = transformSet(optimEndAlt);

phase = 0;  % initial phase difference; use only [0 1 2 3]: to be multiplied by pi/2
AMP = 0.7;  % amplitude      
FREQ = 4;   % frequency
       
plotFlag = 1;

q = 1;   % divisiveness parameter: ranges from 0 to 1
parameters = [optimSet q AMP FREQ]; 

[syn_index, tConv, absP, delayPh]=solveODEreduc(plotFlag, parameters, phase);
