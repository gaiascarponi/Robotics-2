function [q_dot, error] = task_priority(J1, r1_dot, J2, r2_dot, optimization, v2)
% Funzione risolutiva per task priority con gestione ottimizzazione null-space
% e verifica errore sul primo task: ee = r1_dot - J1 * q_dot
    
%%% ATTENZIONE %%% 
    % Se planare allora J 2xn e v 2x1
    % Se spaziale --> J 

% Input:
%   J1         : Jacobiano del primo task
%   r1_dot     : Derivata del primo task (e.g. ve)
%   J2         : Jacobiano del secondo task
%   r2_dot     : Derivata del secondo task (e.g. vt)
%   optimization : scalare (0: no ottimizzazione, 1: con ottimizzazione null-space)
%   v2         : vettore opzionale per ottimizzazione null-space
%
% Output:
%   q_dot      : Soluzione in velocità generalizzate
%   ee         : Errore sul primo task: ee = r1_dot - J1 * q_dot

    J1_inv = pinv(J1, 1e-10); 
    P1 = eye(size(J1,2)) - J1_inv * J1;

    % Pre-calcolo
    if isa(J2, 'sym') || isa(P1, 'sym')
        J2P1 = simplify(J2 * P1);
        J1_inv_r1_dot = simplify(J1_inv * r1_dot);
    else
        J2P1 = J2 * P1;
        J1_inv_r1_dot = J1_inv * r1_dot;
    end

    J2P1_inv = pinv(J2P1, 1e-10);

    % Caso: senza ottimizzazione
    if optimization == 0
        q_dot = J1_inv_r1_dot + P1 * J2P1_inv * (r2_dot - J2 * J1_inv * r1_dot);
    
    % Caso: con ottimizzazione null-space
    elseif optimization == 1
        if nargin < 6
            error('Devi fornire anche il vettore v2 se optimization = 1.');
        end
        Null_P = eye(size(J2P1, 2)) - J2P1_inv * J2P1;
        q_dot = J1_inv_r1_dot + P1 * J2P1_inv * (r2_dot - J2 * J1_inv * r1_dot) + P1 * Null_P * v2;


    else
        error('Valore di optimization non valido: usare 0 oppure 1.');
    end

    % Semplifica se simbolico
    if isa(J2, 'sym') || isa(P1, 'sym')
        q_dot = simplify(q_dot);
    end

    % Calcolo errore primo task: ee = r1_dot - J1 * q_dot
    error = r1_dot - J1 * q_dot;
    if isa(error, 'sym')
        error = simplify(error);
    end
end
