function str = classname(i)
% CLASSNAME
% CLASSNAME(i) returns the string representation of the ith class
switch i
    case 1
        str = 'sitting';
    case 2
        str = 'sittingdown';
    case 3
        str = 'standing';
    case 4
        str = 'standingup';
    case 5
        str = 'walking';
end