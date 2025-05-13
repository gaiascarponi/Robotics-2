function [U, Utot, g] = gravity(rc_fix, m, g0, axis_char, q, sign_convention, U_extra)
% GRAVITY
% Calcola:
%   - U{i} = +/- m{i} * g0 * componente lungo l'asse scelto
%   - Utot = somma(U{i}) (+ U_extra opzionale)
%   - g = (dUtot/dq)' (derivata simbolica rispetto ai q)
%
% INPUTS:
%   rc_fix          : cell array (1xN), ognuno è un vettore posizione simbolico [x; y; z]
%   m               : vettore masse simboliche o numeriche (1xN)
%   g0              : costante gravitazionale (simbolica o numerica)
%   axis_char       : 'x', 'y' o 'z' — asse verticale nel frame 0
%   q               : vettore simbolico delle variabili generalizzate
%   sign_convention : 'pos' o 'neg' — se 'neg', cambia il segno dei termini U{i}
%   U_extra         : (opzionale) termine aggiuntivo di energia potenziale da sommare
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

    if nargin < 6
        sign_convention = 'pos';  % default
    end

    sign_factor = 1;
    if strcmpi(sign_convention, 'neg')
        sign_factor = -1;
    end

    if nargin < 7
        U_extra = 0;  % di default non c'è massa sull'end-effector
    end

    N = length(rc_fix);
    U = cell(1, N);
    Utot = 0;

    for i = 1:N
        pos_component = rc_fix{i}(idx);
        U{i} = simplify(sign_factor * m(i) * g0 * pos_component);
        Utot = Utot + U{i};
    end

    % Aggiunta energia potenziale extra (se fornita)
    Utot = simplify(Utot + U_extra);
    
    % Derivata simbolica di Utot rispetto ai q
    g = vpa(simplify(jacobian(Utot, q))).';
end
