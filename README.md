# TTimeCal
[![DOI](https://zenodo.org/badge/212610524.svg)](https://zenodo.org/badge/latestdoi/212610524)
 Earthquake travel time calculation based on a 1D layered velocity model.  
## Installation
Assume ```src``` folder is located in $PATH_TO_SRC:  
```addpath(genpath($PATH_TO_SRC))```.   
For example:  
```addpath(genpath('/Users/lige/Documents/GitHub/TTimeCal1D/src'))```.  

## File Preparations
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


## Usgae
```
clc; clear all;
%
f_velmod = 'vel.mod'; % Input 1D veolocity model file
f_evt_sta = 'evt_sta.dat';%  Input event and station pairs
f_out = 'ttime.dat'; % Outoput travel time table file
T=ttime1D_main(f_velmod,f_evt_sta,f_out);

```
## Ouptut 
This code will generate a  ```csv``` file containing a  seismic travel time table.  
Each line contains the following information:  
Event Id,Station Name, Travel Time in second, Ray path take-off angle, Epicenter distance in km.  
