function [position] = getConicalPlanesPos(number)
% 返回锥形所处位置i的飞机
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
    position = X(number,:);
end
