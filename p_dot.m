function p_dot = p_dot(p, q, q_dot)
    % mass_velocity - Calcola la velocità del centro di massa - p_dot_ci - dato p(q), q e q_dot
    %
    % Input:
    %   p     - Posizione del centro di massa (simbolica o numerica) [2x1 o 3x1]
    %   q     - Variabili di giunto (es. [q1; q2]) [Nx1]
    %   q_dot - Velocità di giunto (es. [q1_dot; q2_dot]) [Nx1]
    %
    % Output:
    %   p_dot - Velocità del centro di massa [2x1 o 3x1]
    
    % Se p è simbolica, calcoliamo p_dot simbolico
    if isa(p, 'sym')
        J = jacobian(p, q);  % Jacobiano geometrico
        p_dot = J * q_dot;   % Velocità del CM
        p_dot = simplify(p_dot);
    else
        % Se p è numerica, approssimiamo con differenze finite
        delta = 1e-6;
        J = zeros(length(p), length(q));
        
        for i = 1:length(q)
            q_perturbed = q;
            q_perturbed(i) = q_perturbed(i) + delta;
            
            % Calcola p(q + delta_q)
            p_perturbed = compute_position(q_perturbed);  % Sostituisci con la tua cinematica diretta
            J(:, i) = (p_perturbed - p) / delta;
        end
        
        p_dot = J * q_dot;
    end
end