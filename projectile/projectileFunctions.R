
velocity <- function(x, y, z)
{
	v = sqrt(x^2+y^2+z^2)
	return(v)
}

plotTrajectories <- function(airResist, rad)
{
	rgl.spheres(
			x= airResist$x,
			y= airResist$y,
			z= airResist$z,
			zlim= c(0, max(airResist$z)),
			radius= 0.1,
			color= "red",
			xlim= c(0,10),
			axis= TRUE
			)
	axes3d(edge= c("x--", "y--", "z--"))
	arTrunc <- subset(
				subset(
					airResist, 
					xNoResist <= 2*max(airResist$x)
					),
				zNoResist <= 2*max(airResist$z)
				)
	rgl.spheres(
			x= arTrunc$xNoResist,
			y= 0,
			z= arTrunc$zNoResist,
			color= "blue",
			add= TRUE,
			radius= 0.1
			)
	
}


QuadCorrProj <- function(
				m, D, 
				v0, theta0, 
				g, omega, alpha, rhoAir, phi, 
				X0, t0, timeStep, tMax
				)
	{
#  		Object:
#  		m is the mass of the projectil in kg
#  		D is the diameter of the projectile in m
 		
#  		Launch:
#  		v0 is the initial velocity in m/s
#  		theta0 is the initial angle in radians
 		
# 		Environment: 		
#  		g is the surface gravity in m/s^2
#  		omega is the siderial angular frequency in rad/s
#  		alpha is a constant between 1 and 2
# 	 	rhoAir is the density of the air in kg/m^3
#  		phi is the lattitude in radians
 		
#  		Simulation:
#  		X0 is the starting position in x m, y m, z m
#  		t0 is the starting time in s
#  		timeStep is the incriment of time in s
#  		tMax the time at which the simulation stops in s
 		
		tSteps <- seq(from= t0, to= tMax, by= timeStep)
		cat(
			"This will do", scientific(length(tSteps)), "steps,\n",
			"evaluating from t= ", t0, 
			" to t= ", format(tMax, digits= 3), " (maximum)\n",
			"Press ctrl+C or escape to cancel.\n"
			)
		
		airResist <- data.frame( matrix(ncol= 6, nrow= length(tSteps)) )
		colnames(airResist) <- c("t", "x", "y", "z", "xNoResist", "zNoResist")
		
		gamma <- 4*pi*alpha*rhoAir	#kg/m^3, 
		c <- gamma*D^2			#kg/m, drag coefficient (bad name: overloads concatenation fxn, c().)
		gEff <- g -rhoAir*(pi/6)*D^3	#m/s^2, effective gravity
		vTerminal <- sqrt(m*gEff/c)	#m/s, terminal velocity
		
		x0 <- X0[1]
		y0 <- X0[2]
		z0 <- X0[3]	#m, starting position (cartesian approximation)
		
		for(t in tSteps)
		{
			if(!t %% 10)
			{
				cat(
					t, 
					"/", 
					format(tMax, digits= 3), 
					" evaluated.\n")
			}
			
			if(t==0)
			{
				vX <- v0*cos(theta0)
				vY <- 0
				vZ <- v0*sin(theta0)
				
				x <- x0
				y <- y0
				z <- z0
				
			}
			else
			{
				k1X <- (-(c/m) *  velocity( vX,           vY, vZ) *  vX              + 2*omega*(vY*cos(phi) - vZ*sin(phi)) ) * timeStep
				k2X <- (-(c/m) *  velocity((vX + (k1X/2)),vY ,vZ) * (vX + (k1X/2) )  + 2*omega*(vY*cos(phi) - vZ*sin(phi)) ) * timeStep
				k3X <- (-(c/m) *  velocity((vX + (k2X/2)),vY ,vZ) * (vX + (k2X/2) )  + 2*omega*(vY*cos(phi) - vZ*sin(phi)) ) * timeStep
				k4X <- (-(c/m) *  velocity((vX +  k3X)   ,vY ,vZ) * (vX +  k3X    )  + 2*omega*(vY*cos(phi) - vZ*sin(phi)) ) * timeStep
				
				if ( (k1X==Inf) || (k2X==Inf) || (k3X==Inf) || (k4X==Inf) ){
					message(
						"One of the Runge-Kutta k values has overflowed.\n",
						"I haven't implemented arbitrary precision here yet, sorry. ~Joe")
					return("overflow")
				}
				
				vXavg <- vX + (k1X + 2*k2X + 2*k3X + k4X)/12
				vX <- vX +(k1X + 2*k2X + 2*k3X + k4X)/6
				
				k1Y <- -((c/m) *  velocity(vX, vY, vZ)         *  vY               - 2*omega*vX*cos(phi) ) * timeStep
				k2Y <- -((c/m) *  velocity(vX, vY +(k1Y/2), vZ)* (vY + (k1Y/2) )   - 2*omega*vX*cos(phi) ) * timeStep
				k3Y <- -((c/m) *  velocity(vX, vY +(k2Y/2), vZ)* (vY + (k2Y/2) )   - 2*omega*vX*cos(phi) ) * timeStep
				k4Y <- -((c/m) *  velocity(vX, vY + k3Y   , vZ)* (vY +  k3Y    )   - 2*omega*vX*cos(phi) ) * timeStep
				
				vYavg <- vY + (k1Y + 2*k2Y + 2*k3Y + k4Y)/12
				vY <- vY +(k1Y + 2*k2Y + 2*k3Y + k4Y)/6
				
				
				k1Z <- (-g  -(c/m) *  velocity(vX, vY, vZ)            * vZ              + 2*omega*vY*sin(phi) )* timeStep
				k2Z <- (-g  -(c/m) *  velocity(vX, vY, vZ + (k1Z/2))  * (vZ + (k1Z/2))  + 2*omega*vY*sin(phi) )* timeStep
				k3Z <- (-g  -(c/m) *  velocity(vX, vY, vZ + (k2Z/2))  * (vZ + (k2Z/2))  + 2*omega*vY*sin(phi) )* timeStep
				k4Z <- (-g  -(c/m) *  velocity(vX, vY, vZ +  k3Z   )  * (vZ +  k3Z   )  + 2*omega*vY*sin(phi) )* timeStep
				
				vZavg <- vZ + (k1Z + 2*k2Z + 2*k3Z + k4Z)/12
				vZ <- vZ +(k1Z + 2*k2Z + 2*k3Z + k4Z)/6
				
				x <- x +vXavg * timeStep
				y <- y +vYavg * timeStep
				z <- z +vZavg * timeStep
# 				message("x=", x)
				if( (x>=0 && x<=0) || (y>=0 && y<=0) || (z>=0 && z<=0) ) message("The acceleration variable probably overflowed. I still need to implement arbitrary precision, sorry. ")
				if((x != 0) && (z < 0.1) && (z > -0.1))
					range <- x
				
			}
			
			xNoResist <- v0*cos(theta0)*t
			zNoResist <- v0*sin(theta0) * t  -  (g/2)* t^2
			
			airResist <- rbind(
				airResist, 
				c(t, x, y, z, xNoResist, zNoResist) 
			)
			
			if (z < -1)
			{	 	
				cat("Done at t=", t, "seconds.\n")
				break
			}
			
		}
		
		return( na.omit(airResist) )
 	}

