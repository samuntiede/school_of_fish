% Function for locating the neighboring fish within a given 
% distance from a specific fish (called center-fish below).
%
% Arguments:
% school  Nx4 matrix of school positions and velocities
% cfrow   number of row of the center-fish
% R       radius (positive number)
%
% Returns:
% nbors  Nx4 matrix with rows of matrix "school" that are closer than R to center-fish
% nvecs  Nx2 matrix of horizontal direction vectors from center-fish towards neighbors in matrix nbors
%
% Samuli Siltanen January 2021

function [nbors,nvecs] = FindNeighbors(school,cfrow,R)

% Make sure that all location coordinates are in the interval [0,1]
school(:,1:2) = school(:,1:2)-floor(school(:,1:2));

% Position of center-fish
cfx = school(cfrow,1);
cfy = school(cfrow,2);

% Vector of distances to center-fish, taking into account the periodic
% boundary conditions
xhorvec = school(:,1).';
xdist = min([abs(xhorvec-cfx);abs(xhorvec-(cfx+1));abs(xhorvec-(cfx-1))]);
xdist = xdist(:);
yhorvec = school(:,2).';
ydist = min([abs(yhorvec-cfy);abs(yhorvec-(cfy+1));abs(yhorvec-(cfy-1))]);
ydist = ydist(:);
dvec = sqrt(xdist.^2+ydist.^2);

% Pick out row numbers of closeby fish, excluding the center-fish's row
index = (dvec<R) & (dvec>1e-14);

% Construct the neighbor matrix to be returned
nbors = school(index,:);

if nargout>1 % In case the function call asks for "nvecs" to be returned
    
    % Construct the direction matrix to be returned. Due to periodic boundary
    % conditions, we need to pick out, among the many equivalent locations,
    % the location of all the other fish closest to the center-fish. That will
    % give the correct direction for moving the center-fish.
    
    % Initialize the matrix 
    nvecs = zeros(size(nbors,1),2);
    
    % Construct nine relevant increments to the x- and y-coordinates to be
    % considered in the periodic setting
    tmp = [-1 0 1];
    [X,Y] = meshgrid(tmp);
    X = X(:);
    Y = Y(:);
    
    % For each neighbor fish, find the closest equivalent location to the
    % center fish. Then calculate the vector with base at center-fish location
    % and end point at the neighbor fish location. Return the components of
    % that vector after normalization to length one. 
    for iii = 1:size(nbors,1)
        xcoords = nbors(iii,1)+X;
        ycoords = nbors(iii,2)+Y;
        dists   = sqrt((xcoords-cfx).^2+(ycoords-cfy).^2);
        minind  = min(find(abs(dists-min(dists))<1e-7)); 
        retvec  = [xcoords(minind)-cfx,ycoords(minind)-cfy];
        retvec  = retvec/sqrt(retvec(1)^2+retvec(2)^2); % Normalization
        nvecs(iii,:) = retvec;
    end
    
end
