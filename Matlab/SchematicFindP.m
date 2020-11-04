

figure(1); 
set(gcf, 'Position', [48 500 500 400]);
clf
set(gcf, 'Color', 'w');

t = linspace(0, 5, 1000); 
a = 2;
d = .2;

TA = [.8 2.3 3.8];
nA = zeros(size(TA));
nD = zeros(size(TA));
TD = TA + d*(rand(1,3)-.0);
M = zeros(length(t), length(TA));
for n = 1:length(TD)
    M(:,n) = 0.5+0.5*tanh(a*(TD(n)-t));
    nA(n) = find(t>=TA(n),1,'first'); 
end
semilogx(10.^t,M, 'k-', 'LineWidth', 2); 
hold on


for n = 1:length(TA)
    semilogx(10.^[TA(n) TA(n)], [0 M(nA(n),n)], 'k-'); 
end

percentages = [0.5 0.8];
for k = 1:length(percentages)
    p = percentages(k); 
    semilogx(10.^[min(t), max(t)], [p p], 'k--'); 
    text(10.^max(t), p, sprintf('p=%d%%', p*100), 'HorizontalAlignment', 'Right', 'VerticalAlignment', 'Bottom');
    for n = 1:length(TD)
        nD(n) = find(M(:,n)<=p, 1, 'first'); 
    end
    Tp = t(nD);
    Mp = p*ones(size(nD));
    semilogx(10.^Tp, Mp, 'ko'); 
    for n = 1:length(TD)
        semilogx(10.^[Tp(n) Tp(n)], [0 Mp(n)], 'k--'); 
        arrow([10.^Tp(n), 0.1], [10.^TA(n), 0.1], 'Length', 8, 'Ends', 'Both');
        %annotation('doublearrow',x,y); 
    end
end

xlabel('Time [s]'); 
ylabel('Normalized dM_{VRM}/dM_{FullVRM}')
ylim([0 1.1]);

f = gcf;
f.PaperPositionMode = 'auto'; 
f.PaperUnits = 'centimeters'; 
pos = f.Position; 
siz = [pos(3) pos(4)]; 
ratio = siz(2) / siz(1); 
f.PaperSize = 21*[1 ratio]; 
print(f, '../Output/SchemaP.pdf', '-painters', '-dpdf','-r0', '-bestfit');