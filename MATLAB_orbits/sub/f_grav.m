function fab= f_grav(posa, posb, ma, mb)
% returns the force vector that a exerts on b
G= 1;
fab= (-G*ma*mb/norm(posb-posa)^3).*(posb-posa);