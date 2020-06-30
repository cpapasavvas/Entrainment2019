% load the connectivity settings used as an example in Figures 2-3
load('connSet.mat')

phase = 3;  % initial phase difference; use only [0 1 2 3]: to be multiplied by pi/2
AMP = 0.7;  % amplitude      
FREQ = 4;   % frequency
       
plotFlag = 1;   % enable plotting

q = 0;   % divisiveness parameter: ranges from 0 to 1
parameters = [optimSet q AMP FREQ phase]; 

[syn_index, tConv, absP, delayPh]=solveODEreduc(plotFlag, parameters);
