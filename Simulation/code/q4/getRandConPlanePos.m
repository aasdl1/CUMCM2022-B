function [position] = getRandConPlanePos(number)
% 获取飞机真实位置
    % 误差1%内
    ratio = 0.01;
    X = [
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
    X = X + rand(size(X))*ratio*2-ratio;  %[-0.05,0.05];
    position = X(number,:);
end
