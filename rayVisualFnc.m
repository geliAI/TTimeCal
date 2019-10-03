function [ segPoint ] = rayVisualFnc( velMod,depthMod,delta,depthEvent,...
                           isRefract,refractLayer,angle)
if ~isempty(find(depthMod == depthEvent))
    depthEvent = depthEvent+0.001;
end

thickness = depthMod(2:end)- depthMod(1:end-1);
nl = length(velMod);
evtL = max(find(depthMod<depthEvent));
deplayerTop = depthEvent - depthMod(evtL);
deplayerBot = depthMod(evtL+1)-depthEvent;

evt_loc = [-delta,-depthEvent];
sta_loc = [0,0];
scatter(evt_loc(1),evt_loc(2),50,'filled');hold on
scatter(sta_loc(1),sta_loc(2),50,'filled','d');

if isRefract == 0  % direct wave
    raysegNum = evtL+1;
    sinN(1:evtL) = velMod(1:evtL)/velMod(evtL)*sin(angle*pi/180);
    tanN(1:evtL) = sinN(1:evtL)./sqrt(1-sinN(1:evtL).^2);
    distN(1:evtL-1) =  thickness(1:evtL-1).*tanN(1:evtL-1);
    distN(evtL) = deplayerTop*tanN(evtL);
    cumdistN = cumsum(distN);
    cumeleN = cumsum([deplayerTop,thickness(evtL-1:-1:1)]);
    segPoint(1,1:2:3) =  evt_loc;segPoint(1,2) = 0;
    segPoint(2,1:2:3) = repmat(evt_loc,1,1) + [cumdistN(1)  deplayerTop];
    segPoint(2,2) = 0;
    if raysegNum > 2
    segPoint(3:raysegNum,1:2:3) = repmat(evt_loc,raysegNum-2,1) + ...
        [cumdistN(2:evtL)' cumeleN(2:evtL)'];
    segPoint(3:raysegNum,2) = 0;
    end
    plot(segPoint(:,1),segPoint(:,3),'lineWidth',1)
elseif isRefract == 1 % refrected wave
   for i = 1:length(velMod)
    plot([-max(delta,depthMod(refractLayer))-20,max(delta,depthMod(refractLayer))-20],[-depthMod(i),-depthMod(i)],'lineWidth',1)
    hold on
    axis tight
   end

   raysegNum = 2*refractLayer-evtL;
   rayptNum = raysegNum+1;
   vRefract = velMod(refractLayer);
   SQT = sqrt(repmat(vRefract,1,nl).^2-velMod.^2);
   SQTVmVn = SQT/vRefract./velMod;
   VnSQT = velMod./SQT;
   distN(1) = deplayerBot*VnSQT(evtL);
   distN(2:refractLayer-evtL) = thickness(evtL+1:refractLayer-1).*VnSQT(evtL+1:refractLayer-1);
   distN(refractLayer-evtL+2:2*refractLayer-evtL) = thickness(refractLayer-1:-1:1)...
       .*VnSQT(refractLayer-1:-1:1);
   distN(refractLayer-evtL+1) = delta-sum([distN(1) sum(distN(2:refractLayer-evtL)) ...
       sum( distN(refractLayer-evtL+2:2*refractLayer-evtL))]);
   cumdistN = cumsum(distN);
   cumeleN = -cumsum([deplayerBot,thickness(evtL+1:refractLayer-1),0,-thickness(refractLayer-1:-1:1)]);
   
    segPoint(1,1:2:3) =  evt_loc;
    segPoint(1,2) = 0;
    segPoint(2,1:2:3) = repmat(evt_loc,1,1) + [cumdistN(1)  cumeleN(1)];
    segPoint(2,2)=0;
    if rayptNum > 2
    segPoint(3:rayptNum,1:2:3) = repmat(evt_loc,rayptNum-2,1) + ...
        [cumdistN(2:end)' cumeleN(2:end)'];
    segPoint(3:rayptNum,2) = 0;
    end
    plot(segPoint(:,1),segPoint(:,3),'lineWidth',1)
end

end
