function plotLearningCurve(data)
% clear; clc;
nClasses = 5;
mtrain_vec = [100 1000 5000];
mtest = 1000; % test set size


% parse data from svm first



for m = mtrain_vec
    [testError, trainError] = runSVM(data, floor(m/nClasses));
    fprintf('m = %d\n', m)
    fprintf('Test error = %.2f%%, train error = %.2f%%\n\n',...
        testError, trainError);
end
end