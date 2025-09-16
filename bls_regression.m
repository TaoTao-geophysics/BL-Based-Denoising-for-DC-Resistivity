clear;clc;
tic
load train_y.mat;load train_x.mat;
load test_x.mat; load test_y.mat;test_y=test_y(:,:);
test_x=test_x;test_y=test_y;

assert(isfloat(train_x), 'train_x must be a float');
assert(isfloat(test_x), 'test_x must be a float');
[m,n]=size(train_y);fprintf(1, 'row of the train_y.= %d, columns of the train_y. =%d\n', m,n);
[m,n]=size(train_x);fprintf(1, 'row of the train_x.= %d, columns of the train_x. =%d\n', m,n);
[m,n]=size(test_y);fprintf(1, 'row of the test_y.= %d, columns of the test_y. =%d\n', m,n);
[m,n]=size(test_x);fprintf(1, 'row of the test_x.= %d, columns of the test_x. =%d\n', m,n);

C = 10^-8;      %----C: the regularization parameter for sparse regualarization
s = .8;              %----s: the shrinkage parameter for enhancement nodes
best = 1;
result = [];result1=[];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for NumFea =100         %searching range for feature nodes  per window in feature layer
    for NumWin=100            %searching range for number of windows in feature layer
        for NumEnhan=100   %searching range for enhancement nodes
%             clc;
            rand('state',1);          
            for i=1:NumWin
                WeightFea=2*rand(size(train_x,2)+1,NumFea)-1;
              
                WF{i}=WeightFea;
            end    
            WeightEnhan=2*rand(NumWin*NumFea+1,NumEnhan)-1;
          
            [NetoutTest, Training_time,Testing_time, train_MAPE,test_MAPE] = bls_train(train_x,train_y,test_x,test_y,WF,WeightEnhan,s,C,NumFea,NumWin);

            
            end
            clearvars -except best NumFea NumWin NumEnhan train_x train_y test_x test_y   C s result NetoutTest xmax
        end
    end
    toc
Y_hat = NetoutTest;
f=200;
time=0:1/f:4-1/f;

fontsize=24;
for i=2
    figure('Position',[100 100 800 800])  
    subplot(2,1,1)
    plot(time,test_x(i,:),'.-k','markersize',10,'linewidth',0.1);ylabel('Voltage (v)');xlabel('Time (s)');
    hold on
    plot(time,test_y(i,:),'-r','markersize',10,'linewidth',2);
    hold on
    plot(time,Y_hat(i,:),'--c','markersize',10,'linewidth',3);ylabel('Voltage (v)');xlabel('Time (s)');
    legend('Noise-added','Noise-free','BL-denoise','Location','NorthEast');
    set(gca,'xtick',0:1:4); set(gca,'xticklabel',get(gca,'xtick'),'fontsize',fontsize);
    axis([0 4 -0.3 0.5]);
    subplot(2,1,2)
    plot(time,(test_x(i,:)-Y_hat(i,:)),'.-b','markersize',10,'linewidth',0.1);
    ylabel('Voltage (v)');xlabel('Time (s)');
    legend('Removed noise','Location','NorthEast');
    set(gca,'xtick',0:1:4); set(gca,'xticklabel',get(gca,'xtick'),'fontsize',fontsize);
    axis([0 4 -0.15 0.15]);
end


