function data = scaleData(data, method)
if nargin < 2
    method = 'linear';
end

featureNames = {...
    'weight'; 'height';
    'x1'; 'y1'; 'z1';
    'x2'; 'y2'; 'z2';
    'x3'; 'y3'; 'z3';
    'x4'; 'y4'; 'z4'};

for j = 1:5
    for iFeature = 1:size(featureNames,1)
        y = data{j}.(featureNames{iFeature});
        
        switch method
            case 'linear'
                data{j}.(featureNames{iFeature}) = (y - min(y))/...
                    (max(y) - min(y));
            case 'standard'
                % std our data
                data{j}.(featureNames{iFeature}) = (y - mean(y))/std(y);
            otherwise
                disp('method not supported')
        end
        
    end
end

end