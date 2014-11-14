%% Huafei Wang k-means Implementation
clear all; close all; clc;

%% Prepare the Data
[data,classRange] = parseData;
%       0 - sitting
%       1 - sittingdown
%       2 - standing
%       3 - standingup
%       4 - walking

% Obtain Index for Different Categories
sitting_example_index = find(data.class == 0);
sittingdown_example_index = find(data.class == 1);
standing_example_index = find(data.class == 2);
standingup_example_index = find(data.class == 3);
walking_example_index = find(data.class == 4);

% Example Size of Different Categories
sitting_example_size = size(sitting_example_index, 1);
sittingdown_example_size = size(sittingdown_example_index, 1);
standing_example_size = size(standing_example_index, 1);
standingup_example_size = size(standingup_example_index, 1);
walking_example_size = size(walking_example_index, 1);

% Assert that the Training Size is Appropriate
example_size_matrix = [sitting_example_size; sittingdown_example_size; ...
    standing_example_size; standingup_example_size; walking_example_size];
training_size = 5000; % <<<============== Training Size (Each Category)
assert(training_size < min(example_size_matrix), 'Inappropriate Training Size.');

% Training Index
sitting_training_index = sitting_example_index([1 : training_size]);
sittingdown_training_index = sittingdown_example_index([1 : training_size]);
standing_training_index = standing_example_index([1 : training_size]);
standingup_training_index = standingup_example_index([1 : training_size]);
walking_training_index = walking_example_index([1 : training_size]);

% Testing Index
sitting_testing_index = sitting_example_index([training_size + 1 : sitting_example_size]);
sittingdown_testing_index = sittingdown_example_index([training_size + 1 : sittingdown_example_size]);
standing_testing_index = standing_example_index([training_size + 1 : standing_example_size]);
standingup_testing_index = standingup_example_index([training_size + 1 : standingup_example_size]);
walking_testing_index = walking_example_index([training_size + 1 : walking_example_size]);

% Set up the Training Matrix (12 * (training_size * 5))
Training_Matrix = zeros(12, training_size * 5);
Training_Matrix = [data.x1(sitting_training_index)', data.x1(sittingdown_training_index)', ...
    data.x1(standing_training_index)', data.x1(standingup_training_index)', data.x1(walking_training_index)';
    data.y1(sitting_training_index)', data.y1(sittingdown_training_index)', ...
    data.y1(standing_training_index)', data.y1(standingup_training_index)', data.y1(walking_training_index)';
    data.z1(sitting_training_index)', data.z1(sittingdown_training_index)', ...
    data.z1(standing_training_index)', data.z1(standingup_training_index)', data.z1(walking_training_index)';
    data.x2(sitting_training_index)', data.x2(sittingdown_training_index)', ...
    data.x2(standing_training_index)', data.x2(standingup_training_index)', data.x2(walking_training_index)';
    data.y2(sitting_training_index)', data.y2(sittingdown_training_index)', ...
    data.y2(standing_training_index)', data.y2(standingup_training_index)', data.y2(walking_training_index)';
    data.z2(sitting_training_index)', data.z2(sittingdown_training_index)', ...
    data.z2(standing_training_index)', data.z2(standingup_training_index)', data.z2(walking_training_index)';
    data.x3(sitting_training_index)', data.x3(sittingdown_training_index)', ...
    data.x3(standing_training_index)', data.x3(standingup_training_index)', data.x3(walking_training_index)';
    data.y3(sitting_training_index)', data.y3(sittingdown_training_index)', ...
    data.y3(standing_training_index)', data.y3(standingup_training_index)', data.y3(walking_training_index)';
    data.z3(sitting_training_index)', data.z3(sittingdown_training_index)', ...
    data.z3(standing_training_index)', data.z3(standingup_training_index)', data.z3(walking_training_index)';
    data.x4(sitting_training_index)', data.x4(sittingdown_training_index)', ...
    data.x4(standing_training_index)', data.x4(standingup_training_index)', data.x4(walking_training_index)';
    data.y4(sitting_training_index)', data.y4(sittingdown_training_index)', ...
    data.y4(standing_training_index)', data.y4(standingup_training_index)', data.y4(walking_training_index)';
    data.z4(sitting_training_index)', data.z4(sittingdown_training_index)', ...
    data.z4(standing_training_index)', data.z4(standingup_training_index)', data.z4(walking_training_index)'];
 
%%============Training Process===============
% k-means 5 u's
kmax = 30; % Maximum iterations for u's
% Initialize k-means
u = zeros(12, 5); % (12 * 5)
for i = 1 : 5
    u(:, i) = Training_Matrix(:, ((i - 1) * 5000 + 1));
end

% Label_Matrix Contains the Label Inforation for Each Data Point
Label_Matrix = zeros(training_size * 5, 1);

for k = 1 : kmax
    for i = 1 : training_size * 5
        % Distance_Matrix Contains the Distance of a Point to Each u
        Distance_Matrix = zeros(5, 1);
        for j = 1 : 5
            Distance_Matrix(j) = norm(Training_Matrix(:, i) - u(:, j));
        end
        [~, Label_Matrix(i, 1)] = min(Distance_Matrix); % Update Label of Each Data Point
    end

    % Update u
    for i = 1 : 5
        % same_label_index Contains Index for Data Points of the Same Label
        same_label_index = find(Label_Matrix(:, 1) == i);
        % same_label)data_matrix Contains Data Points of the Same Label
        same_label_data_matrix = Training_Matrix(:, same_label_index);
        % Average the Data Points of the Same Label and Update the u
        u(:, i) = mean(same_label_data_matrix, 2);
    end
