function h= particlePlot(P, Pnext, scale, sty, col)
% h= particlePlot(P, scale)
% Plots little spheres for the particle structure, P. Sphere radius is
% particle mass times scale. particlePlot() returns a vector of handles 
% for the spheres plotted. 

held= ishold;
[sx, sy, sz]= sphere(10);
h= nan(1, length(P));

for n= 1:length(P)
    if strcmp(sty, 'sphere')
        psx= P(n).mass.*sx.*scale +P(n).pos(1);
        psy= P(n).mass.*sy.*scale +P(n).pos(2);
        psz= P(n).mass.*sz.*scale +P(n).pos(3);
        
        h(n)= surf(psx, psy, psz);
        alpha(h(n), 0.5)
        set(h(n), 'LineStyle', 'none')
    elseif strcmp(sty, '*') || strcmp(sty, 'o') || strcmp(sty, '.')
        disp(col)
        h(n)= plot3(P(n).pos(1),P(n).pos(2),P(n).pos(3), sty, 'Color', col);
    elseif strcmp(sty, 'line')
        X= [Pnext(n).pos(1), P(n).pos(1)];
        Y= [Pnext(n).pos(2), P(n).pos(2)];
        Z= [Pnext(n).pos(3), P(n).pos(3)];
        h(n)= plot3(X,Y,Z, 'Color', col);
    else
        error('unknown style')
    end
    
    if ~ishold
        hold on
    end
end

if held ~= ishold
    hold off
end




% XYZ= cat(1,P.pos);
% XYZ(:,1);
% plot3(XYZ(:,1), XYZ(:,2), XYZ(:,3), '*')
% 
% [X,Y,Z]= sphere(20);
% surf(X,Y,Z)
% hold on
% surf(X+1,Y+1,Z+1)
% view(45,45)
% axis equal square