% --- Parametri di traiettoria ---
q0 = 0.95;         % posizione iniziale
qf = 1.45;         % posizione finale
T = 1;             % periodo totale del moto [s]
N = 1000;          % numero di punti temporali

% --- Calcolo traiettoria per mezza andata ---
[q_half, v_half, a_half, ~, ~, t_sym, T_half] = QuinticTrajectory(q0, qf, T/2);

% --- Valutazione simbolica su vettore di tempo numerico ---
t_up = linspace(0, T/2, N/2);        % tempo durante la salita
q_up = double(subs(q_half, t_sym, t_up));
v_up = double(subs(v_half, t_sym, t_up));
a_up = double(subs(a_half, t_sym, t_up));

% --- Costruzione traiettoria periodica ---
t_full = linspace(0, T, N);                % tempo totale
q_full = [q_up, fliplr(q_up)];             % posizione: salita e discesa
v_full = [v_up, -fliplr(v_up)];            % velocità: discesa invertita
a_full = [a_up, fliplr(a_up)];             % accelerazione: simmetrica

% --- Plot dei risultati ---
figure;

% Posizione desiderata
subplot(1,3,1);
plot(t_full, q_full, 'b', 'LineWidth', 1.5);
xlabel('time [s]');
ylabel('p_{y,d}(t) [m]');
title('desired position profile');
grid on;
ylim([0.9, 1.5]);

% Velocità desiderata
subplot(1,3,2);
plot(t_full, v_full, 'g', 'LineWidth', 1.5);
xlabel('time [s]');
ylabel('v_d(t) [m/s]');
title('desired velocity');
grid on;

% Pseudo-accelerazione desiderata
subplot(1,3,3);
plot(t_full, a_full, 'r', 'LineWidth', 1.5);
xlabel('time [s]');
ylabel('\nu̇_d(t) [m/s²]');
title('desired pseudo-acceleration');
grid on;