end

%% ================Validating Clustering====================
% Classify All Training Examples
Validation_Results = zeros(training_size * 5, 1);
cat_name_matrix = ['sitting', 'sittingdown', 'standing', 'standingup', 'walking'];
for i = 1 : training_size * 5
    % Distance_Validation_Matrix Contains the Distances of a Data Point to
    % all u's (5 * 1)
    Distance_Validation_Matrix = zeros(5, 1);
    for j = 1 : 5
        Distance_Validation_Matrix(j) = norm(Training_Matrix(:, i) - u(:, j));
        [~, Validation_Results(i)] = min(Distance_Validation_Matrix);
    end
end
% Validate the Clustering
Validation_Matrix = zeros(5, 5);
for i = 1 : 5
    cat1 = 0; cat2 = 0; cat3 = 0; cat4 = 0; cat5 = 0; % Reset Counters
    for j = ((i - 1) * training_size + 1) : (i * training_size)
        if (Validation_Results(j) == 1)
            cat1 = cat1 + 1;
        elseif(Validation_Results(j) == 2)
            cat2 = cat2 + 1;
        elseif(Validation_Results(j) == 3)
            cat3 = cat3 + 1;
        elseif(Validation_Results(j) == 4)
            cat4 = cat4 + 1;
        elseif(Validation_Results(j) == 5)
            cat5 = cat5 + 1;
        end
    end
    cat_matrix = [cat1, cat2, cat3, cat4, cat5];
    Validation_Matrix(:, i) = cat_matrix';
    
    fprintf('\n');
    fprintf('Class %d Validation Results: \n', i);
    for k = 1 : 5
        fprintf('Category %d Percentage: %f \n', k, cat_matrix(k) / training_size);
    end
    [~, max_index] = max(cat_matrix);
    if (max_index == i)
        fprintf('Cluster %d Validation Successful! \n', i);
    else
        fprintf('Cluster %d Validation Failed! \n', i);
    end
end

% Calculate the Accuracy <- There shoul be a formal name for this
for i = 1 : 5
    temp_sum = sum(Validation_Matrix, 2);
    fprintf('Class %d Prediction Accuracy is %f \n', i, ...
        Validation_Matrix(i, i) / temp_sum(i));
