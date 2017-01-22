close all; clear all; clc;
load('CoilDBrun_Big_Full_Size_exp12_new.mat'); 

fileID = fopen('A.txt','w');
for i = 1:size(A,1) 
    for j = 1:size(A,2)
        fprintf(fileID, '%f ' , A(i,j));
    end
    fprintf(fileID, '\n');
end
fclose(fileID);

fileID = fopen('trainData.txt','w');

for i = 1:size(trainData,1) 
    for j = 1:size(trainData,2)
        fprintf(fileID, '%f ' , trainData(i,j));
    end
    fprintf(fileID, '\n');
end
fclose(fileID);

for k = 1:size(D_Cell, 1)   
     fName =  ['D_' num2str(k) '.txt'  ];
     fileID = fopen(fName,'w');
     D = D_Cell{k};
     D = D(:, ones(1,m)*D.^2 ~= 0);
     for i = 1:size(D,1) 
        for j = 1:size(D,2)
            fprintf(fileID, '%f ' , D(i,j));
        end
        fprintf(fileID, '\n');
     end
     fclose(fileID);
end

for k = 1:size(D_Cell, 1)   
     fName =  ['X_' num2str(k) '.txt'  ];
     fileID = fopen(fName,'w');
     D = D_Cell{k};
     X = trainData(ones(1,m)*D.^2 ~= 0,:);
     for i = 1:size(X,1) 
        for j = 1:size(X,2)
            fprintf(fileID, '%f ' , X(i,j));
        end
        fprintf(fileID, '\n');
     end
     fclose(fileID);
end

dum = 1:n;
for k = 1:size(D_Cell, 1)   
     fName =  ['Xsup_' num2str(k) '.txt'  ];
     fileID = fopen(fName,'w');
     D = D_Cell{k};
     x = dum(ones(1,m)*D.^2 ~= 0);
     for i = 1:length(x) 
            fprintf(fileID, '%d ' , x(i));
     end
     fclose(fileID);
end


for k = 1:size(C_Cell, 1)   
     fName =  ['C_' num2str(k) '.txt'  ];
     fileID = fopen(fName,'w');
     C = C_Cell{k};
     for i = 1:size(C,1) 
        for j = 1:size(C,2)
            fprintf(fileID, '%f ' , C(i,j));
        end
        fprintf(fileID, '\n');
     end
     fclose(fileID);
end


%% Creating dummy data for testing 

A = randn(5,10);
fileID = fopen('A_dum.txt','w');
for i = 1:size(A,1) 
    for j = 1:size(A,2)
        fprintf(fileID, '%f ' , A(i,j));
    end
    fprintf(fileID, '\n');
end
fclose(fileID);


trainData = randn(10,5);
fileID = fopen('trainData_dum.txt','w');
for i = 1:size(trainData,1) 
    for j = 1:size(trainData,2)
        fprintf(fileID, '%f ' , trainData(i,j));
    end
    fprintf(fileID, '\n');
end
fclose(fileID);
    





