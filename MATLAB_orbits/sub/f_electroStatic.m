function fab= f_electroStatic(posa, posb, qa, qb)
% returns the force vector that a exerts on b
eps0= 1;
fab= (1/(4*pi*eps0)*qa*qb/norm(posb-posa)^3).*(posb-posa);