# AnnealingSimulation
Cedar files and experiment results

There are 5 folders in total. Each corresponds to one part of simulation.

1. MCMCSMC: This is the simulation comparing the tree metrics using SMC and MCMC. The part of using 100 particles (folder: MCMC50_100) is done. The experiment using 500 particles (MCMC50_500) in still waiting on Cedar. R file 'summary' is used to creat figures.

2. Zestimate: This is the simulation study for comparing normalizing constant. The R file 'summary' is used to creat figures, the R file 'CV' is used to creat tables for CV. I am trying to run many cases, but Cedar just let me wait. For the cases that are complete, just refers to our manuscripts. 

3. SMC_Threads: comparing computational cost using multiple threads, done!

4. SMC_alpha: comparing SMC with different alpha value, done!

5. SMC_N: comparing SMC with different N value, almost done, just 8 replicates for N = 3000 left. But it shouldn't impact the results.


