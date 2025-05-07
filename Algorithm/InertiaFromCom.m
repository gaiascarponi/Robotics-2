function I = InertiaFromCom(rc_mov)
% InertiaFromCom - Generates symbolic inertia matrices for each link with double subscript notation
%
% Syntax: I = InertiaFromCom(rc_mov)
%
% Inputs:
%    r_com - cell array {r1, r2, ..., rn} with CoM position vectors [x, y, z]
%
% Outputs:
%    I - cell array of symbolic inertia matrices {I1, I2, ..., In}

    % Initialize output cell array
    I = cell(1, length(rc_mov));

    for i = 1:length(rc_mov)
        % Define symbols with double subscript notation
        Ic_ixx = sym(sprintf('Ic%dxx', i), 'real');
        Ic_iyy = sym(sprintf('Ic%dyy', i), 'real');
        Ic_izz = sym(sprintf('Ic%dzz', i), 'real');
        
        % Extract CoM position
        r = rc_mov{i};

        % Check for principal axis cases
        is_x = ~isequal(r(1), sym(0)) && isequal(r(2), sym(0)) && isequal(r(3), sym(0));
        is_y = ~isequal(r(2), sym(0)) && isequal(r(1), sym(0)) && isequal(r(3), sym(0));
        is_z = ~isequal(r(3), sym(0)) && isequal(r(1), sym(0)) && isequal(r(2), sym(0));

        % Handle symmetry cases
        if is_x
            % Principal axis X (Iyy = Izz)
            I{i} = diag([Ic_ixx, Ic_iyy, Ic_iyy]);
        elseif is_y
            % Principal axis Y (Ixx = Izz)
            I{i} = diag([Ic_ixx, Ic_iyy, Ic_ixx]);
        elseif is_z
            % Principal axis Z (Ixx = Iyy)
            I{i} = diag([Ic_ixx, Ic_ixx, Ic_izz]);
        else
            % No special symmetry
            I{i} = diag([Ic_ixx, Ic_iyy, Ic_izz]);
        end
    end
end
