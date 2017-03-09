/* .................................................................................*\
.                     TRAJECTORY OF A PROJECTILE ON EARTH:                           .
.                   GRAVITY, QUADRATIC DRAG AND CORIOLIS FORCE                       .
.                                 Aslam Khalil                                       .  
.         Department of Physics, Portland State University, Portland Oregon 97207    .            
.   			                   April 2013                                        .             
.                             AirResistCoriolisV3.cpp	                             .
.                                                                                    .
.                                                                                    . 
.	WHAT THE PROGRAM DOES: It calculates the position in time of a projectile moving . 
.   in the Earth's atmosphere subject to air resistance, gravity, bhoyancy and       .
.   Coriolis forces. The motion is in three dimensions when all forces are present   . 
.   and described by the coupled equations:                                          . 
.                                                                                    . 
.	dvX/dt = -c/m v.vX + 2 Omega [vY cos(phi) - vZ sin(phi)]                     .
.       dvY/dt = -c/m v.vY - 2 Omega vX cos(phi)                                     .
.	dvZ/dt = -g(1-mAir/m) - c/m v.vZ + 2 Omega vX sin (phi)                      . 
.       dx/dt = vX                                                                   . 
.       dy/dt = vY                                                                   .
.       dz/dt = vZ                                                                   . 
.                                                                                    .
.	c = air resistance, g = gravitational acceleration, Omega = angular speed of     .
.   the Earth's rotation, phi = co-latitude, mAir is the mass of air in the same     . 
.   volume as the object of the trajectory. This is only effective under unusual     .
.   cases such as foam or ping pong balls                                            . 
.                                                                                    .                                                                                 . 
.	The output is time t, xNoResist(t), zNoResist(t) for no wind resistance          .
.   and no Coriolis force, xResist(t), zResist(t) for the position with wind         .
.	resistance and x(t), y(t), z(t) for both air resistance and Coriolis forces      .
.                                                                                    .
.   Output goes to a file: AirResistQuad.txt for plotting.                           . 
.                                                                                    . 
\*..................................................................................*/

#include <iostream>
#include <fstream>
#include <cmath>
#include <iomanip>
using namespace std;

float velocity(float x, float y, float z);



