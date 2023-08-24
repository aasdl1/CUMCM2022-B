function [theta] = kOperate(theta)
    % 保证theta在0-180度中
    theta = abs(theta);
    theta = min(360-theta, theta);
end
