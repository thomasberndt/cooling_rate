


figure(1); 
set(gcf, 'Position', [48 500 900 400]);
clf
set(gcf, 'Color', 'w');
p = panel(); 
p.pack(1, 2);
p.margintop = 8; 
p(1, 1).select();

title('a) Viscous demagnetization of VRM or pTRM', ...
    'Interpreter', 'latex', 'FontSize', 12);
lw =2;

t = logspace(0, 5, 1000); 
Ms0 = 10; 
tau0 = 1e-5; 

Mfull = Ms0 * exp(-t.^.5/50); 
tvrm = 400; 
idvrm = find(t>=tvrm, 1, 'first');
Mvrm = Mfull - Mfull(idvrm); 
Mvrm(idvrm:end) = 0; 

semilogx(t, Mfull, 'k-', 'LineWidth', lw); 
hold on
semilogx(t, Mvrm, 'k-', 'LineWidth', lw); 
xlabel('Time [s]'); 
ylabel('Magnetization M_r [nAm^2]');

plot([tvrm, tvrm], [Mfull(idvrm), 0], '--', 'LineWidth', lw, 'Color', 0 *[1 1 1] ); 

tdelta = 50; 
dt = 4; 
idd = find(t>=tdelta, 1, 'first'); 
idd2 = find(t>=tdelta*dt, 1, 'first'); 

plot([tdelta, tdelta], [Mfull(idd), Mfull(idd2)], 'k-', 'LineWidth', lw); 
plot([tdelta, tdelta], [Mvrm(idd), Mvrm(idd2)], 'k-', 'LineWidth', lw); 
plot([tdelta, tdelta*dt], [Mfull(idd2), Mfull(idd2)], 'k-', 'LineWidth', lw); 
plot([tdelta, tdelta*dt], [Mvrm(idd2), Mvrm(idd2)], 'k-', 'LineWidth', lw); 

text(tdelta, (Mfull(idd)+Mfull(idd2))/2, 'dM_{FullVRM} ', 'FontSize', 12, 'HorizontalAlignment', 'Right', 'VerticalAlignment', 'Middle');
text(tdelta, (Mvrm(idd)+Mvrm(idd2))/2, 'dM_{VRM or pTRM} ', 'FontSize', 12, 'HorizontalAlignment', 'Right', 'VerticalAlignment', 'Middle');

text(tdelta*dt/2, Mvrm(idd2), 'd ln t', 'FontSize', 12, 'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Top');
text(tdelta*dt/2, Mfull(idd2), 'd ln t ', 'FontSize', 12, 'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Top');

text(tvrm, Mfull(idvrm)/2, ' t_{relax} ', 'FontSize', 12, 'HorizontalAlignment', 'Right', 'VerticalAlignment', 'Middle');




p(1, 2).select();
title(('b) Normalized magnetization $\tilde{M}=dM_{VRM}/dM_{FullVRM}$'), ...
    'Interpreter', 'latex', 'FontSize', 12);
t = linspace(0, 5, 1000); 
a = 2;
d = .2;

TA = log10([20 400 6000]);
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

p_choice = zeros(size(TA));

for n = 1:length(TA)
    p_choice(n) = M(nA(n),n); 
    semilogx(10.^[TA(n) TA(n)], [0 p_choice(n)], 'k-'); 
end

p_opt = mean(p_choice);
semilogx(10.^[min(t), max(t)], [p_opt p_opt], 'k-'); 
text(10.^max(t), p_opt, 'optimal p', 'HorizontalAlignment', 'Right', 'VerticalAlignment', 'Bottom');
for n = 1:length(TD)
    nD(n) = find(M(:,n)<=p_opt, 1, 'first'); 
end
Tp = t(nD);
Mp = p_opt*ones(size(nD));
% semilogx(10.^Tp, Mp, 'ko'); 
    
percentages = [0.5 0.8];
for k = 1:length(percentages)
    p = percentages(k); 
    semilogx(10.^[min(t), max(t)], [p p], 'k--'); 
    text(10.^max(t), p, 'suboptimal p', 'HorizontalAlignment', 'Right', 'VerticalAlignment', 'Bottom');
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
xlim([1 1e5]);
ylim([0 1.1]);

f = gcf;
f.PaperPositionMode = 'auto'; 
f.PaperUnits = 'centimeters'; 
pos = f.Position; 
siz = [pos(3) pos(4)]; 
ratio = siz(2) / siz(1); 
f.PaperSize = 21*[1 ratio]; 
print(f, '../Output/Schema.pdf', '-painters', '-dpdf','-r0', '-bestfit');
% export_fig('../Output/Schema.pdf');
