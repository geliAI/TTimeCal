clc; clear all;
%rayVisualDriver
velMod = [4.5 5.0 6.75];
depthMod =[0.0 5.0 12.0];
delta = 50; depthEvent = 4; 

if ~isempty(find(depthMod == depthEvent))
    depthEvent = depthEvent+0.001;
end

thickness = depthMod(2:end)- depthMod(1:end-1);
nl = length(velMod);
evtL = max(find(depthMod<depthEvent));
deplayerTop = depthEvent - depthMod(evtL);
deplayerBot = depthMod(evtL+1)-depthEvent;
visualize = 1;

[ angle, travelTime,isRefract,refractLayer ] =...
     traveltimeCal( velMod,depthMod,delta,depthEvent);

 if visualize
      rayVisualFnc( velMod,depthMod,delta,depthEvent,...
               isRefract,refractLayer,angle)                                             
 end