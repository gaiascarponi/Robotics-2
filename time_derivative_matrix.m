function v_matrix = time_derivative_matrix(rc_matrix, q, q_dot)
% TIME_DERIVATIVE_MATRIX - Calcola la derivata temporale per una matrice di vettori posizione
%
% Input:
%   rc_matrix : Matrice simbolica [r1, r2, ..., rn], dove ogni colonna ri è un vettore funzione di q
%   q         : Vettore delle coordinate generalizzate [q1; q2; ...; qn] (simbolico)
%   q_dot     : Vettore delle derivate temporali [q1_dot; q2_dot; ...; qn_dot] (simbolico/numerico)
%
% Output:
%   v_matrix  : Matrice [v1, v2, ..., vn], dove vi è la derivata temporale di ri

    syms t
    [rows, cols] = size(rc_matrix);  % Dimensioni della matrice in input
    nq = length(q);                  % Numero di coordinate generalizzate
    
    % Crea variabili temporali q(t)
    q_t = sym('q_t', [nq 1]);
    for i = 1:nq
        q_t(i) = str2sym([char(q(i)) '(t)']);
    end
    
    % Inizializza la matrice di output
    v_matrix = sym(zeros(rows, cols));
    
    % Calcola la derivata per ogni colonna della matrice
    for k = 1:cols
        % Estrai la k-esima colonna (vettore posizione)
        pos_t = subs(rc_matrix(:, k), q, q_t);
        
        % Calcola la derivata temporale
        vel = diff(pos_t, t);
        
        % Sostituisci dq/dt con q_dot e q(t) con q
        for j = 1:nq
            vel = subs(vel, diff(q_t(j), t), q_dot(j));
            vel = subs(vel, q_t(j), q(j));
        end
        
        % Semplifica e memorizza il risultato
        v_matrix(:, k) = simplify(vel);
    end
end