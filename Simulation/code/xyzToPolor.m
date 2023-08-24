function p = xyzToPolor(p_xyz)
    p = zeros(1,2);
    [TH, R]= cart2pol(p_xyz(1),p_xyz(2));
    p(1) = R;
    p(2) = TH*180/pi;
    if p(2) < 0
        % 为负则变成正
        p(2) = 360 + p(2);
    end
    
end
