%% QuestionⅢ模拟
clear

% 原始位置1-9 共10台机
pos = [100, 0;
98, 40.10;
112, 80.21;
105, 119.75;
98, 159.86;
112, 199.96;
105, 240.07;
98, 280.17;
112, 320.28
];



% rng(1);
% % 误差20%
% 
% stdpos = [100, 0;
% 100, 40;
% 100, 80;
% 100, 120;
% 100, 160;
% 100, 200;
% 100, 240;
% 100, 280;
% 100, 320
% ];   
% 
% pos = stdpos + rand(size(stdpos))*40-20;
% pos(pos(:,2)<0,2) = pos(pos(:,2)<0,2) + 360;


% 选择三台机
arr = [3,6,9];

% 移动系数 lmd1,lmd2 from 0to1
lmd1 = 1;
lmd2 = 1;
lmd = [lmd1, lmd2];


%% 排列
% arrs = combntns([1:9],3);
load('arrs.mat');  % arrs 84*3

%% 总运行次数
total_arr_num = 84;
plane_num = 9;

%% 迭代次数
maxIter = 20;

% 变量preset
res_planeses = zeros(maxIter, length(arr));
res_errores = zeros(maxIter,1);
res_positiones = cell(maxIter,1);
res_detail_errorses = zeros(maxIter,plane_num);

for iter = 1:maxIter
    iter
total_dises = zeros(total_arr_num,plane_num);
positionses = cell(total_arr_num,1);
%% 调用代码开始模拟
for j=1:total_arr_num
% j = 1;
arr = arrs(j,:);

[dises, positions] = simulateArr(arr,lmd, pos);

total_dises(j,:) = dises';
positionses{j} = positions;
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

pos = res_position;

plotPositions(pos);

end

figure();
plot(res_errores);


function [dises, positions] = simulateArr(arr, lmd, pos)


% 理想角 (360/9)
I_Angles = [0,40,80,120,160,200,240,280,320];

% 理想rou
rou = 100;

% 飞机个数
plane_num = 9;

% % 原始位置1-9 共10台机
% pos = [100, 0;
% 98, 40.10;
% 112, 80.21;
% 105, 119.75;
% 98, 159.86;
% 112, 199.96;
% 105, 240.07;
% 98, 280.17;
% 112, 320.28
% ];

dises = zeros(plane_num,1);

positions = zeros(plane_num, 2);

p_T_rou = mean(pos(:,1));

% % 测试固定半径
% p_T_rou = 110;


%
for i=1:plane_num
 
%% 开始运算
% i = 3;
p_R = pos(i,:);   % 当前实际位置（极坐标）

%% 计算当前位置
p_C = zeros(1,2);   % 当前计算位置（极坐标）
p_C(2) = p_R(2);    % theta'' = theta';

theta_R = p_R(2);

% 第几台机，存在精度误差，取中位数
rou_cs = zeros(3,1);

for k=1:length(arr)
indArrPlane = k;
% 求解alphaA和thetaA
thetaA = I_Angles(arr(indArrPlane));

% 测试利用全圆定位通过
% 用实际飞机定位，利用向量积求角（先转为平面直角坐标）
ARealPos = pos(arr(indArrPlane),:); % 极坐标
OPos = [0,0];
AM = polorToXYZ(p_R) - polorToXYZ(ARealPos);
OM = polorToXYZ(p_R) - polorToXYZ(OPos);
sigma = acos(dot(AM,OM)/(norm(AM)*norm(OM)));
alphaA = sigma*180/pi;

% 求解rou'
rou_c_coe = sind(kOperate(thetaA - theta_R) + alphaA)/sind(alphaA);
rou_c = rou*rou_c_coe;

rou_cs(k) = rou_c;
end
rou_c = median(rou_cs);

p_C(1) = rou_c;

%% step2 计算 当前位置与假性理想位置差 （直角坐标）
p_FK = [rou, I_Angles(i)];

% 位置差（直角坐标）
p_D = polorToXYZ(p_FK) - polorToXYZ(p_C);

% 乘上移动系数
p_D = lmd.*p_D;

%% step3 换算到当前位置下p_R（即进行移动）
p_R_XYZ = polorToXYZ(p_R);

% 若是调度的飞机则不移动
if ismember(i,arr)
    p_R_XYZ = polorToXYZ(p_R);
else
    p_R_XYZ = p_R_XYZ + p_D;
end

p_R_after = xyzToPolor(p_R_XYZ);



clear TH R

%% step4 计算与真实理想位置
% 计算真实理想位置
p_T_polor = [p_T_rou, I_Angles(i)];
p_T_XYZ = polorToXYZ(p_T_polor);

% 计算距离
dis = sqrt(sum((p_R_XYZ - p_T_XYZ).^2));


% 赋值
dises(i) = dis;
positions(i,:) = p_R_after;
end
%

end

