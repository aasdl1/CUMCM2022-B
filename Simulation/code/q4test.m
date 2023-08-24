%% q4 test 画三个外接圆
% 间距
sigma = 50;

onex = sqrt(3)/2;
oney = 1/2;

O = [0,0];
A = sigma * [onex,-(3*oney)];
B = sigma * [3*onex, oney];
M = sigma * [onex + 0.2, 3*oney+0.2];


% 画外接圆
plotOutTri([M;O;A])
plotOutTri([M;O;B])
plotOutTri([M;A;B])