function [testError, trainError, cm] = runGDA(data, mTrain, mTest)
nClasses = size(data,1);


%%%%%
% TODO: expand this to runSVM as well
%%%%%
% test matrix gen
X =[];
Y =[];

for i = 1:nClasses
    iStart = 1;
    iEnd = mTrain/nClasses;
    X = [X;
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
    Y = [Y; i*ones((iEnd-iStart+1),1)];
end

model = trainGDA(X,Y);

[prec, acc, cm] = testGDA(data, model, mTest);


% disp to see outputs
disp(prec)
disp(acc)
disp(cm)

testError = 0;
trainError = 0;

    function model = trainGDA(X,Y)
        model = cell(nClasses,1);
        % data = cell, each cell is a struct with data
        % i = class number
        %
        % -- TRAINING --
        %
        % focusing just on accelerometer data for now..
        
        for j = 1:nClasses
            fprintf('Training model for %s...\n', classname(j));
            indPos = find(Y==j);
            indNeg = find(Y~=j);
            mPos = length(indPos);
            mNeg = length(indNeg);
            model{j}.phi = mPos/length(Y);
            
            muPos = sum(X(indPos,:))' / mPos; % n by 1
            muNeg = sum(X(indNeg,:))' / mNeg; % n by 1
            % covariance matrix
            cov = 1/mPos * (X(indPos,:) - repmat(muPos', [mPos 1]))' * ...
                (X(indPos,:) - repmat(muPos', [mPos 1])) + ...
                1/mNeg * (X(indNeg,:) - repmat(muNeg', [mNeg 1]))' * ...
                (X(indNeg,:) - repmat(muNeg', [mNeg 1]));
            model{j}.muPos = muPos;
            model{j}.muNeg = muNeg;
            model{j}.cov = cov;
        end
    end
    function [precision, accuracy, confusionMatrix] = testGDA(data,model,mTest)
        if nargin < 3
            mTest = 1000;
        end
        nClasses = size(data,1);
        testMatrix = [];
        labels = [];
        confusionMatrix = zeros(nClasses);
        precision = zeros(nClasses,1);
        accuracy = zeros(nClasses,1);
        
        % get test matrix
        for j = 1:nClasses
            p = data{j}.m - mTest/nClasses + 1; % take 10% of neg data
            q = data{j}.m;
            testMatrix = [testMatrix;
                data{j}.x1(p:q,:) ...
                data{j}.y1(p:q,:) ...
                data{j}.z1(p:q,:) ...
                data{j}.x2(p:q,:) ...
                data{j}.y2(p:q,:) ...
                data{j}.z2(p:q,:) ...
                data{j}.x3(p:q,:) ...
                data{j}.y3(p:q,:) ...
                data{j}.z3(p:q,:) ...
                data{j}.x4(p:q,:) ...
                data{j}.y4(p:q,:) ...
                data{j}.z4(p:q,:) ...
                ];
            labels = [labels; j*ones((q-p+1),1)];
        end
        n = size(testMatrix,2); % number of features
        % for each example, check posterior for all classes
        p = zeros(nClasses,1);
        predictedLabels = zeros(size(labels));
        for k = 1:size(testMatrix,1)
            x = testMatrix(k,:);
            for j = 1:nClasses
                p(j) = 1/((2*pi)^(n/2)*det(model{j}.cov)^0.5) * ...
                    exp(-0.5*(x - model{j}.muPos') * inv(model{j}.cov) * (x - model{j}.muPos')');
            end
            [~, iclass] = max(p);
            predictedLabels(k) = iclass;
            
            % compute confusion matrix
            confusionMatrix(labels(k), iclass) = confusionMatrix(labels(k),iclass) + 1;
        end
        disp('hold')
        
        % calculate precision and accuracy
        % precision: true positives / predicted positives
        % accuracy: true positives / all positives
        for j = 1:nClasses
            precision(j) = confusionMatrix(j,j) / sum(confusionMatrix(j,:));
            accuracy(j) = confusionMatrix(j,j) / sum(confusionMatrix(:,j));
        end
    end
end
