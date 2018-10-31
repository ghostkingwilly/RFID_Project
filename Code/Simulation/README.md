# RFID Trajectary Simulation

---
## Main code 
### Two tags version(static)
#### Traj_sim.m
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

### Two tags version(static)
#### Object_Phase_Operator.m
* add the path of finctions
    * Mat_Funcs

## Mat_Funcs
* function folder

---
### Input function
* input_function.m

    |1|2|3|
    |---|---|---|
    |default initial reader x|default initial reader y|input message|

    * User need to input each coordinate formated by [x y]
    * User can set the default coordinate

### Calculation function
* phase_cal.m

    |1|2|3|
    |---|---|---|
    |moving vector|reader position|flag|
    |||for vertical line|

    * Euclidean norm for the distance between reader and object
    * time = distance / light speed
    * get angle

### Plot function
* plot_traj.m

    |1|2|3|4|5|6|7|
    |---|---|---|---|---|---|---|
    |initial vector x|initial vector y|object moving trajectory|user moving trajectory|trajectory size|mode|fast animate|

    * set xlim and ylim
    * plot the object moving and hand moving trajectory
* plot_phase
    * parameters

    |1|2|3|4|5|
    |---|---|---|---|---|
    |object position|user position|traj size|mode|fast animate|

    * check the border of the figure 
    * animate and plot