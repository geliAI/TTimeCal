function [ takeOffAngle,tdir] = directwavetime( velMod,depthMod,delta,depthEvent)
%Calculate direct wave travel time 
%input: 1D velocity model.
% the depth of event
% delta: epicetern distance between event and station ,km
%% Syntax:
% velMod = [4.5 5.5 6.75 6.75 6.75 6.9 7.75 8.0 8.175];
% depthMod = [0.0 4.0 10.0 20.0 30.0 35.0 40.0 150 165];
% delta = 50 ;
% depthEvent = 15;
% [ takeOffAngle,tdir] = directwavetime( velMod,depthMod,delta,depthEvent)

%% SRC:
tolerance = 10^-4;
thickness = depthMod(2:end)-  depthMod(1:end-1);
evtL = find(depthMod<depthEvent, 1, 'last' );
deplayerTop = depthEvent - depthMod(evtL);

if evtL == 1
    distHypo = sqrt(delta^2+depthEvent^2);
    tdir = distHypo/velMod(1);
    takeOffAngle = 180-asin(delta/distHypo)*180/pi;
    return
end
maxLayer = find(velMod(1:evtL)==(max(velMod(1:evtL))), 1, 'last' );
thickMaxLayer = depthMod(maxLayer+1)- depthMod(maxLayer);
if maxLayer == evtL
    thickMaxLayer = deplayerTop;
end

lSin = velMod(evtL)/max(velMod(1:evtL))*delta/sqrt(delta^2+depthEvent^2);
uSin = velMod(evtL)/max(velMod(1:evtL))*delta/sqrt(delta^2+thickMaxLayer^2);

uTan = uSin./sqrt(1-uSin^2);
aboveSinUpper = velMod(1:evtL-1)/velMod(evtL)*uSin;
aboveTanUpper = aboveSinUpper./sqrt(1-aboveSinUpper.^2);
deltaCalUpper =  deplayerTop*uTan + sum(thickness(1:evtL-1).*aboveTanUpper);
deltaDiffUpper = deltaCalUpper-delta;


lTan = lSin./sqrt(1-lSin^2);
aboveSinLower = velMod(1:evtL-1)/velMod(evtL)*lSin;
aboveTanLower = aboveSinLower./sqrt(1-aboveSinLower.^2);
deltaCalLower =  deplayerTop*lTan + sum(thickness(1:evtL-1).*aboveTanLower);
deltaDiffLower =  deltaCalLower-delta;


if abs(deltaCalUpper- deltaCalLower) > tolerance
    
sinTakeOff = (lSin*deltaDiffUpper-uSin*deltaDiffLower)/(deltaDiffUpper-deltaDiffLower);
tanTakeOff = sinTakeOff/sqrt(1-sinTakeOff^2);
aboveSin = velMod(1:evtL-1)/velMod(evtL)*sinTakeOff;
aboveTan = aboveSin./sqrt(1-aboveSin.^2);
deltaCal = deplayerTop*tanTakeOff + sum(thickness(1:evtL-1).*aboveTan);
deltaDiffCal = deltaCal-delta;
iteration=0;
while abs(deltaDiffCal) > tolerance
    iteration = iteration+1;
    lSin = sinTakeOff;
    lTan = lSin./sqrt(1-lSin^2);
    aboveSinLower = velMod(1:evtL-1)/velMod(evtL)*lSin;
    aboveTanLower = aboveSinLower./sqrt(1-aboveSinLower.^2);
    deltaCalLower =  deplayerTop*lTan + sum(thickness(1:evtL-1).*aboveTanLower);
    deltaDiffLower =  deltaCalLower-delta;

    sinTakeOff = (lSin*deltaDiffUpper-uSin*deltaDiffLower)/(deltaDiffUpper-deltaDiffLower);
    tanTakeOff = sinTakeOff/sqrt(1-sinTakeOff^2);
    aboveSin = velMod(1:evtL-1)/velMod(evtL)*sinTakeOff;
    aboveTan = aboveSin./sqrt(1-aboveSin.^2);
    deltaCal = deplayerTop*tanTakeOff + sum(thickness(1:evtL-1).*aboveTan);
    deltaDiffCal = deltaCal-delta;
end

else 
    sinTakeOff = lSin;
    aboveSin = aboveSinLower;
end

cosTakeOff = sqrt(1-sinTakeOff^2);
aboveCos = sqrt(1-aboveSin.^2);
tdir = deplayerTop/cosTakeOff/velMod(evtL)+sum(thickness(1:evtL-1)./aboveCos./velMod(1:evtL-1));
takeOffAngle = (pi-asin(sinTakeOff))*180/pi;

end

