% Implement a simple "school of fish" behaviour in a shallow pond. The pond
% is modelled by the unit square 0<x<1 and 0<y<1, with periodic boundary
% conditions. 
%
% In this file we test three rules: the "no collision" RULE 1, 
% the "staying together" RULE 2 and the "alignment" RULE 3. 
%
% Samuli Siltanen January 2021

%% Parameters

% Parameters for plotting
msize = 3;
Nframes = 1000;
poolcolor = [220 220 255]/255;
fishcolor = [57 73 104]/255;
lwidth = .5;
fishlen = .02;

% Parameters for the school model
M = 8;
Nfish = M^2;
step = .01; % Maximum length of movement of each fish in each frame
R1 = .04; % Radius for avoiding collisions, related to RULE 1
R2 = .2; % Radius for staying together, related to RULE 2
R3 = .1; % Radius for aligning velocities, related to RULE 3
noiseA = .002; % Amplitude of noise added to the flock matrix in each frame 

%% Build the school matrix

% School model is a matrix containing the positions of fish and the 
% velocity vectors of fish. Each row in the matrix represents one fish. 
% first column:     x-coordinates of locations of fish
% second column:    y-coordinates of locations of fish
% third column:     x-coordinates of velocity vector of fish
% fourth column:    y-coordinates of velocity vector of fish

% Initialize locations
t = linspace(.3,.7,M);
[X,Y] = meshgrid(t);
school = [X(:),Y(:),zeros(Nfish,1),zeros(Nfish,1)];

% Initialization alternative 1: velocities as random vectors
velmat = [2*(rand(Nfish,1)-.5),2*(rand(Nfish,1)-.5)].';
tmp = sqrt(velmat(1,:).^2+velmat(2,:).^2);
velmat = velmat./[tmp;tmp];
school = MaxVeloEnforce([school(:,1:2),velmat.']);

% Initialization alternative 2: velocities as directions toward the origin
% school = MaxVeloEnforce([school(:,1:2),-school(:,1:2)]); 


%% Loop over frames

for iii = 1:Nframes
    
    % Update the velocity part of the school information matrix. This is
    % where the school behaviour modeling happens. 
    school = MaxVeloEnforce(school + 1/6*(.6*FishRule1(school,R1) + FishRule2(school,R2) + FishRule3(school,R3))); 
    
    % Enforce periodic boundary conditions
    school(:,1:2) = school(:,1:2)-floor(school(:,1:2));
    
    % Create plot window
    figure(1)
    clf
    
    % Plot water background
    p11 = patch([1 1 1 0 0],[0 0 1 1 0],poolcolor);
    %set(p11,'EdgeColor',poolcolor)
    hold on
    
    % Plot each fish body individually
    for lll=1:Nfish
        vedir = [school(lll,3),school(lll,4)];
        vedir = vedir/norm(vedir);
        p0 = patch(...
            school(lll,1)+[.2*vedir(1),-.2*vedir(2),-vedir(1),.2*vedir(2)]*fishlen,...
            school(lll,2)+[.2*vedir(2),.2*vedir(1),-vedir(2),-.2*vedir(1)]*fishlen,...
            fishcolor);
        set(p0,'EdgeColor',fishcolor)
        hold on
    end
    % Plot all fish heads
    p1 = plot(school(:,1),school(:,2),'r.','markersize',4*msize);
    set(p1,'color',fishcolor)

    % Axis settings
    axis equal
    axis([-.1 1.1 -.1 1.1 ])
    axis off
    drawnow
    
    % Update positions of fish based on the velocities
    school = [...
        school(:,1)+step*school(:,3),...
        school(:,2)+step*school(:,4),...
        school(:,3:4)];
    
    % Add some random noise to both positions and velocity vectors
    school = school + noiseA*randn(size(school));
    
    disp([iii Nframes])
end
