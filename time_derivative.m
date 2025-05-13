function vc = time_derivative(rc_fix, q, q_dot)
% TIME_DERIVATIVE_ARRAY - Calcola la derivata temporale per un array di vettori posizione
%
% Input:
%   rc_fix : cell array {r1, r2, ..., rn}, dove ogni ri è un vettore simbolico funzione di q
%   q      : vettore delle coordinate generalizzate [q1; q2; ...; qn]
%   q_dot  : vettore delle derivate temporali [q1_dot; q2_dot; ...; qn_dot]
%
% Output:
%   vc     : cell array {v1, v2, ..., vn}, dove vi è la derivata temporale di ri

    syms t
    n = length(rc_fix);  % Numero di vettori posizione
    nq = length(q);      % Numero di coordinate generalizzate
    
    % Crea variabili temporali q(t)
    q_t = sym('q_t', [nq 1]);
    for i = 1:nq
        q_t(i) = str2sym([char(q(i)) '(t)']);
    end
    
    % Inizializza l'array di output
    vc = cell(size(rc_fix));
    
    % Calcola la derivata per ogni vettore posizione
    for k = 1:n
        % Sostituisci q con q(t) nel vettore posizione corrente
        pos_t = subs(rc_fix{k}, q, q_t);
        
        % Calcola la derivata temporale
        vel = diff(pos_t, t);
        
        % Sostituisci le derivate dq/dt con q_dot e q(t) con q
        for j = 1:nq
            vel = subs(vel, diff(q_t(j), t), q_dot(j));
            vel = subs(vel, q_t(j), q(j));
        end
        
        % Semplifica e memorizza il risultato
        vc{k} = simplify(vel);
    end
end