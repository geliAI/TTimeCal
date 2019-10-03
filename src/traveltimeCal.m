function [ takeoffAngle, travelTime,isRefract ,refractLayer] = traveltimeCal( velMod,depthMod,delta,depthEvent )
%Calculate seismic travel time in a 1D Model.
%Input: velMod: 1D velocity model
%       depthMod: depth to the top of each layer
%       delta: epicenter distance between event and station ,km
%       depthEvent: event depth
%Output:
%   takeoffAngle: the take-off angle of seismic ray path.
%   travelTime: calculated seismic travel time.
%   isRefract: % isRefract == 1, refracted wave at layer refractLayer;
%                isRefract == 0, returned travelTime is direct wave travel
%                itme.
%  refractLayer: -1, returned travelTime is direct wave travel time;
%                >0, the layer of refracted wave.
%Example1:
% velMod = [4.5 5.0 6.75];
% depthMod =[0.0 5.0 12.0];
% delta = 0; depthEvent = 4; 
% [ takeoffAngle, travelTime,isRefract ,refractLayer] = traveltimeCal( velMod,depthMod,delta,depthEvent )
% Example2:
% velMod = [4.5 5.0 6.75];
% depthMod =[0.0 5.0 12.0];
% delta = 50; depthEvent = 4; 
% [ takeoffAngle, travelTime,isRefract ,refractLayer] = traveltimeCal( velMod,depthMod,delta,depthEvent )

isRefract = 0;%refracted wave or not
[takeoffAngleRef, refractLayer,trefract] = refractwavetime(velMod,depthMod,...
    delta,depthEvent );

[ takeoffAngleDir,tdir] = directwavetime(velMod,depthMod,delta,depthEvent);

if tdir < trefract
    travelTime = tdir;
    takeoffAngle = takeoffAngleDir;
    refractLayer = -1;
else
    travelTime = trefract;
    takeoffAngle = takeoffAngleRef;

    isRefract = 1;
end

end

