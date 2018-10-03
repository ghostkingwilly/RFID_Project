# RFID Trajectary Simulation

---
## Main code 
* Traj_sim.m

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