int main()
{

	//  MOTION VARIABLES... 
	
	double x, z, y, xNoResist, zNoResist;												
	float  x0, y0, z0, v0, theta0;
	double vX, vY, vZ, vTerminal; 

	
	//  OBJECT VARIABLES ... 
	
	float m, D, c;								 

	//  ENVIRONMENTAL VARIABLES ...											
	
	float g, gamma, omega;					
	float rhoAir;
	float phi;
	
	//  COMPUTATION VARIABLES...												
	
	float t, tMax, range, timeStep;		
	float k1X, k2X, k3X, k4X;
	float k1Y, k2Y, k3Y, k4Y;
	float k1Z, k2Z, k3Z, k4Z;
	float vXavg, vYavg, vZavg;
	char  deUsual,d; 
	float timeOfFlight;
	
	//  PARAMETER VALUES & INITIAL CONDITIONS ...		    
	
	g       = 9.8                           ;// m/s^2
	omega   = 7.272e-5                      ;// radians/s
	gamma   = 0.25                          ;// kg/m^3
	phi     = 45                            ;// degrees
	rhoAir  = 1.2                           ;// kg/m^3
	
	m       = 0.25                          ;// kg									
	D       = 0.1                           ;// m
		
	v0      = 10                            ;// m/s
	theta0  = 60                            ;// degrees
	
	x0      = 0; y0       = 0;       z0 = 0 ;// m
	t       = 0; timeStep = 0.005; tMax = 5 ;// s
	
	

	
	// KEYBOARD INPUT ...
	
	cout << " Trajectory of a Projectile. " << endl;
	cout << " Five variables are needed: the diameter of the ball (0.1m)" << endl;
	cout << " mass (0.25), initial velocity (10 m/s), the angle of launch (60 " << endl;
	cout << " degrees) and the co-latitude (45 degrees). The launch is at the " << endl;
	cout << " specified angle along the East-West direction.  " << endl;   
	cout << " Values in parantheses are default. To accept these enter 'd' " << endl;
	cout << " otherwise press any other key " << endl; cin >> deUsual;
	cout << endl;
	
	if (deUsual != 'd')
	{
		cout << " Diameter    (0.1m  ) : "; cin >> D;
		cout << " Mass        (0.25k ) : "; cin >> m;
		cout << " Velocity    (10m/s ) : "; cin >> v0;
		cout << " Angle       (60 deg) : "; cin >> theta0;
		cout << " Co-latitude (45 deg) : "; cin >> phi;
		
		timeOfFlight = (2*v0*sin(theta0*(3.1416/180))/g); //(1)
		tMax = 5*timeOfFlight;
	}
	
	c = gamma * pow(D,2);
	g -= rhoAir * (3.14159/6) * pow(D,3) / m;
	vTerminal =  sqrt(m*g/c);
	
	
	
	ofstream airResist;
	//OPEN File for input.
	airResist.open ("AirResistQuad.txt");
	if (!airResist) 
	{
		cout << "Error opening trajectory file for output " << endl;
		return -1;
	}

	for (t = 0; t < tMax; t += timeStep)
	{
		if (t==0) 
		{
			vX = v0*cos(theta0*(3.1416/180));
			vY = 0;
			vZ = v0*sin(theta0*(3.1416/180));
			
			x = x0;
			y = y0;
			z = z0;
		}
		else 
		{
			
			k1X = (-(c/m) *  velocity( vX,           vY, vZ) *  vX              + 2*omega*(vY*cos(phi) - vZ*sin(phi)) ) * timeStep;
			k2X = (-(c/m) *  velocity((vX + (k1X/2)),vY ,vZ) * (vX + (k1X/2) )  + 2*omega*(vY*cos(phi) - vZ*sin(phi)) ) * timeStep;
			k3X = (-(c/m) *  velocity((vX + (k2X/2)),vY ,vZ) * (vX + (k2X/2) )  + 2*omega*(vY*cos(phi) - vZ*sin(phi)) ) * timeStep;
			k4X = (-(c/m) *  velocity((vX +  k3X)   ,vY ,vZ) * (vX +  k3X    )  + 2*omega*(vY*cos(phi) - vZ*sin(phi)) ) * timeStep; // (2) 
			
			vXavg = vX + (k1X + 2*k2X + 2*k3X + k4X)/12;
			vX += (k1X + 2*k2X + 2*k3X + k4X)/6;
			
			k1Y = -((c/m) *  velocity(vX, vY, vZ)         *  vY               - 2*omega*vX*cos(phi) ) * timeStep;
			k2Y = -((c/m) *  velocity(vX, vY +(k1Y/2), vZ)* (vY + (k1Y/2) )   - 2*omega*vX*cos(phi) ) * timeStep;
			k3Y = -((c/m) *  velocity(vX, vY +(k2Y/2), vZ)* (vY + (k2Y/2) )   - 2*omega*vX*cos(phi) ) * timeStep;
			k4Y = -((c/m) *  velocity(vX, vY + k3Y   , vZ)* (vY +  k3Y    )   - 2*omega*vX*cos(phi) ) * timeStep;
			
			vYavg = vY + (k1Y + 2*k2Y + 2*k3Y + k4Y)/12;
			vY += (k1Y + 2*k2Y + 2*k3Y + k4Y)/6;
			
			
			k1Z = (-g  -(c/m) *  velocity(vX, vY, vZ)            * vZ              + 2*omega*vY*sin(phi) )* timeStep;
			k2Z = (-g  -(c/m) *  velocity(vX, vY, vZ + (k1Z/2))  * (vZ + (k1Z/2))  + 2*omega*vY*sin(phi) )* timeStep;
			k3Z = (-g  -(c/m) *  velocity(vX, vY, vZ + (k2Z/2))  * (vZ + (k2Z/2))  + 2*omega*vY*sin(phi) )* timeStep;
			k4Z = (-g  -(c/m) *  velocity(vX, vY, vZ +  k3Z   )  * (vZ +  k3Z   )  + 2*omega*vY*sin(phi) )* timeStep;
			
			vZavg = vZ + (k1Z + 2*k2Z + 2*k3Z + k4Z)/12;
			vZ += (k1Z + 2*k2Z + 2*k3Z + k4Z)/6;
			
			x += vXavg * timeStep;
			y += vYavg * timeStep;
			z += vZavg * timeStep;
			
			if ((x != 0) && (z < 0.1) && (z > -0.1)) {
			range = x;	// (3) 
			
			}
			
		}
		
		xNoResist = v0*cos(theta0*(3.1416/180)) * t;
		zNoResist = v0*sin(theta0*(3.1416/180)) * t  -  (g/2)* pow(t,2 );
		
		airResist <<"\t " << fixed;
		airResist << setprecision(4)<< t << "   " << x << "   " << y << "   " << z << "   " <<  xNoResist << "    " << zNoResist << endl; // (4)
		
		cout <<"\t " << fixed;
		cout << setprecision(4)<< t << "   " << x << "   " << y << "   " << z << "   " <<  xNoResist << "    " << zNoResist << endl;
		
		if (z < -1) 
		{	 	
			cout << endl << "Done " << endl; 
			break; // (5)
		}
		
	}
		
	//CLOSE File.						
	airResist.close();							

	cout << "Terminal velocity    : " << setprecision(2) << vTerminal << " m/s  "   << endl;
	cout << "Range                : " << setprecision(2) << range     << "  m   "   << endl;
	cout << "Effective g (g0=9.8) : " << setprecision(2) << g         << "  m/s^2"  << endl;  
	
	return 0;
}

