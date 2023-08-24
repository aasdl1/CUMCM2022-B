function [err] = cosError(X,sdPoints,alphas)
    % 通过点计算角度最后计算误差
    % (x0,y0)
    % (xa,ya;...);
    % alphas:(a1,a2,a3)
    cosAes = zeros(3,1);
    for i = 1:3
    %     i = 1;
        x = X(1,1); y = X(1,2);
        xa = sdPoints(i,1); ya = sdPoints(i,2); 

        t = x^2 + y^2 - x*xa - y*ya;
        C = xa^2 + ya^2;

        cosA = t/(2*t+C);
        cosAes(i) = cosA;
    end
    
    cossdPoints = cosd(alphas');
    if sum(size(cossdPoints)-[3,1]) ~= 0
        error('cosPoint纬度错误');
    end
    
    
    err = sum(abs(cosAes - cossdPoints));
    
end

    
    