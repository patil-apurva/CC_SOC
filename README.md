# Chance-Constrained Stochatsic Optimal Control 

## Overview
In this repository, we solve a continuous-time chance-constrained stochstic optimal control problem using path integral controller for three systems:

(1) single integrator (2D state space)\
(2) unicycle (4D state space)\
(3) card model (5D state space)

For more details, checkout the [paper](https://ieeexplore.ieee.org/abstract/document/9993330).

## How to use this repository?
1. Navigate to the subfolder correspoding to the system dynamics that you want to use
2. To find the $\eta^*$ for the given values of $Delta$ run 'find_eta_star.m'. 



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
