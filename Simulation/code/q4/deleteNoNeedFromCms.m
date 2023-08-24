clear
% 鉴别组合和不需要的
noneed = [1	2	3
1	4	6
1	7	10
1	11	15
1	12	14
1	8	9
5	2	3
5	4	6
5	7	10
5	11	15
5	12	14
5	8	9
];



need_plans_plane = [1,2,3,4,5,6,7,8,9,10,11,12,14,15];

arrs = combntns(need_plans_plane,3);
newArrs = [];
k = 1;
flag = true;

    for j = 1:size(arrs,1)
        flag = true;
        for i = 1:size(noneed,1)
            if sum(sort(noneed(i,:))==sort(arrs(j,:))) == 3
                % 存在了
                flag = false;
            end
        end
        if flag == true
            % 添加
            newArrs(k,:) = arrs(j,:);
            k = k+1;
        end
    end
 arrs = newArrs;
 