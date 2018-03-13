function [nItems_rand,randomorder] = triplePerm(nConds)

% here we need to do this:
% To control for positional effects, on half of the forced- choice trials, chosen at random, the pairs are presented in the order (a,b,c) and on the other half, 
% (c,b,a). 
% The order in which quadruples are represented is randomized.

% 07/14/2015 bx fixed the random position. 
%clear all;

%nConds = 24;
k = 3;
temp = nchoosek(1:1:nConds,3);
j = 1;

for i = 1:size(temp,1)
    elements = temp(i,:,:);
    % flip coin here, if 1 don't switch, if 2, switch    
    if (binornd(1,0.5) == 1)
       nItems(j,:)   =  [elements(1),elements(2),elements(3)]; 
    else 
       nItems(j,:)   = [elements(3),elements(2),elements(1)]; 
    end
    j= j+1;
end

nTrials = length(nItems);
% Randomize the trials and then seperate them into blocks
randomorder=randperm(nTrials);  
for kk = 1:nTrials
    nItems_rand(kk,:) = nItems(randomorder(kk),:);
end
