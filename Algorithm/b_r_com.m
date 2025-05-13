function [rc_fix, rc_mov] = b_r_com(DH)
% r_com - Calcola le posizioni del centro di massa:
%         - rispetto al frame base (rc_fix)
%         - rispetto ai frame locali (rc_mov)
%
% INPUT:
%   DH - matrice dei parametri DH [alpha, a, d, theta] per ciascun link
%
% OUTPUT:
%   rc_fix - cell array con i vettori p_{0i} = A_{0i}(1:3,4) (frame base)
%   rc_mov - cell array con i vettori posizione del CoM nei frame locali

    n_links = size(DH,1);           % Numero di giunti/righe
    A = cell(1,n_links);            % Trasformazioni A_{0i}
    T = eye(4);                     % Inizializzazione T0 = identità
    rc_fix = cell(1,n_links);       % Vettori posizione rispetto al frame base
    rc_mov = cell(1,n_links);       % Vettori posizione nei frame mobili

    % Definizione simboli
    syms l [1 n_links] real         % Simboli l1, l2, ..., ln
    syms dc [1 n_links] real        % Simboli dc1, dc2, ..., dcn

    % ---- Calcolo rc_fix ----
    for i = 1:n_links
        alpha = DH(i,1);
        a     = DH(i,2);
        d     = DH(i,3);
        theta = DH(i,4);

        % Matrice omogenea secondo i parametri DH standard
        A_i = [cos(theta), -cos(alpha)*sin(theta),  sin(alpha)*sin(theta), a*cos(theta);
               sin(theta),  cos(alpha)*cos(theta), -sin(alpha)*cos(theta), a*sin(theta);
               0,           sin(alpha),             cos(alpha),            d;
               0,           0,                      0,                     1];

        T = simplify(T * A_i);                   % A_{0i} = A_{0,i-1} * A_{i-1,i}
        dci = simplify(T(1:3,4));                % Calcolo posizione p_{0i}
        dci = subs(dci, l(i), dc(i));            % Sostituzione simbolica
        rc_fix{i} = dci;                         % Salvo in output
    end

    % ---- Calcolo rc_mov ----
    a = DH(:,2);  % Estrai i parametri a dalla tabella DH
    for i = 1:n_links
        if i == 1
            rc_mov{i} = [0; dc(i); 0];           % CoM del primo link
        else
            rc_mov{i} = [dc(i) - a(i); 0; 0];     % CoM link successivi
        end
    end

    % Visualizzazione risultati (opzionale)
    fprintf('Posizioni CoM nei frame mobili:\n');
    for i = 1:n_links
        fprintf('Link %d:\n', i);
        disp(rc_mov{i});
    end
end
