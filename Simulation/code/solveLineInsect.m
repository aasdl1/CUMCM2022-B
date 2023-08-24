function [x,y] = solveLineInsect(params1, params2)
% 求两直线交点
% a1x + b1y + c1 = 0
% a2x + b2y + c2 = 0

% y = (c1 * a2 - c2 * a1) / (a1 * b2 - a2 * b1)
% x = (c2 * b1 - c1 * b2) / (a1 * b2 - a2 * b1)

y = (params1(3) * params2(1) - params2(3) * params1(1)) / (params1(1) * params2(2) - params2(1) * params1(2));
x = (params2(3) * params1(2) - params1(3) * params2(2)) / (params1(1) * params2(2) - params2(1) * params1(2));

end