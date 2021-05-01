%actions: list of all possible actions;
%p: probability of each possible action
function a=choose(actions,p)

indx = max(find([-eps cumsum(p)] < rand));
a=actions(indx);