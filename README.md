# TTimeCal1D
 Earthquake travel time calculation based on a 1D layered velocity model.  
## Installation
Assume ```src``` folder is located in $PATH_TO_SRC:  
```addpath(genpath($PATH_TO_SRC))```.   
For example:  
```addpath(genpath('/Users/lige/Documents/GitHub/TTimeCal1D/src'))```.  

## Input files
### vel.mod
Input 1D velocity model file.  
Line 1: Number of velocity layers.  
Line 2: P wave velocity for each layer (km/s).  
Line 3: P and S wave velocity ratio.  
Line 4: Depth to the top of each layer (km).  
### evt_sta.dat

### ttime.dat
