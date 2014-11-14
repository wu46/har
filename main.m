% CS229 | Project | Jennifer Wu |10/19/14

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ---- Initialize ----
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist('trainingdata', 'var')
    [trainingdata,classRange] = parseData;
end
data = trainingdata;
nClasses = 5;
model = cell(nClasses,1);
e = cell(nClasses,1);

% data has the following fields:
%   name
%   gender
%   age
%   height
%   weight
%   bmi
%   x1,y1,z1
%   x2,y2,z2
%   x3,y3,z3
%   x4,y4,z4
%   class:
%       0 - sitting
%       1 - sittingdown
%       2 - standing
%       3 - standingup
%       4 - walking

% index range for classes
% classRange =
%            1       50631 m = 50631
%        50632       62458 m = 11827
%        62459      109828 m = 47370
%       109829      122243 m = 12415
%       122244      165633 m = 43390


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ---- Train GDA ----
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:nClasses
    model{i} = trainGDA(data, i);
    e{i} = testGDA(data,model,i);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ---- Test everything! ----
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[~, confusionMatrix] = testGDAall(data,model);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ---- Train softmax ----
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
trainSoftmax(data,100);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Issues to address:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Sitting is the same as sittingdown...??