float velocity(float x, float y, float z)
{
	double v;
	v = sqrt(pow(x,2)+pow(y,2)+pow(z,2));
	return v;
}



/*  FOOTNOTES: Program Documentation. 


	
MOTION VARIABLES... 
												x = horizontal distance.
												z = vertical distance.
												The trajectory to be calculated is z = z(x) 				
												zNoResist = trajectory without air
												resistance.
												x0, y0, z0, v0 and theta0 = Initial conditions. 
												vX = velocity in the horizontal direction.
												vY = velocity in horizontal direction. Effective
												when Coriolis force is active, otherwise motion
												is in 2-d.
												vZ = velocity in the vertical direction.
												vTerminal = terminal velocity.
																											
												N.B. Units are mks.    
												
OBJECT VARIABLES ... 
												m =  mass of the object.
												D =  diameter of the bead. 
												c = gamma x diameter squared. 
												
ENVIRONMENTAL VARIABLES ...
												g = Acceleration due to gravity.
												gamma = coefficient of air resistance in N s^2/m^4.
												omega = rotational frequency of the Earth = 2 pi 
												radians in 24 hrs.
												t = time.   
												
COMPUTATION VARIABLES...
												tMax = maximum time for calculation.
												range = range of the bead on the surface of
												launch.
												timeStep = step size for calculating trajectory	
												kiX = intermediate variables for Runge-Kutta 4th order
												method for calculating the velocity vX. i = 1,2,3,4.
												kiY and kiZ = Same as kiX, except for the Y and Z-directions.
												vXavg = 1/2 (vXi+1 + vXi).
												vYavg = 1/2 (vYi+1 + vYi).
												vZavg = 1/2 (vZi+1 + vZi).
												These give better estimates of x and z than using 
												x = vX * timeStep
												timeOfFlight = the time of flight of the projectile
												to reach its range when there is no air resistance.
												It is used to calculate the tMax - maximum time for which
												the calculations should be done.
												
Numbered Footnotes...							
												(1) The maximum time for calculation has to be determined or
												specified by some criteria.  Here I have set it as 
												2 x the time of flight without air resistance which is given
												by the formula in the variable timeOfFlight.
												(2) The 4th order Runge-Kutta Method is used to calculate the 
												velocities in the x and z directions.
												(3)	The range of the projectile with air resistance.
												it is sensitive to the criteria.  If too narrow, it does
												not find the range.
												(4) In the file writing line, the " \t " is put there
												because otherwise Lotus 123 does not parse the data
												correctly for plotting.
												(5) This keeps the trajectory from going too far down in negative 
												z terratory. It should be set to whatever maximum value of z
												is needed.
												*/


