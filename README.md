# Pedestrian Models


This is the code I use to model crowds of pedestrians. For the special case of single-file, i.e. $1$-D motion, or the analysis of Trajectory data please refer to the other repositories.

Even though this is an open repository, this is my personal scientific software for my PhD and as such a scientific endeavour is anything but a linear process, and this code is a constant part of it, there are many open ends and unfinished paths. To sum up, this was not developed to be used by others. Nontheless you should be able to run existing simulations for different scenarios. And with a little bit of work, to extend these. Apart from this you should be able to reproduce the modelling results of the manuscript 'Dimensionless Numbers Reveal Distinct Regimes in the Structure and Dynamics of Pedestrian Crowds'.

This readme is intended as a very small documentation. This documentation will not be sufficient to a full understanding, so if you have any questions do not hesitate to contact me.

This is to be used with Julia in Jupyter Notebooks. To use the code please download the repository and open the Jupyter Notebook associated with the scenario you want to study.

At first you need to specify the directory in which the Julia code is saved. Then specify the model you want to simulate. There are different models at different levels that can be combined. Loosely these Levels can be associated with Operational/Tactical/Strategic and then the update rule, where 'Parallel' should always be used by default. The 'Order' corresponds to a velocity or a acceleration based model, in the latter the actual velocity relaxates towards the result of the operational level on a time-scale $\tau _R$. Some of the models are based on the optimization of a cost-function, the optimization is solved by sampling the velocity space in a regular grid. The differential Equations are numerically integrated using a simple first-order Euler Maruyama scheme. Currently the boundaries are always periodic and specified by 'system_size'.

In the next cell of the Jupyter Notebook, the parameters of the Simulation are specified, in particular the crowd (german 'Menge'), the parameters of the single agents such as maximum velocity, the geometry and finally the parameters of the simulation like the numerical integration time-step.

The function 'Simulate!' now takes the fully defined scenario and returns the positions (as well as velocities and minimal TTC's) of the agents saved after the relaxation period at the specified saving time-step.

Finally the result is visualized using the GR Framework. The trajectories can be saved in the typical Format 'ID/FRAME/X/Y' for a further analysis.