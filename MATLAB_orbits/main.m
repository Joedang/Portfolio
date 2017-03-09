% cd E:Documents\Class' Documents'\Homework' Rundown'\2015' Winter'\Matlab\Homeworks\Shields_HW5_V1-2\
addpath('sub')

%% setup
clear all % LET IT ALL BURN!!!
close all

scenario= 3; % enter a scenario number or name
% scenarios, since I last updated this list:
% 1, 'random10' - makes 10 particles with random positions, charges, masses
% and velocities
% 2, 'double orbit' - makes two symmetrically orbiting uncharged particles
% (no charge)
% 3, 'planet' - makes a particle orbiting another of 1000 times greater
% mass



nphase= 'setup'; % don't change this
Scenarios
% loadSymFunc

%% do the actual simulating
for nFrame= 1:NFrame
    t= deltat*nFrame;
    Pnext= P;
    for n= 1:length(P) % find the force on each particle, n
        force= [0,0,0];
        for m= 1:length(P) % loop through all of the OTHER particles, m
            if m ~= n % no self-interaction
                force= force +f_electroStatic(P(m).pos, P(n).pos, P(m).charge, P(n).charge);
                force= force +f_grav(P(m).pos, P(n).pos, P(m).mass, P(n).mass);
            end
        end
        deltaVel= deltat*force/P(n).mass;
        deltaPos= deltat*P(n).vel;
        Pnext(n).vel= Pnext(n).vel +deltaVel;
        Pnext(n).pos= Pnext(n).pos +deltaPos;
    end
    
    % cut out particles that have gone too far
    if strcmp(bounding, 'cut')
        for n= 1:length(P)
            if norm(Pnext(n).pos)>rB
                Pnext(n).exists= false;
            end
        end
    elseif strcmp(bounding, 'bounce')
        for n= 1:length(P)
            [C,I]= max(abs(Pnext(n).pos));
            if C>rB
                Pnext(n).vel(I)= -Pnext(n).vel(I);
            end
        end
    end
    
    %% plot the stuff
    color= 'blue';
    h= particlePlot(P, Pnext, scale, style, color);
    title(sprintf('t= %f s', t));
    nphase= 'plot';
    Scenarios
    
    % remove the too-fast particles:
    Pnext= Pnext( ~~([Pnext.exists].*~transpose(sqrt(sum(cat(1,P.vel).^2, 2)) > killspeed))); 
    Pnext= pruneParticles(Pnext);
    P= Pnext;
    
    %% save the current frame to a gif
    frame= getframe;
    im= frame2im(frame);
    [A,map]= rgb2ind(im, 256);
    if nFrame == 1;
        imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',deltat);
    else
        imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',deltat);
    end
end