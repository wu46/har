function [testError, trainError] = runSVM(data, mTrain, mTest)
if nargin < 3
    mTest = 1000;
end
% check for m
mMAX = 11827;
if mTrain+mTest > mMAX
    error('NotEnoughTrainingEx',...
        'We don''t have that many training examples!');
end
% fprintf('Training SVM...\n');
featureNames = {...
    'x1'; 'y1'; 'z1';
    'x2'; 'y2'; 'z2';
    'x3'; 'y3'; 'z3';
    'x4'; 'y4'; 'z4'};
% we need to scale all data
% doing that in svm-scale for now

% data = cell, each cell is a struct with data

%
% -- TRAINING --
%
% Write data in a friendly format
% take 90% of each class as training data
% fprintf('Writing training file...')
fname = 'svmTrainData';
fid = fopen(fname, 'w');
for j = 1:5
    %     fprintf('...class %d', j);
    ind = [1 mTrain]; % take 90% of data
    for i = ind(1):ind(2)
        fprintf(fid, '+%d', j);
        for iFeature = 1:size(featureNames,1)
            fprintf(fid, '\t%d:%d', iFeature,...
                data{j}.(featureNames{iFeature})(i));
        end
        fprintf(fid, '\n');
    end
end
fclose(fid);
% fprintf('\n\n Writing testing file...');

%
% -- TESTING --
%
% Write data in a friendly format
% take 90% of each class as training data
m = 0;
fname = 'svmTestData';
fid = fopen(fname, 'w');
for j = 1:5
    %     fprintf('...class %d', j);
    ind = [6000 - mTest + 1 6000];
    for i = ind(1):ind(2)
        fprintf(fid, '+%d', j);
        for iFeature = 1:size(featureNames,1)
            fprintf(fid, '\t%d:%d', iFeature,...
                data{j}.(featureNames{iFeature})(i));
        end
        fprintf(fid, '\n');
    end
end
fclose(fid);
% fprintf('\n DONE!')
fname = 'svmout_test';
fid = fopen(fname, 'r');
s = fgets(fid);
[etest, ~] = sscanf(s, '%*s %*c %f %% %*c %d%*c%d');
fclose(fid);

fname = 'svmout_train';
fid = fopen(fname, 'r');
s = fgets(fid);
[etrain, ~] = sscanf(s, '%*s %*c %f %% %*c %d%*c%d');
fclose(fid);

testError = 100 - etest(1);
trainError = 100 - etrain(1);

% !./svm.sh svmTrainData svmTestData

end
