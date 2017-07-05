% loads kayak waypoints from an ASCII text file
% the contents are expected to be rows with comma-separated lat,lon pairs:
%    lat,lon
% with no headings
%
% usage:
%    [lon,lat]=kayak_load_waypoints;
% where
%    lon: waypoint longitude (deg E)
%    lat: waypoint latitude (deg N)
%
% jasmine s nahorniak
% oregon state university
% march 14 2016



function [lon,lat]=kayak_load_waypoints()

[myfile,mypath]=uigetfile('waypoints\*.txt','Select a waypoints file.');

data=load([mypath myfile],'-ascii');
lon=data(:,2);
lat=data(:,1);




