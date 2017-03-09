# TRAJECTORY OF A PROJECTILE ON EARTH:
# GRAVITY, QUADRATIC DRAG AND CORIOLIS FORCE
# Author(s): Aslam Khalil, Joe Shields
# Dates modified: 2013-04, 2014-04, 2014-09

#Setup the workspace:								####
setwd("~/R/Projectile Simulation")	#the directory holding main.R, projectileFunctions.R, projectile.csv, and planet.csv
# install.packages(c(		#only need to run this once, installs necessary packages
# 			"rgl",
# 			"scales",
# 			"Brobdingnag"
# 			))
library(rgl)		#3d graphics
library(scales)		#scaled axes
# require(Brobdingnag)	#handling large numbers, not currently working
source("projectileFunctions.R")	#loads functions referenced here
projectile <- read.csv(		#loads preset projectile data
			"projectile.csv", 
			comment.char= "#", 
			row.names= c("mass", "diameter")
			)
planet <- read.csv(		#loads preset planet data
			"planet.csv",
			comment.char= "#", 
			row.names= c("g", "omega", "alpha", "rhoAir")
			)


#Choose situation to simulate:							####
#Preset objects:
planetName 	<-	"Earth"		#options: "Mercury", "Venus", "Earth", "Mars"
projName 	<-	"BaseBall"	#options: "PPBall", "BaseBall", "BasketBall", "BowlingBall", "BeachBall", "CannonBall", "SteelBearing", "NeutroniumBB", "d20"

#Launch Parameters:
v0 		<-	40		#m/s, initial velocity
theta0 		<-	pi/3 		#radians, launch angle
latt		<-	45		#degrees, lattitude


#Tertiary operations:								####
#Projectile:
m <- projectile[projName][1,]	#kg, mass								
D <- projectile[projName][2,] 	#m, diameter

#Environment:
g <- planet[planetName][1,] 		# m/s^2, surface gravity
omega <- planet[planetName][2,] 	#radians/s, siderial angular frequency
# omega <- 0.05
alpha <- planet[planetName][3,] 	#unitless between 1 and 2, fudge factor
rhoAir <- planet[planetName][4,]	#kg/m^3, atmospheric density
phi <- latt*2*pi/360 			#radians, lattitude

# Simulation Parameters:
x0 <- y0 <- z0 <- 0
X0 <- c(x0, y0, z0)		#m, starting position (cartesian approximation)
t0 <- 0 			#s, starting time
timeStep <- 0.01 			#s, step between calculations. If you set this too high, you may get overflowingly large k values. 
timeOfFlight <- (2*v0*sin(theta0)/g)	#s, time to hit the ground
tMax <- 5*timeOfFlight 			#s, maximum time to simulate


# Calculate Trajectory:								####
# source("projectileFunctions.R")	#uncomment for easy rewriting and testing of functions
airResist <- QuadCorrProj(
				m, D, 
				v0, theta0, 
				g, omega, alpha, rhoAir, phi, 
				X0, t0, timeStep, tMax
				)


# Plot the Trajectory:								####
arTrunc <- subset(
			airResist, 
			airResist$z >= 0
			)
radScale <- sqrt(
			max(airResist$z)^2
			+max(airResist$x)^2
			+max(airResist$y)^2
			)/30
rgl.spheres(
		x= airResist$x,
		y= airResist$y,
		z= airResist$z,
		zlim= c(0, max(airResist$z)),
		xlim= c(0, max(airResist$x)),
		ylim= c(0, max(airResist$y)),
		radius= radScale,
		color= "red",
# 		xlim= c(0,10),
		axis= TRUE
		)
axes3d(edge= c("x--", "y--", "z--"))
nrTrunc <- subset(
		subset(
			airResist, 
			xNoResist <= max(airResist$x)
			),
		zNoResist <= max(airResist$z)
		)
rgl.spheres(
		x= nrTrunc$xNoResist,
		y= 0,
		z= nrTrunc$zNoResist,
		color= "blue",
		add= TRUE,
		radius= radScale
		)
cat("Red balls are with air and rotation, blue balls are without.")

#FOOTNOTES: Program Documentation.						####
# 
# MOTION VARIABLES... 
# 	x = horizontal distance.
# 	z = vertical distance.
# 	The trajectory to be calculated is z = z(x) 				
# 	zNoResist = trajectory without air
# 	resistance.
# 	x0, y0, z0, v0 and theta0 = Initial conditions. 
# 	vX = velocity in the horizontal direction.
# 	vY = velocity in horizontal direction. Effective
# 	when Coriolis force is active, otherwise motion
# 	is in 2-d.
# 	vZ = velocity in the vertical direction.
# 	vTerminal = terminal velocity.
# 
# N.B. Units are mks.    
# 
# OBJECT VARIABLES ... 
# 	m =  mass of the object.
# 	D =  diameter of the bead. 
# 	c = gamma x diameter squared. 
# 
# ENVIRONMENTAL VARIABLES ...
# 	g = Acceleration due to gravity.
# 	gamma = coefficient of air resistance in N s^2/m^4.
# 	omega = rotational frequency of the Earth = 2 pi 
# 	radians in 24 hrs.
# 	t = time.   
# 
# COMPUTATION VARIABLES...
# 	tMax = maximum time for calculation.
# 	range = range of the bead on the surface of
# 	launch.
# 	timeStep = step size for calculating trajectory	
# 	kiX = intermediate variables for Runge-Kutta 4th order
# 	method for calculating the velocity vX. i = 1,2,3,4.
# 	kiY and kiZ = Same as kiX, except for the Y and Z-directions.
# 	vXavg = 1/2 (vXi+1 + vXi).
# 	vYavg = 1/2 (vYi+1 + vYi).
# 	vZavg = 1/2 (vZi+1 + vZi).
# 	These give better estimates of x and z than using 
# 	x = vX * timeStep
# 	timeOfFlight = the time of flight of the projectile
# 	to reach its range when there is no air resistance.
# 	It is used to calculate the tMax - maximum time for which
# 	the calculations should be done.
# 
# Numbered Footnotes...							
# 	(1) The maximum time for calculation has to be determined or
# 	specified by some criteria.  Here I have set it as 
# 	2 x the time of flight without air resistance which is given
# 	by the formula in the variable timeOfFlight.
# 	(2) The 4th order Runge-Kutta Method is used to calculate the 
# 	velocities in the x and z directions.
# 	(3)	The range of the projectile with air resistance.
# 	it is sensitive to the criteria.  If too narrow, it does
# 	not find the range.
# 	(4) In the file writing line, the " \t " is put there
# 	because otherwise Lotus 123 does not parse the data
# 	correctly for plotting.
# 	(5) This keeps the trajectory from going too far down in negative 
# 	z terratory. It should be set to whatever maximum value of z
# 	is needed.
	
	