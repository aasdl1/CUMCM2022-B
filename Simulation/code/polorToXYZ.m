function [P] = polorToXYZ(p)
P = zeros(1,2);
rou = p(1); theta = p(2);
x = rou*cosd(theta);
y = rou*sind(theta);
P(1) = x; P(2) = y;
end
