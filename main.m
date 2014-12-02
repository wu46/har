% CS229 | Project | Jennifer Wu |10/19/14

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ---- Initialize ----
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd '/Users/jwu/Dropbox/fall14/cs229/project'
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
%% ---- GDA model ----
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:nClasses
    model{i} = trainGDA(data, i);
%     e{i} = testGDA(data,model,i);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---- Test everything! ----
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[~, confusionMatrix] = testGDAall(data,model);
disp(confusionMatrix)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ---- Train softmax ----
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[model, resid, confusionMatrix] = trainSoftmax(data,100);
% trainSoftmaxStochastic(data);
% confusionMatrix = softmaxTrial(data);
% save('cm.mat', 'confusionMatrix');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Issues to address:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Sitting is the same as sittingdown...??
% 2. Rewrite to modularize function for just formatting the data
%   e.g. X = extractTrainingData

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ---- SVM model ----
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% trainSVM(data, 1000, 1000)
path1 = getenv('PATH');
path1 = [path1 ':/usr/local/bin'];
setenv('PATH', path1)
% s = system(['./svm.sh svmTrainData_100 svmTestData_100']);
!./svm.sh -s svmTrainData_1000 svmTestData_1000

