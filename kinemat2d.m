function kinemat2d(vi,theta,m1,m2,eTime,j)
%KINEMAT2D simulates the projectile motiin of a launched object exploding 
%into two masses as well as the centroid trajectory
%given the inputs of initial velocity, angle, mass of piece 1 and 2, time
%of explosion and the impulse of the explosion
%{
Adam Liber
ITP 168 - Fall 2015
Homework 8
aliber@usc.edu

date                   change                 programmer
--------------------------------------------------------
11/1/2015              original               Adam Liber
%}

if nargin ~= 6
     error('wrong number of inputs');
end

if length(vi) ~= 1 || length(theta) ~= 1 
    error('input must be scalar')
elseif m1 <= 0 || m2 <= 0 || j < 0 || eTime < 0
     error('masses, impulse, and explosion time must be positive')
elseif theta <= 0 || theta >= 90
     error('angle must be >0 and <90')
end


g = 9.81;
t = (2*vi*sind(theta))/g;
if eTime >= t
     error('time of explosion must occur before the time it hits the ground')
end

range = vi*cosd(theta)*t;
tvec = linspace(0,eTime);
vx0 = vi*cosd(theta);
vy0 = vi*sind(theta);
x0 = 0;y0 =0;
xPos = kinemat1d(tvec,vx0,0,x0);
yPos = kinemat1d(tvec,vy0,-g,y0);

launch = plot(xPos,yPos,'k-');
for i = 1:100
axis([0 1.5*range 0 max(yPos)+10]);
set(launch,'XData',xPos(1:i));
set(launch,'YData',yPos(1:i));
drawnow;
end
hold on


eTimeVec = linspace(0,t-eTime);
vY = vy0 + (-g)*eTime;
x1 = kinemat1d(eTime,vx0,0,x0);
y1 = kinemat1d(eTime,vy0,-g,x0);
yPos = kinemat1d(eTimeVec,vY,-g,y1);

vm1 = vx0 + j/m1;
vm2 = vx0 - j/m2;
xPos1 = kinemat1d(eTimeVec,vm1,0,x1);
xPos2 = kinemat1d(eTimeVec,vm2,0,x1);
xPosC = kinemat1d(eTimeVec,vx0,0,x1);

centroid = plot(xPos,yPos,'G--');
mass1 = plot(xPos1,yPos,'R-');
mass2 = plot(xPos2,yPos,'B-');

for i = 1:100
    axis([0 1.5*range 0 max(yPos)+10]);
set(centroid,'XData',xPosC(1:i));
set(centroid,'YData',yPos(1:i));
set(mass1,'XData',xPos1(1:i));
set(mass1,'YData',yPos(1:i));
set(mass2,'XData',xPos2(1:i));
set(mass2,'YData',yPos(1:i));
drawnow;
end

hold off
legend show
legend('launch','centroid','mass 1','mass 2');
text(x1,y1,'explosion');
xlabel('distance (m)');
ylabel('height (m)');
title('Grenade!');
end
function pos = kinemat1d(time,velo,accl,x0)
%KINEMAT1D plots projectile motion in 1 dimension
pos = [];
for z = 1:length(time)
   t = time(z);
 newpos = x0 + velo * t + (accl/2)*(t^2);
 pos = [pos newpos];
end
end