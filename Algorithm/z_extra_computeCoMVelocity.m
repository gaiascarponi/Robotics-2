function vc = z_extra_computeCoMVelocity(rc_fix)


n = length(w);
vc = cell(1, n);

for i = 1:n
    % Velocità del CoM: vc = v + w × r_com
    vc{i} = simplify(v{i} + cross(w{i}, rc_fix{i}));
end
end