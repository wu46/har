function [testError, trainError, cm] = runGDA(data, mTrain, mTest)
nClasses = size(data,1);

iStart = 1;
iEnd = iStart + mTrain/nClasses - 1;
[X,Y] = slice(data,iStart,iEnd);
model = trainGDA(X,Y);

% test on training matrix
fprintf('Testing on training set...\n')
[prec, acc, cm, trainError] = testGDA(X,Y, model);
disp(cm)

% construct test set
iStart = mTrain/nClasses + 1 + 5000;
iEnd = iStart + mTest/nClasses - 1;
[X,Y] = slice(data,iStart,iEnd);

fprintf('Testing on test set...\n')
[prec, acc, cm, testError] = testGDA(X,Y, model);
disp(cm)


    function [X,Y] = slice(data, iStart, iEnd)
        % extract training set or testing set
        X =[];
        Y =[];
        for i = 1:nClasses
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
    end

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

    function [precision, accuracy, confusionMatrix, e] = testGDA(X,Y, model)
        m = size(X,1);
        confusionMatrix = zeros(nClasses);
        precision = zeros(nClasses,1);
        accuracy = zeros(nClasses,1);
        
        n = size(X,2); % number of features
        % for each example, check posterior for all classes
        p = zeros(nClasses,1);
        predictedLabels = zeros(size(Y));
        for k = 1:m
            x = X(k,:);
            for j = 1:nClasses
                p(j) = 1/((2*pi)^(n/2)*det(model{j}.cov)^0.5) * ...
                    exp(-0.5*(x - model{j}.muPos') * inv(model{j}.cov) * (x - model{j}.muPos')');
            end
            [~, iclass] = max(p);
            predictedLabels(k) = iclass;
            
            % compute confusion matrix
            confusionMatrix(Y(k), iclass) = confusionMatrix(Y(k),iclass) + 1;
        end
        
        % calculate precision and accuracy
        % precision: true positives / predicted positives
        % accuracy: true positives / all positives
        for j = 1:nClasses
            precision(j) = confusionMatrix(j,j) / sum(confusionMatrix(j,:));
            accuracy(j) = confusionMatrix(j,j) / sum(confusionMatrix(:,j));
        end
        e = trace(confusionMatrix)/m;
    end
end
