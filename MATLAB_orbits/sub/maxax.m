function out= maxax()
ax= axis;
out= max( ax(2:2:length(ax)) -ax(1:2:(length(ax))) );