% CS229 | Project | Jennifer Wu |10/19/14

function data = parseData
% Read in data
startLine = 1;
nRows = 100;
nColumns = 19;

fname = 'dataset-har-PUC-Rio-ugulino.csv';
fid = fopen(fname, 'r');
rawdata = textscan(fid, '%s%s%d%d%c%d%f%d%c%d%f%f%f%f%f%f%f%f%f%f%f%f%s',...
    'Delimiter', ';',...
    'Headerlines', 1); 
fclose(fid);
data.name = rawdata{1};
data.gender = rawdata{2};
data.age = rawdata{3};
data.height = rawdata{4}+rawdata{6}/100;
data.weight = rawdata{7};
data.bmi = rawdata{8}+rawdata{10}/10;
data.x1 = rawdata{11};
data.y1 = rawdata{12};
data.z1 = rawdata{13};
data.x2 = rawdata{14};
data.y2 = rawdata{15};
data.z2 = rawdata{16};
data.x3 = rawdata{17};
data.y3 = rawdata{18};
data.z3 = rawdata{19};
data.x4 = rawdata{20};
data.y4 = rawdata{21};
data.z4 = rawdata{22};
data.class = rawdata{23};
end