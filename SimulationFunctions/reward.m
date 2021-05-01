%reward_v: value of possible reward related to the action;
%reward_p: probability of each possible reward
function r=reward(reward_v,reward_p)

indx=max(find([-eps cumsum(reward_p)]<rand));
r=reward_v(indx);