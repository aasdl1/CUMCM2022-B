function alpha = calAlpha(A,O,B)
% 两点算角度
% OPos = [0,0];
OA = A-O;
OB = B-O;
sigma = acos(dot(OA,OB)/(norm(OA)*norm(OB)));
alpha = sigma*180/pi;
end