end


%% ======================Testing========================
% testing_size = 1000;
% 
% sitting_testing_index = sitting_testing_index([1 : testing_size]);
% sittingdown_testing_index = sittingdown_testing_index([1 : testing_size]);
% standing_testing_index = standing_testing_index([1 : testing_size]);
% standingup_testing_index = standingup_testing_index([1 : testing_size]);
% walking_testing_index = walking_testing_index([1 : testing_size]);
% 
% % Construct the Testing Matrix
% Testing_Matrix = zeros(12, testing_size * 5);
% Testing_Matrix = [data.x1(sitting_testing_index)', data.x1(sittingdown_testing_index)', ...
%     data.x1(standing_testing_index)', data.x1(standingup_testing_index)', data.x1(walking_testing_index)';
%     data.y1(sitting_testing_index)', data.y1(sittingdown_testing_index)', ...
%     data.y1(standing_testing_index)', data.y1(standingup_testing_index)', data.y1(walking_testing_index)';
%     data.z1(sitting_testing_index)', data.z1(sittingdown_testing_index)', ...
%     data.z1(standing_testing_index)', data.z1(standingup_testing_index)', data.z1(walking_testing_index)';
%     data.x2(sitting_testing_index)', data.x2(sittingdown_testing_index)', ...
%     data.x2(standing_testing_index)', data.x2(standingup_testing_index)', data.x2(walking_testing_index)';
%     data.y2(sitting_testing_index)', data.y2(sittingdown_testing_index)', ...
%     data.y2(standing_testing_index)', data.y2(standingup_testing_index)', data.y2(walking_testing_index)';
%     data.z2(sitting_testing_index)', data.z2(sittingdown_testing_index)', ...
%     data.z2(standing_testing_index)', data.z2(standingup_testing_index)', data.z2(walking_testing_index)';
%     data.x3(sitting_testing_index)', data.x3(sittingdown_testing_index)', ...
%     data.x3(standing_testing_index)', data.x3(standingup_testing_index)', data.x3(walking_testing_index)';
%     data.y3(sitting_testing_index)', data.y3(sittingdown_testing_index)', ...
%     data.y3(standing_testing_index)', data.y3(standingup_testing_index)', data.y3(walking_testing_index)';
%     data.z3(sitting_testing_index)', data.z3(sittingdown_testing_index)', ...
%     data.z3(standing_testing_index)', data.z3(standingup_testing_index)', data.z3(walking_testing_index)';
%     data.x4(sitting_testing_index)', data.x4(sittingdown_testing_index)', ...
%     data.x4(standing_testing_index)', data.x4(standingup_testing_index)', data.x4(walking_testing_index)';
%     data.y4(sitting_testing_index)', data.y4(sittingdown_testing_index)', ...
%     data.y4(standing_testing_index)', data.y4(standingup_testing_index)', data.y4(walking_testing_index)';
%     data.z4(sitting_testing_index)', data.z4(sittingdown_testing_index)', ...
%     data.z4(standing_testing_index)', data.z4(standingup_testing_index)', data.z4(walking_testing_index)'];
% 
% results = zeros(testing_size * 5, 1);
% for i = 1 : testing_size * 5
%     Distance_Test_Matrix = zeros(5, 1);
%     for j = 1 : 5
%         Distance_Test_Matrix(j) = norm(Testing_Matrix(:, i) - u(:, j));
%         [~, results(i)] = min(Distance_Test_Matrix);
%     end
% end
% 
% %% Check the Testing Accuracy
% for i = 1 : 5
%     correct_number = 0;
%     for j = ((i - 1) * testing_size + 1) : (i * testing_size)
%         if (results(j) == i)
%             correct_number = correct_number + 1;
%         end
%     end
%     fprintf('Class %d accuracy is %f \n', i, correct_number / testing_size);
% end


