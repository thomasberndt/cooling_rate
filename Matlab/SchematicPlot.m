


figure(1); 
set(gcf, 'Position', [48 500 500 400]);
clf
set(gcf, 'Color', 'w');

lw =2;

t = logspace(0, 5, 1000); 
Ms0 = 10; 
tau0 = 1e-5; 

Mfull = Ms0 * exp(-t.^.5/50); 
tvrm = 1000; 
idvrm = find(t>=tvrm, 1, 'first');
Mvrm = Mfull - Mfull(idvrm); 
Mvrm(idvrm:end) = 0; 

semilogx(t, Mfull, 'k-', 'LineWidth', lw); 
hold on
semilogx(t, Mvrm, 'k-', 'LineWidth', lw); 
xlabel('Time [s]'); 
ylabel('Magnetization M_r [nAm^2]');

plot([tvrm, tvrm], [Mfull(idvrm), 0], '--', 'LineWidth', lw, 'Color', 0 *[1 1 1] ); 

tdelta = 100; 
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

f = gcf;
f.PaperPositionMode = 'auto'; 
f.PaperUnits = 'centimeters'; 
pos = f.Position; 
siz = [pos(3) pos(4)]; 
ratio = siz(2) / siz(1); 
f.PaperSize = 21*[1 ratio]; 
print(f, '../Output/Schema.pdf', '-painters', '-dpdf','-r0', '-bestfit');