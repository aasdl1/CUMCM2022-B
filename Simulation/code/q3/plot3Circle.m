% 绘制三圆
rou = 20;
a = [rou,40];
b = [rou,160];
c = [rou,280];

% 未知点
M = [rou+10,130];

ad = polorToXYZ(a);  bd = polorToXYZ(b); cd = polorToXYZ(c); Md = polorToXYZ(M);
od = [0,0];

%plot circle
% viscircles([0 0],rou,'Color','b');%圆心坐标为(0,0)，半径为100,轮廓颜色为蓝色
axis equal
% set(gca,'XLim',[-30 30]);
% set(gca,'YLim',[-30 30]);
hold on
%% plot 直线
% %am
% plot([ad(1),Md(1)], [ad(2),Md(2)], 'k','linewidth',2);
% %bm
% plot([bd(1),Md(1)], [bd(2),Md(2)], 'k','linewidth',2);
% %cm
% plot([cd(1),Md(1)], [cd(2),Md(2)],'k','linewidth',2);
% 
% %ao
% plot([ad(1),0], [ad(2),0],'k','linewidth',2);
% %bo
% plot([bd(1),0], [bd(2),0],'k','linewidth',2);
% %co
% plot([cd(1),0], [cd(2),0],'k','linewidth',2);
% 
% %mo
% plot([Md(1),0], [Md(2),0],'k','linewidth',2);

% 画外接圆
plotOutTri([ad;od;Md])
plotOutTri([bd;od;Md])
plotOutTri([cd;od;Md])