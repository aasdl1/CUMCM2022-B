function [A,B] = solveAB(p1,p2)
    % p(x,y)
    A = p2(2) - p1(2);
    B = p1(1) - p2(1);
end