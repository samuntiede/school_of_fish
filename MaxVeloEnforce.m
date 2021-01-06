% Adjust the velocity vectors of the argument flock matrix so that any
% vector longer than 1 is shortened to length 1. This is used for keeping
% the maximum velocity of any given bird under control.
%
% Arguments:
% flock   Nx4 matrix of flock positions and velocities, or Nx2 matrix of velocities
%
% Returns:
% result  Velocities modified so that larger-than-one velocities are decreased to one
%
% Samuli Siltanen December 2018

function result = MaxVeloEnforce(flock)

if size(flock,2)==4 % Matrix with both positions and velocities
    
    % Pick out velocity part of the flock matrix
    tmp = flock(:,3:4);
    
    % Calculate lengths of velocity vectors
    lens = sqrt(tmp(:,1).^2+tmp(:,2).^2);
    
    % Modify length vector
    lens = max(lens,1);
    
    % Construct the result
    result = [flock(:,1:2),flock(:,3)./lens,flock(:,4)./lens];
    
elseif size(flock,2)==2 % Matrix with only velocities
    
    % Calculate lengths of velocity vectors
    lens = sqrt(flock(:,1).^2+flock(:,2).^2);
    
    % Modify length vector
    lens = max(lens,1);
    
    % Construct the result
    result = [flock(:,1)./lens,flock(:,2)./lens];    
end
    