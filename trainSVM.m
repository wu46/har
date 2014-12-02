function p = trainSVM(data, mTrain, mTest)
if nargin < 3
    mTest = mTrain;
end
% check for m
mMAX = 11827;
if mTrain+mTest > mMAX
    error('NotEnoughTrainingEx',...
        'We don''t have that many training examples!');
end
fprintf('Training SVM...\n');
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
fprintf('Writing training file...')
fname = ['svmTrainData_' num2str(mTrain)];
fid = fopen(fname, 'w');
for j = 1:5
    fprintf('...class %d', j);
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
fprintf('\n\n Writing testing file...');

% 
% -- TESTING -- 
% 
% Write data in a friendly format
% take 90% of each class as training data
m = 0;
fname = ['svmTestData_' num2str(mTest)];
fid = fopen(fname, 'w');
for j = 1:5
    fprintf('...class %d', j);
    ind = [mTrain mTrain+mTest]+1;
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
fprintf('\n DONE!')

end
