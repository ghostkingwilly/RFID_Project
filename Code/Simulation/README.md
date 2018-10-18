# RFID Trajectary Simulation

---
## Main code 
* Traj_sim.m
* Flag : vertical
    * 0 : normal
    * 1 : vertical line
* mod 0 : Linear
    * The easy mode with ni noise
* mod 1 : Linear noise
    * Linear mode with noise
    * CFO and SFO simulation
        * CFO : y intercept 
        * SFO : slope change
* mod 2 : the obj. cannot move
* mod 3 : log 10 trojectory
    * with CFO, SFO
## Input function
* input_function.m
    * User need to input each coordinate formated by [x y]
    * User can set the default coordinate

## Calculation function
* phase_cal.m
    * Euclidean norm for the distance between reader and object
    * time = distance / light speed
    * get angle

## Plot function
* plot_traj.m
    * set xlim and ylim
    * plot the object moving and hand moving trajectory
