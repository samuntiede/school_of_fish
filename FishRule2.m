% Implement RULE 2 for a school matrix: Cohesion
% (move towards center of mass of neighbors)
% The resulting update matrix has zeros in the first two columns.
%
% Arguments:
% school      Nx4 matrix of school positions and velocities
% R          Radius of neighborhood to consider in evasive action
% globratio  fraction of global school center taken into account, range [0,1]
% 
% Returns:
% update     Nx4 matrix with velocity update in columns 3 and 4
%
% Samuli Siltanen December 2018

function update = FlockUpdateRule2(school,R,globratio)

if (globratio>1)|(globratio<0)
    error('globratio should be between zero and one')
end

% Record number of fish in the school
Nfish = size(school,1);

% Initialize update
update = zeros(Nfish,4);

% Loop over fish
for jjj = 1:Nfish
    % Determine closeby fish
    nbors = FindNeighbors(school,jjj,R+(R/3)*(rand-.5));
    Nnbors = size(nbors,1);
    
    % Record the position of the current fish
    curpos = school(jjj,1:2);
    
    % Record the middle of the rest of the school
    avepos_rest = mean(school([1:(jjj-1),(jjj+1):end],1:2));
    
    if Nnbors>3 % if there are more than three neighbors in the R-disc
        % Calculate average position of neighbors in the R-disc
        avepos_near = mean(nbors(:,1:2));
        % Calculate direction towards a weighted average of the two averages
        update(jjj,3:4) = ((1-globratio)*avepos_near+globratio*avepos_rest) - curpos;        
    else
        % if there is at most three other fish in the R-disc,
        % move towards center of rest of the school.
        update(jjj,3:4) = avepos_rest-curpos;
    end
end
update = MaxVeloEnforce(update);
