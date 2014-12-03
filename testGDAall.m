function [e, confusionMatrix] = testGDAall(data,model, mtest)
% TESTGDAALL
% TESTGDAALL
if nargin < 3
    mtest = 1000;
end
nClasses = size(data,1);
testMatrix = [];
labels = [];
confusionMatrix = zeros(nClasses);
e = 0;

% get test matrix
for i = 1:nClasses
    iStart = data{i}.m - mtest/nClasses + 1; % take 10% of neg data
    iEnd = data{i}.m;
    testMatrix = [testMatrix;
        data{i}.x1(iStart:iEnd,:) ...
        data{i}.y1(iStart:iEnd,:) ...
        data{i}.z1(iStart:iEnd,:) ...
        data{i}.x2(iStart:iEnd,:) ...
        data{i}.y2(iStart:iEnd,:) ...
        data{i}.z2(iStart:iEnd,:) ...
        data{i}.x3(iStart:iEnd,:) ...
        data{i}.y3(iStart:iEnd,:) ...
        data{i}.z3(iStart:iEnd,:) ...
        data{i}.x4(iStart:iEnd,:) ...
        data{i}.y4(iStart:iEnd,:) ...
        data{i}.z4(iStart:iEnd,:) ...
        ];
    labels = [labels; i*ones((iEnd-iStart+1),1)];
end
n = size(testMatrix,2); % number of features
% for each example, check posterior for all classes
p = zeros(nClasses,1);
predictedLabels = zeros(size(labels));
for i = 1:size(testMatrix,1)
    x = testMatrix(i,:);
    for j = 1:nClasses
       p(j) = 1/((2*pi)^(n/2)*det(model{j}.cov)^0.5) * ...
           exp(-0.5*(x - model{j}.muPos') * inv(model{j}.cov) * (x - model{j}.muPos')');
    end
    [~, iclass] = max(p);
    predictedLabels(i) = iclass;
    
    % compute confusion matrix
    confusionMatrix(labels(i), iclass) = confusionMatrix(labels(i),iclass) + 1;
end
disp('hold')

% calculate precision and accuracy
% precision: true positives / predicted positives
% accuracy: true positives / all positives
for j = 1:nClasses
    precision(j) = confusionMatrix(j,j) / sum(confusionMatrix(j,:));
    accuracy(j) = confusionMatrix(j,j) / sum(confusionMatrix(:,j));
end
disp('Precision')
disp(precision)
disp('Accuracy')
disp(accuracy)

end
