function T = ttime1D_main(f_velmod,f_evt_sta,f_out)
%Programing main driving function
%Input: 
%   f_velmod: input velocity model file
%   f_evt_sta: event station pair
%   f_out: output travel time table file name
%Return:
%   T: travel time table 
%% read vel.mod
fIDVel = fopen(f_velmod);
lineNum = 0;
while ~feof(fIDVel)
    tline = fgetl(fIDVel);
    if tline(1) ~='*';
        lineNum = lineNum +1;
        switch lineNum
            case 1
                nl = sscanf(tline,'%d');
            case 2
                velMod = sscanf(tline,'%f');
            case 3
                ratio = sscanf(tline,'%f');
            case 4
                depthMod =  sscanf(tline,'%f');
        end
    end
end
%% read evt_sta.dat
fIDEvt = fopen(f_evt_sta);
evtstaData = textscan(fIDEvt,'%d %f %f %f %s %f %f');
evtID = evtstaData{1};
evtLat = evtstaData{2};
evtLon = evtstaData{3};
evtDep = evtstaData{4};
depthEvent = evtDep;
staName = evtstaData{5};
staLat = evtstaData{6};
staLon = evtstaData{7};
[xEvt,yEvt,fEvt] = ll2utm(evtLat,evtLon);
[xSta,ySta,fSta] = ll2utm(staLat,staLon);
delta = sqrt((xSta-xEvt).^2+(ySta-yEvt).^2)/1000;%in km


%% Calculate ttime


for i = 1 : length(delta)
    [ angle(i), travelTime(i),flag(i),refractLayer(i) ] = traveltimeCal( velMod',depthMod',delta(i),depthEvent(i));
end
T = table(evtID,staName,travelTime', angle',delta);
header={'EvtID','StaNM','TTime','Angle','Delta'};
T.Properties.VariableNames = header;
writetable(T,f_out,'WriteVariableNames',true);
end

