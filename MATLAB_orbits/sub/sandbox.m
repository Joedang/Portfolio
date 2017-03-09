% cd E:Documents\Class' Documents'\Homework' Rundown'\2015' Winter'\Matlab\Homeworks\Shields_HW5_V1-0\

clear all % LET IT ALL BURN!!!
% close all

N= 10; % number of particles
deltat= 0.1;
T= 1e3;
NFrame= T/deltat;
filename= 'test.gif';
axRange= 10;

P= struct('mass', cell(1,N)); % create a struct of the proper size, so matlab doesn't complain about allocation
for n= 1:N
    P(n).pos= random('unif', -1,1, 1,3);
    P(n).vel= 0.2.*random('unif', -1,1, 1,3);
    P(n).mass= 0.2.*random('unif', 0.1,1);
    P(n).charge= 5.*random('unif', -1,1);
    P(n).exists= true;
end

for nFrame= 1:NFrame
    t= deltat*nFrame;
    Pnext= P;
    for n= 1:length(P) % find the force on each particle
        force= [0,0,0];
        for m= 1:length(P) % loop through all of the OTHER particles
            if m ~= n
                force= force +f_electroStatic(P(m).pos, P(n).pos, P(m).charge, P(n).charge);
            end
        end
        deltaVel= deltat*force/P(n).mass;
        deltaPos= deltat*P(n).vel;
        Pnext(n).vel= Pnext(n).vel +deltaVel;
        Pnext(n).pos= Pnext(n).pos +deltaPos;
    end
    
    P= pruneParticles(Pnext);
    XYZ= cat(1,P.pos);
    XYZ(:,1);
    plot3(XYZ(:,1), XYZ(:,2), XYZ(:,3), '*')
    title(sprintf('t= %f s', t));
%     xlim([-axRange,axRange]);
%     ylim([-axRange,axRange]);
%     zlim([-axRange,axRange]);
    view(45,45)
    axis equal
    axis square
    drawnow
    
    frame= getframe;
    im= frame2im(frame);
    [A,map]= rgb2ind(im, 256);
    if nFrame == 1;
        imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',deltat);
    else
        imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',deltat);
    end
%     pause(deltat);
    
end










