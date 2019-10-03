# TTimeCal1D
 Earthquake travel time calculation based on a 1D layered velocity model.  
## Installation
Assume ```src``` folder is located in $PATH_TO_SRC:  
```addpath(genpath($PATH_TO_SRC))```.   
For example:  
```addpath(genpath('/Users/lige/Documents/GitHub/TTimeCal1D/src'))```.  

## File desciptions
### vel.mod
Input 1D velocity model file.  
Line 1: Number of velocity layers.  
Line 2: P wave velocity for each layer (km/s).  
Line 3: P and S wave velocity ratio.  
Line 4: Depth to the top of each layer (km).  
### evt_sta.dat
Input event and station pairs for which 1D seismic ray tracing will be performe.  
Each line contains the following information:  
Event Id, Event Latitude, Event Longitude, Event Depth in km, Station Name, Station Latitude, Station Longitude
### ttime.dat
Output seismic travel time table file.  
Each line contains the following information:  
Event Id,Station Name, Travel Time in second, Ray path take-off angle, Epicenter distance in km.  
