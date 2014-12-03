function [model, resid, confusionMatrix] = trainSoftmax(data, maxIt)
nClasses = 5;
n = 12; % # of features = 13 (incl. a constant term)
m = 0;
X = [];
Y = [];
it = 0;
resid = [];
portion = 90/100;
range = zeros(nClasses,2); % keep track of which samples has what value
for i = 1:nClasses
    iStart = 1;
    iEnd = round(data{i}.m*portion);
    % iEnd = 1000;
    deltam = iEnd-iStart+1;
    X = [X;
        ones(deltam,1) ...
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
    m = m + deltam; % total # of training examples
    range(i,:) = [length(Y)-deltam+1 length(Y)];
end
% initialize
theta = zeros(n+1,nClasses);
alpha = 0.005;

while it < maxIt
    grad = zeros(n+1,nClasses);
    for j = 1:nClasses
        
        for i = 1:m
            %             if (Y(i) == j)
            %                 disp('positive')
            %             else
            %                 disp('neg')
            %             end
            x = X(i,:)';
            %             d = ((Y(i) == j)-exp(theta(:,j)'*x)/sum(exp(theta'*x)))
            grad(:,j) = grad(:,j) + x*((Y(i) == j)-exp(theta(:,j)'*x)/sum(exp(theta'*x)));
            %             grad(:,j) = grad(:,j) + x*((Y(i) == j)-exp(theta(:,j)'*x)/sum(exp(theta'*x)));
        end
    end
    % update theta
    theta = theta + alpha*1/m*grad;
    resid = [resid; sum(sum(grad.^2))];
    %     disp(sum(sum(grad.^2)))
    %     disp(theta)
    it = it + 1;
    fprintf('iteration %d\n', it);
end
model = theta;

% TESTING
% TODO: Move this to a separate function later
confusionMatrix = zeros(nClasses);
res = zeros(m,1);
for i = 1:m
    x = X(i,:)';
    h = exp(theta'*x)/sum(exp(theta'*x));
    [~, iclass] = max(h);
    confusionMatrix(Y(i), iclass) =  confusionMatrix(Y(i), iclass) + 1;
end
disp(confusionMatrix)
figure;
plot(resid)
grid on

    function loglikelihood(X, Y, theta, m)
        ll = 0;
        for ii = 1:m
            %             x = X(ii,:)';
            jj = Y(ii);
            %             ll = ll + log(exp(theta(:,jj)'*x)) - log()
        end
    end
end