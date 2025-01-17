# Chance-Constrained Stochatsic Optimal Control 

## Overview
In this repository, we solve a continuous-time chance-constrained stochstic optimal control problem using path integral controller for three systems:

(1) single integrator (2D state space)\
(2) unicycle (4D state space)\
(3) car model (5D state space)

For more details, checkout the [paper](https://ieeexplore.ieee.org/abstract/document/9993330).

## How to Use This Repository

1. **Navigate to the System Dynamics Subfolder**  
   Go to the subfolder corresponding to the system dynamics you wish to use.

2. **Configure the Desired Environment**  
   Set up the outer boundary and obstacles in the `parameters.m` file as needed.

3. **Find $\eta$ for Given $\Delta$ Values**  
   Run the `find_eta_star.m` script to solve the gradient ascent problem. This script generates three plots:  
   - (i) $P_{fail}$ vs $\Delta$  
   - (ii) $\eta$ vs $\Delta$  
   - (iii) $P_{fail}$ vs $\eta$

4. **Plot Stochastic Trajectories**  
   Use the `main.m` file to plot stochastic trajectories for a given value of $\Delta$ and $\eta$. The value of $\eta$ for the desired $\Delta$ is obtained from Step 3.

## Citation
If you found this work useful, please cite the below paper,
```@inproceedings{patil2022chance,
  title={Chance-constrained stochastic optimal control via path integral and finite difference methods},
  author={Patil, Apurva and Duarte, Alfredo and Smith, Aislinn and Bisetti, Fabrizio and Tanaka, Takashi},
  booktitle={2022 IEEE 61st Conference on Decision and Control (CDC)},
  pages={3598--3604},
  year={2022},
  organization={IEEE}
}
