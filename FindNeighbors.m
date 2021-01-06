% Function for locating the neighboring birds within a given 
% distance from a specific bird (called center-bird below).
%
% Arguments:
% flock   matrix of flock positions and velocities
% cbrow  number of row of the center-bird
% R         radius (positive number)
%
% Returns:
% nbors  matrix with rows of matrix "flock" that are closer than R to center-bird
%
% Samuli Siltanen December 2018

function nbors = FindNeighbors(flock,cbrow,R)

% Position of center-bird
cbx = flock(cbrow,1);
cby = flock(cbrow,2);

% Vector of distances to center-bird
dvec = sqrt((flock(:,1)-cbx).^2+(flock(:,2)-cby).^2);

% Pick out row numbers of closeby birds, excluding the center-bird's row
index = (dvec<R) & (dvec>1e-14);

% Prepare the matrix to be returned
nbors = flock(index,:);