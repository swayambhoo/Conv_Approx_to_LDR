close all; clear all;
load('CoilDBrun_Big_Full_Size_exp12_new.mat'); 

output = cell(11);
tA = zeros(size(colSparsity));
tDC = zeros(size(colSparsity));

nMonte = 10;
for iMonte = 1:nMonte
    for i = 1:11
        command = ['./a.out A.txt trainData.txt' ' D_' num2str(i) '.txt' ' C_' num2str(i) '.txt ' ' X_' num2str(i) '.txt ' num2str(colSparsity(i))]; 
        [~, output] = system(command)
        tA(i)  = tA(i)  + str2double(output(25:32))/nMonte;
        tDC(i) = tDC(i) + str2double(output(58:end))/nMonte;
    end
    iMonte
end

%% 
figure;
font_size = 26;
plot( log(trainingError),  colSparsity,  'b--v'  , 'linewidth',   2,  'markersize',  8 ); hold on
plot( log(trainingErrorP), mList(1), 'k-*' , 'linewidth',   2,  'markersize',  8 ); hold on
title('$\textrm{Average Error}$', 'Interpreter' , 'LaTex'  ,'fontsize', 30) 
legend('MC', 'SC');
xlabel('$ \log \left( \frac{1}{p} \sum_{i=1}^p  \|\mathbf{ Ax_i - M^*C^*x_i}\|_2^2 / \| \mathbf{x_i} \|_2^2\right)$', 'Interpreter', ...
    'LaTex', 'FontWeight','bold','FontSize',30,'color','k');
ylabel('$m''$', 'Interpreter', 'LaTex', 'FontSize', 30, 'color', 'k');
hold off;
fig =  gca;
set(fig,'FontSize', font_size)
print('Coil_avg_error','-depsc2');

figure;
font_size = 26;
plot(log(trainingError(2:end)), tDC(2:end)/tA(1),  'b--v', 'linewidth',   2,  'markersize',  8 ); hold on
%plot(tA(1),  mList(1),  'k-*' , 'linewidth',   2,  'markersize',  8 ); hold on
title('$\textrm{Average Time Vs. Average Error}$', 'Interpreter' , 'LaTex'  ,'fontsize', 30); 
xlabel('$ \log \left( \frac{1}{p} \sum_{i=1}^p  \|\mathbf{ Ax_i - M^*C^*x_i}\|_2^2 / \| \mathbf{x_i} \|_2^2\right)$', 'Interpreter', ...
    'LaTex', 'FontWeight','bold','FontSize',30,'color','k');
ylabel('$\frac{\textrm{ Average time by MC }}{ \textrm{Average time by A} } $', 'Interpreter', 'LaTex', 'FontSize', 30, 'color', 'k');
hold off;
fig =  gca;
set(fig,'FontSize', font_size)
print('Coil_avg_time_error','-depsc2');


% font_size = 26;
% plot(tDC, colSparsity,   'b--v', 'linewidth',   2,  'markersize',  8 ); hold on
% plot(tA(1),  mList(1),  'k-*' , 'linewidth',   2,  'markersize',  8 ); hold on
% title('$\textrm{Average Time}$', 'Interpreter' , 'LaTex'  ,'fontsize', 30); 
% legend('MC', 'A');
% xlabel('Time (Sec.)', 'Interpreter', ...
%     'LaTex', 'FontWeight','bold','FontSize',30,'color','k');
% ylabel('$m''$', 'Interpreter', 'LaTex', 'FontSize', 30, 'color', 'k');
% hold off;
% fig =  gca;
% set(fig,'FontSize', font_size)



%% Plotting Histograms
iRho = 5;
errorTrain = zeros(size(trainData,2), length(mList));
errorTest  = zeros(size(testData,2), length(mList));
for iMeasurement = 1:length(mList)
    m = mList(iMeasurement);
    A = components(:, 1:m)';
    for i = 1:size(trainData,2)
        D = D_Cell{iRho, iMeasurement};
        c = C_Cell{iRho, iMeasurement};
        x = trainData(:,i);
        errorTrain(i, iMeasurement) = norm(A*x - D*multCirculant(c,x))^2/norm(x)^2;
    end 
    for i = 1:size(testData,2)
        D = D_Cell{iRho, iMeasurement};
        c = C_Cell{iRho, iMeasurement};
        x = testData(:,i);
        errorTest(i, iMeasurement) = norm(A*x - D*multCirculant(c,x))^2/norm(x)^2;
    end
end

figure;
hist(errorTrain(:,1), 60)
title( '$\textrm{Error Histogram for MC}$', 'Interpreter', 'Latex', 'Fontsize', 30);
xlabel('$  \frac{\|\mathbf{ Ax - M^*C^*x}\|_2^2 } { \| \mathbf{x} \|_2^2}$', 'Interpreter', ...
    'LaTex', 'FontWeight','bold','FontSize',30,'color','k');
ylabel('$\textrm{Count}$', 'Interpreter', 'Latex')
fig = gca;
set(fig,'FontSize', 30);
legend({['$$\| \mathbf{M^*}  \|_{2,0} = $$', num2str(colSparsity(iRho, 1) )] }, 'Interpreter', 'LaTex', 'Fontsize', 30);
axis tight
print('Coil_Hist','-depsc2')

figure;
hist(errorTrainP(errorTrainP <= 1), 60)
title( 'Error histogram for SC','Fontsize', 30);
xlabel('$ \log \left( \|\mathbf{ Ax - M^*C^*x}\|_2^2 / \| \mathbf{x} \|_2^2\right)$', 'Interpreter', ...
    'LaTex', 'FontWeight','bold','FontSize',30,'color','k');
ylabel('Count')
fig = gca;
set(fig,'FontSize', 30);
legend({['$$\| \mathbf{S^*}  \|_{2,0} = $$', num2str(300)] }, 'Interpreter', 'LaTex', 'Fontsize', 30);
%xlim([0,1])
%axis tight
%print('Coil_HistP','-depsc2')



