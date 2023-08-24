% 绘画positions
% pos = [[100,0;102.947370926424,40.9878215447839;104.701621875316,79.7685766852877;105,119.750000000000;101.584229317453,159.399501370066;108.092849067949,199.397185466715;105.000000000000,240.070000000000;102.181496909929,279.878588984783;107.503207550062,320.932826590393]];
function plotPositions(pos)
clf
rou = mean(pos(:,1));

set(gca,'XLim',[-120 120]);
set(gca,'YLim',[-120 120]);

% 画圆
viscircles([0 0],rou,'Color','b','linewidth',1);%圆心坐标为(0,0)，半径为100,轮廓颜色为蓝色
hold on;

x = [0];
y = [0];

for i=1:size(pos,1)
    tmp = polorToXYZ(pos(i,:));
    x(i+1) = tmp(1);
    y(i+1) = tmp(2);
end

scatter(x,y,'k');
plot([x(2:end),x(2)],[y(2:end),y(2)],'r');
axis equal
drawnow;

end
 