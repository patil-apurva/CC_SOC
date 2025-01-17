# Chance-Constrained Stochatsic Optimal Control 

## Overview
In this repository, we solve a continuous-time chance-constrained stochstic optimal control problem using path integral controller for three systems:

(1) single integrator (2D state space)\
(2) unicycle (4D state space)\
(3) car model (5D state space)

For more details, checkout the [paper](https://ieeexplore.ieee.org/abstract/document/9993330).

## How to use this repository?
1. Navigate to the subfolder correspoding to the system dynamics that you want to use
2. To find the $\eta$ for the given values of $\Delta$ run 'find_eta_star.m'. It solves the gradient ascent problem and plots three figures: $P_{fail}$ vs $\Delta$, $\eta$
 vs $\Delta$ and $P_{fail}$ vs $\eta$.
3. To plot the stochastic trajectories for the given value of $\Delta$ and $\eta$ run the 'main.m' file. The value of $\eta$ corresponding to the desired $\Delta$ is obtained from step 2.

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
