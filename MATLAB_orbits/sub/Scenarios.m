switch scenario
    
    case {1,'random10'}
        if strcmp(nphase, 'setup')
            warning('This scenario isn''t finished yet!')
            % generate particles
            N= 10; % number of particles
            P= struct('mass', cell(1,N)); % create a struct of the proper size, so matlab doesn't complain about allocation
            for n= 1:N
                P(n).pos= [10,10,0].*random('unif', -1,1, 1,3);
                P(n).vel= 0.5.*random('norm',0, 2, 1,3);
                P(n).mass= 1.*random('unif', 0.1,1);
                P(n).charge= 5.*random('unif', -1,1);
                P(n).exists= true;
            end
            
            % general settings
            filename= 'gif\random10.gif';
            deltat= 0.1; % time step
            T= 60; % number of secods to simulate
            NFrame= T/deltat;
            simMethod= 'Euler';
            bounding= 'bounce'; % bounce, cut, or none
            rB= 30; % particles outside this absolute radius are deleted
            killspeed= 10; % particles going faster than this are deleted
            hold on % use hold on to show particle paths (more resource intensive)
            style= 'line'; % style of plot to use (see particlePlot.m)
            scale= 0.1; % scales plotted spheres
            
        elseif strcmp(nphase, 'plot')
            view(45,45)
        else
            error('unknown phase')
        end
        
        
    case {2, 'double orbit'}
        if strcmp(nphase, 'setup')
            warning('This scenario isn''t finished yet!')
            P(1).pos= [1,0,0];
            P(1).vel= [0,0.5,0];
            P(1).mass= 1;
            P(1).charge= 1;
            P(1).exists= true;
            
            P(2).pos= [-1,0,0];
            P(2).vel= [0,-0.5,0];
            P(2).mass= 1;
            P(2).charge= -1;
            P(2).exists= true;
            
            % general settings
            filename= 'gif\ShieldsHW5.gif';
            deltat= 0.1; % time step
            T= 60; % number of secods to simulate
            NFrame= T/deltat;
            simMethod= 'Euler';
            bounding= 'bounce'; % bounce, cut, or none
            rB= 30; % particles outside this absolute radius are deleted
            killspeed= 10; % particles going faster than this are deleted
            hold on % use hold on to show particle paths (more resource intensive)
            style= 'line'; % style of plot to use (see particlePlot.m)
            scale= 0.2; % scales plotted spheres
            
        elseif strcmp(nphase, 'plot')
            view(0,90)
            axis equal
        else
            error('unknown phase')
        end
        
        
    case {3,'planet'}
        if strcmp(nphase, 'setup')
            warning('This scenario isn''t finished yet!')
            
            % this is the circle it's supposed to follow:
            theta= linspace(0, 2*pi, 100);
            R= 5;
            plot(R.*cos(theta), R.*sin(theta), 'Color', 'r');
            
            P(1).pos= [0,0,0];
            P(1).vel= [0,0,0];
            P(1).mass= 1000;
            P(1).charge= 0;
            P(1).exists= true;
            
            P(2).pos= [R,0,0];
            P(2).vel= [0,R,0];
            P(2).mass= 0.01;
            P(2).charge= 0;
            P(2).exists= true;
            
            % general settings
            filename= 'gif\ShieldsHW5.gif';
            deltat= 0.01; % time step
            T= 8; % number of secods to simulate
            NFrame= T/deltat;
            simMethod= 'Euler';
            bounding= 'bounce'; % bounce, cut, or none
            rB= 30; % particles outside this absolute radius are deleted
            killspeed= 20; % particles going faster than this are deleted
            hold on % use hold on to show particle paths (more resource intensive)
            style= 'line'; % style of plot to use (see particlePlot.m)
            scale= 0.2; % scales plotted spheres
            
        elseif strcmp(nphase, 'plot')
            axis equal
            view(0,90)
            drawnow
        else
            error('unknown phase')
        end
        
        
    case {4,'random solar'}
        if strcmp(nphase, 'setup')
            warning('This scenario isn''t finished yet!')
            N= 3; % number of particles
            P= struct('mass', cell(1,N)); % create a struct of the proper size, so matlab doesn't complain about allocation
            for n= 1:N
                P(n).pos= 1.*[1,1,0.1].*random('unif', -1,1, 1,3)+[10,0,0];
                P(n).vel= 0.5.*[1,1,0.1].*random('unif',-1, 1, 1,3)+[0,1,0];
                P(n).mass= 1.*random('unif', 0.1,1);
                P(n).charge= 0.5.*random('unif', -1,1);
                P(n).exists= true;
            end
            P(N+1).pos= [0,0,0];
            P(N+1).vel= [0,0,0];
            P(N+1).mass= 10;
            P(N+1).charge= 0;
            P(N+1).exists= true;
            
            % general settings
            filename= 'gif\ShieldsHW5.gif';
            deltat= 0.1; % time step
            T= 60; % number of secods to simulate
            NFrame= T/deltat;
            simMethod= 'Euler';
            bounding= 'bounce'; % bounce, cut, or none
            rB= 30; % particles outside this absolute radius are deleted
            killspeed= 10; % particles going faster than this are deleted
            hold on % use hold on to show particle paths (more resource intensive)
            style= 'line'; % style of plot to use (see particlePlot.m)
            scale= 0.1; % scales plotted spheres
            
        elseif strcmp(nphase, 'plot')
        else
            error('unkown phase')
        end
        
        
    case {5,'moon'}
        if strcmp(nphase, 'setup')
            warning('This scenario isn''t finished yet!')
            P(1).pos= [0,0,0];
            P(1).vel= [0,0,0];
            P(1).mass= 1000;
            P(1).charge= 0;
            P(1).exists= true;
            
            P(2).pos= [10,0,0];
            P(2).vel= [0,10,0];
            P(2).mass= P(1).mass*1e-5;
            P(2).charge= 0;
            P(2).exists= true;
            
            P(3).pos= P(2).pos+[0.1,0,0];
            P(3).vel= P(2).vel+[0,0.05,0];
            P(3).mass= P(1).mass*1e-5;
            P(3).charge= 0;
            P(3).exists= true;
            
            % general settings
            filename= 'gif\moon.gif';
            deltat= 0.01; % time step
            T= 60; % number of secods to simulate
            NFrame= T/deltat;
            simMethod= 'Euler';
            bounding= 'bounce'; % bounce, cut, or none
            rB= 30; % particles outside this absolute radius are deleted
            killspeed= 20; % particles going faster than this are deleted
            hold on % use hold on to show particle paths (more resource intensive)
            style= 'line'; % style of plot to use (see particlePlot.m)
            scale= 0.2; % scales plotted spheres
            
        elseif strcmp(nphase, 'plot')
            axis equal
            view(10, 80)
        else
            error('unknown phase')
        end
        
    otherwise
        error('unknown scenario number/name')
        
end



% default settings (usually reset by a scenario)
% deltat= 0.1;
% T= 60;
% NFrame= T/deltat;
% filename= 'gif\ShieldsHW5.gif';
% style= 'line';
% simMethod= 'Euler';
% bounding= 'bounce';
% rB= 30;
% hold on % use hold on to show particle paths (more resource intensive)




    
%     axis
%     lockedAxes= (axis >= rB);
%     newAxes= rB.*lockedAxes + axis.*~lockedAxes;
%     axis(newAxes);
%     lockedAxes
%     newAxes
    
    
%     drawnow
%     scale= maxax()/length(P);
%     pause(deltat)

