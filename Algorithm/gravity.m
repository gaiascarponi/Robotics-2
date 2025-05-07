function [U, Utot, g] = gravity(rc_fix, m, g0, axis_char, q)
% compute_potential_energy
% Calcola:
%   - U{i} = m{i} * g0 * componente lungo l'asse scelto
%   - Utot = somma(U{i})
%   - g = (dUtot/dq)' (derivata simbolica rispetto ai q)
%
% INPUTS:
%   rc_fix     : cell array (1xN), ognuno è un vettore posizione simbolico [x; y; z]
%   m          : vettore masse simboliche o numeriche (1xN)
%   g0         : costante gravitazionale (simbolica o numerica)
%   axis_char  : 'x', 'y' o 'z' — asse verticale nel frame 0
%   q          : vettore simbolico delle variabili generalizzate (es: q = [q1 q2 q3])
%
% OUTPUTS:
%   U          : cell array delle energie potenziali individuali
%   Utot       : energia potenziale totale
%   g          : vettore colonna delle derivate (dUtot/dq)'

    switch lower(axis_char)
        case 'x'
            idx = 1;
        case 'y'
            idx = 2;
        case 'z'
            idx = 3;
        otherwise
            error('Asse non valido. Usa ''x'', ''y'' o ''z''.');
    end

    N = length(rc_fix);
    U = cell(1, N);
    Utot = 0;

    for i = 1:N
        pos_component = rc_fix{i}(idx);
        U{i} = simplify(m(i) * g0 * pos_component);
        Utot = Utot + U{i};
    end

    Utot = simplify(Utot);
    g = vpa(simplify(jacobian(Utot, q))).';  % derivata simbolica trasposta
end
