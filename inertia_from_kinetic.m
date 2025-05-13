function M = inertia_from_kinetic(Ttot, q_dot)
    % Takes as inputs:
    %   - T = the kinetic energy of the robot 
    %   - qdot_vector = the vector of q_dot ex: [qd1,qd2,qd3]
    %
    % Output:
    %   - M = the inertia matrix 

    M = simplify(hessian(Ttot, q_dot));
end