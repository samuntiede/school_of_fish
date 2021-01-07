% Implement RULE 2 for a school matrix: Cohesion, or in other words moving 
% towards center of mass of all the other fish within radius R. 
%
% Arguments:
% school      Nx4 matrix of school positions and velocities
% R           Radius of neighborhood to consider in calculating local center
% 
% Returns:
% update      Nx4 matrix with zeros in columns 1,2 and velocity update in columns 3,4
%
% Samuli Siltanen January 2021

function update = FishRule2(school,R)

% Record number of fish in the school
Nfish = size(school,1);

% Initialize update
update = zeros(Nfish,4);

% Loop over fish
for jjj = 1:Nfish
    % Determine closeby fish
    [nbors,nvecs] = FindNeighbors(school,jjj,R);
    Nnbors = size(nbors,1);
    
    % Record the position of the current fish
    curpos = school(jjj,1:2);
    
    if Nnbors>0 % if there are at least one neighbor in the R-disc
        % Calculate direction vector pointing towards the average position 
        % of neighbors in the R-disc
        update(jjj,3:4) = mean(nvecs);        
    end
end
