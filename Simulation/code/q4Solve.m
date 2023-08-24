%% q4 求解
clear
    ratio = 0.1;
sdPos = [
        4,0;
        3,1;
        3,-1;
        2,2;
        2,0;
        2,-2;
        1,3;
        1,1;
        1,-1;
        1,-3;
        0,4;
        0,2;
        0,0;
        0,-2;
        0,-4];
    
rdPos = sdPos + rand(size(sdPos))*ratio*2-ratio;  %[-0.05,0.05];

% 间距
sigma = 50;

new_sigma = 45;  % 固定间距

plane_num = 14;
% new_sigma = 45;  % 新间距

lmd = [1,1];
arr = [2,6,7];

%% 实际计算
rng(1);

onex = sqrt(3)/2;
oney = 1/2;
std_cords = [onex, oney];

% std and new
cords = sigma * std_cords;
new_cords = new_sigma * std_cords;

sdIdealpos = sdPos.*cords;
pos = rdPos.*cords;


dises = zeros(plane_num,1);
positions = zeros(plane_num, 2);
%plane number

need_plans_plane = [1,2,3,4,5,6,7,8,9,10,11,12,14,15];

% arrs = combntns(need_plans_plane,3);
load('arrsQ4.mat');
total_arr_num = size(arrs,1);

%% 迭代次数
maxIter = 50;

% 变量preset
res_planeses = zeros(maxIter, length(arr));
res_errores = zeros(maxIter,1);
res_positiones = cell(maxIter,1);
res_detail_errorses = zeros(maxIter,plane_num);

for iter = 1:maxIter
    iter
total_dises = zeros(total_arr_num,plane_num);
positionses = cell(total_arr_num,1);

for arrt=1:total_arr_num
    arr = arrs(arrt,:);


for i = 1:plane_num
    % 共14架
    pn = need_plans_plane(i);
    
% pn = 8;



O = [0,0];
%标准机位置
% 4
sdA = sdIdealpos(arr(1),:);
% 7
sdB = sdIdealpos(arr(2),:);
% 6
sdC = sdIdealpos(arr(3),:);

% 偏移后
A = pos(arr(1),:);
B = pos(arr(2),:);
C = pos(arr(3),:);


M = pos(pn,:);

%% 求解直线参数
% A,B
[la_params(1),la_params(2)] = solveAB(M,A);
[lb_params(1),lb_params(2)] = solveAB(M,B);
[lc_params(1),lc_params(2)] = solveAB(M,C);

% C
la_C = -la_params(1)*sdA(1) - la_params(2)*sdA(2);
lb_C = -lb_params(1)*sdB(1) - lb_params(2)*sdB(2);
lc_C = -lc_params(1)*sdC(1) - lc_params(2)*sdC(2);


[xab,yab] = solveLineInsect([la_params,la_C], [lb_params,lb_C]);
[xbc,ybc] = solveLineInsect([lb_params,lb_C], [lc_params,lc_C]);
[xac,yac] = solveLineInsect([la_params,la_C], [lc_params,lc_C]);

% 用边界做初始值
x0 = [xac,yac];

params = [la_params;lb_params;lc_params];  %3*2
Ces = [la_C,lb_C,lc_C];

noteqcons = x0*params' + Ces ;    %1*3 <=0

% 标准点集合
sdPoints = [sdA;sdB;sdC];
% 标准alpha
alphaA = calAlpha(A,M,O);
alphaB = calAlpha(B,M,O);
alphaC = calAlpha(C,M,O);
alphas = [alphaA,alphaB,alphaC];

X_tmp = [xab,yab;xbc,ybc;xac,yac];
X_tmp = [X_tmp;mean(X_tmp(:,1)),mean(X_tmp(:,2))];
tmp_err = zeros(4,1);
for j=1:4
    tmp_err(i) = cosError(X_tmp(j,:),sdPoints,alphas);
end
[~,ind] = sort(tmp_err,'ascend');
first_ind = ind(1);
res = X_tmp(first_ind,:);
fval = tmp_err(first_ind);
% inital_error = cosError(x0,sdPoints,alphas);
% 
% fun = @(X)cosError(X,sdPoints,alphas);
% conFun = @(X)unlinearC(X,params,Ces);
% 
% options = optimset('Algorithm','sqp');
% [res,fval] = fmincon(fun,x0,[],[],[],[],[],[],conFun,options);

% % % 画图查看点和区域分布
% plot([xab,xbc,xac,xab],[yab,ybc,yac,yab]);
% hold on;
% scatter(res(1),res(2));

%% res为计算距离，要移动到目标位置
p_FI = sdIdealpos(pn,:);
p_R = M;
p_C = res;
p_T = sdIdealpos(pn,:);

%% 移动向量
p_D = p_FI - p_C;

p_D = lmd .* p_D;  % 控制移动步长


%% 飞机移动
% 若是调度的飞机则不移动
if ismember(pn,arr)
    p_R_after = p_R;
else
    p_R_after = p_R + p_D;
end

% 计算误差
dis = sqrt(sum((p_R_after - p_T).^2));

% 赋值
dises(i) = dis;
positions(i,:) = p_R_after;

end

total_dises(arrt,:) = dises';
positionses{arrt} = positions;

end

sum_dises = sum(total_dises,2);
%% 单次结束后，第j个组合
[~, index] = sort(sum_dises,'ascend');
first_ind = index(1);
% 结果飞机调度，总误差，最后飞机位置，误差细节
res_planes = arrs(first_ind,:);
res_error = sum_dises(first_ind);
res_position = positionses{first_ind};
res_detail_errors = total_dises(first_ind,:);

res_planeses(iter,:) = res_planes;
res_errores(iter) = res_error;
res_positiones{iter} = res_position;
res_detail_errorses(iter,:) = res_detail_errors;

% pos = res_position;
% 添加原点
pos(1:12,:) = res_position(1:12,:);
pos(14:15,:) = res_position(13:14,:);
pos(13,:) = [0,0];

plotPositionsConinal(pos);
end

figure();
plot(res_errores);



function [c,ceq] = unlinearC(X,params,Ces)
    % X(x0,y0)
    ctmp = X*params' + Ces ;  % 1*3 <=0
    c = prod(ctmp);   %1*1 <=0
    ceq = [];
end


