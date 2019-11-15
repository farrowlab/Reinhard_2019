clear
clc

dpath = '\\10.86.1.80\areca\LabPapers\SCRouter\Data\database';
bistrat = [97 61 60 76];
% cells2analyze = 1:101; %take only the cells that were on the poster
cells2analyze = 'all';


load(fullfile(dpath,'usable'))
load(fullfile(dpath,'type'))
load(fullfile(dpath,'zpeak1'))
load(fullfile(dpath,'areaHull'))
use = usable{1,2};
if isstr(cells2analyze)
    cells2analyze = 1:length(use);
end
use = use(cells2analyze);
peak1 = zpeak1{1,2}(cells2analyze);
area = areaHull{1,2}(cells2analyze);
types = type{1,2}(cells2analyze);

%define if ON (0),OFF (1),between Chats (2) or bistratified (-1)
ONOFF = zeros(length(use),1);
ONOFF(bistrat) = -1;
ONOFF(find(peak1>=1)) = 1;
tmp = find(peak1>0);
ONOFF(tmp(find(peak1(tmp)<1))) = 2;

%only cells that were conisered usable
good = find(use == 1);
ONOFF = ONOFF(good);
types = types(good); %1 = PBg, 3 = LPflox
area = area(good);

%area per cell group and type
types2analyse = [1 3];
areaPerGroup = zeros(4,2);
stdPerGroup = zeros(4,2);
for t = 1:length(types2analyse)
   curr = find(types==types2analyse(t)); 
   
   cnt = 0;
   for cellGroup = [0 1 2 -1] %define if ON (0),OFF (1),between Chats (2) or bistratified (-1)
       cnt = cnt+1;
      tmp = find(ONOFF(curr)==cellGroup);
      areaPerGroup(cnt,t) = mean(area(curr(tmp)));
      stdPerGroup(cnt,t) = std(area(curr(tmp)));
   end
end


%%
col = {'r','b','m','k'};%ON, OFF, between, bi
figure
for i = 1:4
plot(1+((i-1)*0.2),areaPerGroup(i,1),'o','markerfacecolor',col{i},'markeredgecolor',col{i})
hold on
plot([1+((i-1)*0.2) 1+((i-1)*0.2)],[areaPerGroup(i,1)-stdPerGroup(i,1) areaPerGroup(i,1)+stdPerGroup(i,1)],'-','color',col{i})
end
for i = 1:4
plot(2+((i-1)*0.2),areaPerGroup(i,2),'o','markerfacecolor',col{i},'markeredgecolor',col{i})
plot([2+((i-1)*0.2) 2+((i-1)*0.2)],[areaPerGroup(i,2)-stdPerGroup(i,2) areaPerGroup(i,2)+stdPerGroup(i,2)],'-','color',col{i})
end

axis([0.5 3 min(areaPerGroup(:)-stdPerGroup(:))-200 max(areaPerGroup(:)+stdPerGroup(:))+200])
legend('ON','','OFF','','between','','bistrat','')


