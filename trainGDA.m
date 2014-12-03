function model = trainGDA(X,Y)

nClasses = 5;
model = cell(nClasses,1);
% data = cell, each cell is a struct with data
% i = class number
% 
% -- TRAINING -- 
% 
% focusing just on accelerometer data for now..

for i = 1:nClasses
    fprintf('Training model for %s...\n', classname(i));
    indPos = find(Y==i);
    indNeg = find(Y~=i);
    mPos = length(indPos); 
    mNeg = length(indNeg);
    model{i}.phi = mPos/length(Y);
    
    muPos = sum(X(indPos,:))' / mPos; % n by 1
    muNeg = sum(X(indNeg,:))' / mNeg; % n by 1
    % covariance matrix
    cov = 1/mPos * (X(indPos,:) - repmat(muPos', [mPos 1]))' * ...
        (X(indPos,:) - repmat(muPos', [mPos 1])) + ...
        1/mNeg * (X(indNeg,:) - repmat(muNeg', [mNeg 1]))' * ...
        (X(indNeg,:) - repmat(muNeg', [mNeg 1]));
    model{i}.muPos = muPos;
    model{i}.muNeg = muNeg;
    model{i}.cov = cov;
   
end

end
