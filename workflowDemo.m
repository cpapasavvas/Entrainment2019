load('optimSets.mat')
optimSet = transformSet(optimEndAlt);


phase = 0;  % initial phase difference; to multiply pi/2
AMP = 0.7;  % amplitude      
FREQ = 4;   % frequency
elegance = 0;   %binary choice of IO function, non-elegant one
                % was used for the manuscript and the parameter sets were
                % generated based on elegance = 0
                
plotFlag = 1;

q = 0.25;
parameters = [optimSet q AMP FREQ]; 

[~,syn_index, tConv, absP, delayPh]=solverODEvarInput2(plotFlag, parameters, phase, elegance);
