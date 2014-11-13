%% Huafei Wang k-means Implementation
clear all; close all; clc;

%%
[data,classRange] = parseData;

%% Evaluating sitting-down or not

%       0 - sitting
%       1 - sittingdown
%       2 - standing
%       3 - standingup
%       4 - walking

%% 
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

example_size_matrix = [sitting_example_size; sittingdown_example_size; ...
    standing_example_size; standingup_example_size; walking_example_size];

training_size = 5000;
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

%% Construct the Training Matrix
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
 
%% k-means 5 u's
% Initialize k-means
kmax = 30;
u = zeros(12, 5);
for i = 1 : 5
    u(:, i) = Training_Matrix(:, ((i - 1) * 5000 + 1));
end

Label_Matrix = zeros(training_size * 5, 2);
Label_Matrix(:, 1) = [1 : training_size * 5];

for k = 1 : kmax
    for i = 1 : training_size * 5
        Distance_Matrix = zeros(5, 1);
        for j = 1 : 5
            Distance_Matrix(j) = norm(Training_Matrix(:, i) - u(:, j));
        end
        [~, Label_Matrix(i, 2)] = min(Distance_Matrix);
    end

    % Update u
    for i = 1 : 5
        same_label_index = find(Label_Matrix(:, 2) == i);
        same_label_data_matrix = Training_Matrix(:, same_label_index);
        u(:, i) = mean(same_label_data_matrix, 2);
    end
end

%% Testing
testing_size = 1000;

sitting_testing_index = sitting_testing_index([1 : testing_size]);
sittingdown_testing_index = sittingdown_testing_index([1 : testing_size]);
standing_testing_index = standing_testing_index([1 : testing_size]);
standingup_testing_index = standingup_testing_index([1 : testing_size]);
walking_testing_index = walking_testing_index([1 : testing_size]);

% Construct the Testing Matrix
Testing_Matrix = zeros(12, testing_size * 5);
Testing_Matrix = [data.x1(sitting_testing_index)', data.x1(sittingdown_testing_index)', ...
    data.x1(standing_testing_index)', data.x1(standingup_testing_index)', data.x1(walking_testing_index)';
    data.y1(sitting_testing_index)', data.y1(sittingdown_testing_index)', ...
    data.y1(standing_testing_index)', data.y1(standingup_testing_index)', data.y1(walking_testing_index)';
    data.z1(sitting_testing_index)', data.z1(sittingdown_testing_index)', ...
    data.z1(standing_testing_index)', data.z1(standingup_testing_index)', data.z1(walking_testing_index)';
    data.x2(sitting_testing_index)', data.x2(sittingdown_testing_index)', ...
    data.x2(standing_testing_index)', data.x2(standingup_testing_index)', data.x2(walking_testing_index)';
    data.y2(sitting_testing_index)', data.y2(sittingdown_testing_index)', ...
    data.y2(standing_testing_index)', data.y2(standingup_testing_index)', data.y2(walking_testing_index)';
    data.z2(sitting_testing_index)', data.z2(sittingdown_testing_index)', ...
    data.z2(standing_testing_index)', data.z2(standingup_testing_index)', data.z2(walking_testing_index)';
    data.x3(sitting_testing_index)', data.x3(sittingdown_testing_index)', ...
    data.x3(standing_testing_index)', data.x3(standingup_testing_index)', data.x3(walking_testing_index)';
    data.y3(sitting_testing_index)', data.y3(sittingdown_testing_index)', ...
    data.y3(standing_testing_index)', data.y3(standingup_testing_index)', data.y3(walking_testing_index)';
    data.z3(sitting_testing_index)', data.z3(sittingdown_testing_index)', ...
    data.z3(standing_testing_index)', data.z3(standingup_testing_index)', data.z3(walking_testing_index)';
    data.x4(sitting_testing_index)', data.x4(sittingdown_testing_index)', ...
    data.x4(standing_testing_index)', data.x4(standingup_testing_index)', data.x4(walking_testing_index)';
    data.y4(sitting_testing_index)', data.y4(sittingdown_testing_index)', ...
    data.y4(standing_testing_index)', data.y4(standingup_testing_index)', data.y4(walking_testing_index)';
    data.z4(sitting_testing_index)', data.z4(sittingdown_testing_index)', ...
    data.z4(standing_testing_index)', data.z4(standingup_testing_index)', data.z4(walking_testing_index)'];

results = zeros(testing_size * 5, 1);
for i = 1 : testing_size * 5
    Distance_Test_Matrix = zeros(5, 1);
    for j = 1 : 5
        Distance_Test_Matrix(j) = norm(Testing_Matrix(:, i) - u(:, j));
        [~, results(i)] = min(Distance_Test_Matrix);
    end
end

%% Check the Accuracy
for i = 1 : 5
    correct_number = 0;
    for j = ((i - 1) * testing_size + 1) : (i * testing_size)
        if (results(j) == i)
            correct_number = correct_number + 1;
        end
    end
    fprintf('Class %d accuracy is %f \n', i, correct_number / testing_size);
end