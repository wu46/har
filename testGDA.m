function e = testGDA(data, model, i)
% testGDA
%   Tests binary classification model

% 
% -- TESTING --
% 
phi = model{i}.phi;
muPos = model{i}.muPos;
muNeg = model{i}.muNeg;
cov = model{i}.cov;
iTestPos = [round(data{i}.m*9/10) data{i}.m]; % take 10% of pos data
testMatrixPos = [...
    data{i}.x1(iTestPos(1):iTestPos(2),:) ... 
    data{i}.y1(iTestPos(1):iTestPos(2),:) ...
    data{i}.z1(iTestPos(1):iTestPos(2),:) ...
    data{i}.x2(iTestPos(1):iTestPos(2),:) ...
    data{i}.y2(iTestPos(1):iTestPos(2),:) ...
    data{i}.z2(iTestPos(1):iTestPos(2),:) ...
    data{i}.x3(iTestPos(1):iTestPos(2),:) ... 
    data{i}.y3(iTestPos(1):iTestPos(2),:) ...
    data{i}.z3(iTestPos(1):iTestPos(2),:) ...
    data{i}.x4(iTestPos(1):iTestPos(2),:) ...
    data{i}.y4(iTestPos(1):iTestPos(2),:) ...
    data{i}.z4(iTestPos(1):iTestPos(2),:) ...
    ]; % m by n

j = i + 1; if j > 5; j = mod(j,5); end
iTestNeg = [round(data{j}.m*9/10) data{j}.m]; % take 10% of neg data

testMatrixNeg = [...
    data{j}.x1(iTestNeg(1):iTestNeg(2),:) ... 
    data{j}.y1(iTestNeg(1):iTestNeg(2),:) ...
    data{j}.z1(iTestNeg(1):iTestNeg(2),:) ...
    data{j}.x2(iTestNeg(1):iTestNeg(2),:) ...
    data{j}.y2(iTestNeg(1):iTestNeg(2),:) ...
    data{j}.z2(iTestNeg(1):iTestNeg(2),:) ...
    data{j}.x3(iTestNeg(1):iTestNeg(2),:) ... 
    data{j}.y3(iTestNeg(1):iTestNeg(2),:) ...
    data{j}.z3(iTestNeg(1):iTestNeg(2),:) ...
    data{j}.x4(iTestNeg(1):iTestNeg(2),:) ...
    data{j}.y4(iTestNeg(1):iTestNeg(2),:) ...
    data{j}.z4(iTestNeg(1):iTestNeg(2),:) ...
    ]; % m by n

n = size(testMatrixPos,2);
% test results on positive samples
testResPos = zeros(size(testMatrixPos,1),1); 
% test results on negative samples
testResNeg = zeros(size(testMatrixNeg,1),1);

for i = 1:size(testMatrixPos,1)
    % calculate posteriors for postive and negative
    x = testMatrixPos(i,:);
    pPos = 1/((2*pi)^(n/2)*det(cov)^0.5) * ...
        exp(-0.5*(x - muPos') * inv(cov) * (x - muPos')');
    pNeg = 1/((2*pi)^(n/2)*det(cov)^0.5) * ...
        exp(-0.5*(x - muNeg') * inv(cov) * (x - muNeg')');
    if pPos > pNeg
        testResPos(i) = 1; % set to 1 if result is correct
    end
end


for i = 1:size(testMatrixNeg,1)
    % calculate posteriors for postive and negative
    x = testMatrixNeg(i,:);
    pPos = 1/((2*pi)^(n/2)*det(cov)^0.5) * ...
        exp(-0.5*(x - muPos') * inv(cov) * (x - muPos')');
    pNeg = 1/((2*pi)^(n/2)*det(cov)^0.5) * ...
        exp(-0.5*(x - muNeg') * inv(cov) * (x - muNeg')');
    if pPos < pNeg
        testResNeg(i) = 1; % set to 1 if result is correct
    end
end

%
% Output Stats
%

mTestPos = length(testResPos);
mCorrectPos = sum(testResPos);
mTestNeg = length(testResNeg);
mCorrectNeg = sum(testResNeg);
mTest = mTestPos + mTestNeg;
mCorrect = mCorrectPos + mCorrectNeg;
e.ePos = (1-sum(testResPos)/length(testResPos))*100;
e.eNeg = (1-sum(testResNeg)/length(testResNeg))*100;
e.eTot = (1-mCorrect/mTest) * 100;

fprintf('%d/%d correct on positive test data, error %.2f%%\n',...
    sum(testResPos), length(testResPos),...
    e.ePos);

fprintf('%d/%d correct on negative test data, error %.2f%%\n',...
    sum(testResNeg), length(testResNeg),...
    e.eNeg);

fprintf('Combined result:\n');
fprintf('%d/%d correct, error %.2f\n\n', mCorrect, mTest, e.eTot);

end
