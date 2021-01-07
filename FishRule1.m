% Implement RULE 1 for a school matrix: Separation (avoid collision).
% The resulting update matrix has zeros in the first two columns.
%
% Arguments:
% school   Nx4 matrix of school positions and velocities
% R        Radius of neighborhood to consider in evasive action
%
% Returns:
% update   Nx4 matrix with velocity update in columns 3 and 4
% indvec   indices to fish with no close-by neighbors
%
% Samuli Siltanen January 2021

function [update,indvec] = FishRule1(school,R)

% Record number of fish in the school
Nfish = size(school,1);

% Initialize update
update = zeros(Nfish,4);
indvec = [];

% How many directions to check
Ndir0 = 20;

% Loop over fish
for jjj = 1:Nfish

    % Set of directions to consider
    fiivec = 2*pi*[0:(Ndir0-1)]/Ndir0;
    Ndir   = length(fiivec);
    
    % Record position of current fish
    curx = school(jjj,1);
    cury = school(jjj,2);
    
    % Determine closeby fish within radius R
    [nbors,nvecs] = FindNeighbors(school,jjj,R);
    Nnbors = size(nbors,1);
    
    % Calculate velocity vector
    if Nnbors>0 % if there are neighbors in the R-neighborhood
        % Loop over directions
        fish_in_dir = zeros(Ndir,1);
        for iii = 1:Ndir
            % Current direction
            dirvec = [cos(fiivec(iii)),sin(fiivec(iii))];
            % Find how many closeby fish there are towards the current direction
            dotprodvec = dirvec*nvecs.';
            fish_in_dir(iii) = length(find(dotprodvec>0));
        end
        % Find the direction with the least amount of closeby fish
        tmpindvec = find(fish_in_dir==min(fish_in_dir));
        index = tmpindvec(1);
        update(jjj,3:4) = [cos(fiivec(index)),sin(fiivec(index))];
    else % no neighbors closer than R
        indvec = [indvec;jjj];
    end
end


