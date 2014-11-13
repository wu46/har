% CS229 | Project | Jennifer Wu |10/19/14

function [out, classRange] = parseData
% Read in data
classRange = zeros(5,2);

fname = 'dataset_modified.csv';
fid = fopen(fname, 'r');
rawdata = textscan(fid, '%s%s%d%d%c%d%f%d%c%d%f%f%f%f%f%f%f%f%f%f%f%f%d',...
    'Delimiter', ';',...
    'Headerlines', 2); 
fclose(fid);
out = cell(5,1);
classid = rawdata{23};

for iClass = [0:4]
    ind = find(classid == iClass);
    classRange(iClass+1,1) = ind(1);
    classRange(iClass+1,2) = ind(end);
    out{iClass+1}.name = rawdata{1}(ind(1):ind(end));
    out{iClass+1}.gender = rawdata{2}(ind(1):ind(end));
    out{iClass+1}.age = rawdata{3}(ind(1):ind(end));
    out{iClass+1}.height = double(rawdata{4}(ind(1):ind(end)))+...
        double(rawdata{6}(ind(1):ind(end)))/100;
    out{iClass+1}.weight = rawdata{7}(ind(1):ind(end));
    out{iClass+1}.bmi = double(rawdata{8}(ind(1):ind(end)))+...
        double(rawdata{10}(ind(1):ind(end)))/10;
    out{iClass+1}.x1 = rawdata{11}(ind(1):ind(end));
    out{iClass+1}.y1 = rawdata{12}(ind(1):ind(end));
    out{iClass+1}.z1 = rawdata{13}(ind(1):ind(end));
    out{iClass+1}.x2 = rawdata{14}(ind(1):ind(end));
    out{iClass+1}.y2 = rawdata{15}(ind(1):ind(end));
    out{iClass+1}.z2 = rawdata{16}(ind(1):ind(end));
    out{iClass+1}.x3 = rawdata{17}(ind(1):ind(end));
    out{iClass+1}.y3 = rawdata{18}(ind(1):ind(end));
    out{iClass+1}.z3 = rawdata{19}(ind(1):ind(end));
    out{iClass+1}.x4 = rawdata{20}(ind(1):ind(end));
    out{iClass+1}.y4 = rawdata{21}(ind(1):ind(end));
    out{iClass+1}.z4 = rawdata{22}(ind(1):ind(end));
    out{iClass+1}.label = rawdata{23}(ind(1):ind(end));
    out{iClass+1}.m = ind(end) - ind(1) + 1;
end
end
