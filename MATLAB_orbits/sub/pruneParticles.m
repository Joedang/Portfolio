function Pout= pruneParticles(Pin)
% returns the particles which are marked to still exist
Pout= Pin([Pin.exists]);