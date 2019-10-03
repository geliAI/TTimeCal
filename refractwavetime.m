function [ takeOffAngle,refractLayer,trefract] = refractwavetime( velMod,depthMod,delta,depthEvent )
% %Calculate refract wave travel time 
%input: 1D velocity model.
% the depth of event
% delta: epicetern distance between event and station ,km
%% Example:
% %this script is to find the direct wave 
% velMod = [4.5 5.5 6.75 6.75 6.75 6.9 7.75 8.0 8.175];
% depthMod = [0.0 4.0 10.0 20.0 30.0 35.0 40.0 150 165];
% delta = 59.4047623;
% depthEvent =3.41;
thickness = depthMod(2:end)-  depthMod(1:end-1);
nl = length(velMod);
if nl < 2
    takeOffAngle = -1;
    refractLayer=-1;
    trefract = 1000;
    return
end
evtL = max(find(depthMod<depthEvent));
deplayerTop = depthEvent - depthMod(evtL);
deplayerBot = depthMod(evtL+1)-depthEvent;
tRefract = zeros(nl,1)+10000;

for m = evtL+1:nl
    tid(m)=0;
    did(m)=0;
if velMod(m) > max(velMod(1:m-1))
    vRefract = velMod(m);
    SQT = sqrt(repmat(vRefract,1,nl).^2-velMod.^2);
    SQTVmVn = SQT/vRefract./velMod;
    VnSQT = velMod./SQT;
    
    tid(m) =   2*sum(thickness(evtL:m-1).*SQTVmVn(evtL:m-1))+...
        sum(thickness(evtL-1:-1:1).*SQTVmVn(evtL-1:-1:1));
    tinj(m) =  tid(m) - deplayerTop*SQTVmVn(evtL);
    did(m) = 2*sum(thickness(evtL:m-1).*VnSQT(evtL:m-1))+...
        sum(thickness(1:evtL-1).*VnSQT(1:evtL-1));
    didj(m) =  did(m) - deplayerTop*VnSQT(evtL);
    
    if didj(m) < delta
        tRefract(m) =  tinj(m)+ delta/vRefract;
    else
        tRefract(m)  = 10^4;
    end
    
else
    tid(m)=10000;
    did(m)=10000;
    tRefract(m) = 10000;
end
end

if min(tRefract)<10^4
    
   refractLayer = find(tRefract==min(tRefract));
   trefract = min(tRefract);
   sinTakeOff  = velMod(evtL)/velMod(refractLayer);
   takeOffAngle = (asin(sinTakeOff))*180/pi;
 
else % NO REFRACTED
    takeOffAngle =-1;
    refractLayer=-1;
    trefract=10^4;
end


end

