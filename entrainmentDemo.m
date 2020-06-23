load('optimSets.mat')
optimSet = transformSet(optimEndAlt);


phase = 0;  % initial phase difference; to be multiplied by pi/2
AMP = 0.4;  % amplitude      
FREQ = 1.7;   % frequency
                
plotFlag = 1;

q = 1;   % divisiveness parameter: ranges from 0 to 1
parameters = [optimSet q AMP FREQ]; 

[~,syn_index, tConv, absP, delayPh]=solverODEvarInput2(plotFlag, parameters, phase, 0);
