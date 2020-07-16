# Entrainment2019

Theoretical investigation of the effect of divisive inhibition on entrainment




Use the script entrainmentDemo to manipulate the parameters (initial phase diff., amplitude, frequency, and divisiveness parameter) and run the simulation.

The script calls the function solverODEreduc which collects all the parameters and runs the enrtainment scenario/simulation.

The solverODEreduc function calls the modelFunqVarInput which describes the model.

The freq_analys function is called after the simulation for the spectral analysis of the generated signal.
