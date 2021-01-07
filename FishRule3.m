% Implement RULE 3 for a school matrix: Alignment.
% The resulting update matrix has zeros in the first two columns.
%
% Arguments:
% school   Nx4 matrix of school positions and velocities
% R        Radius of neighborhood to consider in alignment
%
% Returns:
% update  Nx4 matrix with neighborhood average velocity update in columns 3 and 4
%
% Samuli Siltanen January 2021

function update = FishRule3(school,R)

% Record number of fish in the school
Nfish = size(school,1);

% Initialize update
update = zeros(Nfish,4);

% Loop over fish
for jjj = 1:Nfish
    % Determine closeby fish
    nbors = FindNeighbors(school,jjj,R);
    Nnbors = size(nbors,1);
    
    % Calculate average velocity vector
    if Nnbors>1 % if there are more than one neighbors in the R-neighborhood
        update(jjj,3:4) = mean(nbors(:,3:4));
    end
end


