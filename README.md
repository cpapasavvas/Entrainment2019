# Entrainment2019

Theoretical investigation of the effect of divisive inhibition on entrainment




Use the script entrainmentDemo to manipulate the parameters (initial phase diffr., amplitude, and frequency) and run the simulation.

A parameter set is loaded from optimSets.mat and the function transformSet is used to transform a 5-parameter set to an 8-parameter set by filling in the known connection weight ratios.

The script calls the function solverODEvarInput2 which collects all the parameters and runs the enrtainment scenario/simulation

The ODE solver calls the modelFunqNELvarInputPhase which describes the model

The freq_analysis2 functin is called to after the ODE solver to do spectral analysis on the generated signal
