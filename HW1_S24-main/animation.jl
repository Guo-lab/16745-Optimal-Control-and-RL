function RotX(θ::Real)
    # println("RotX θ: ", θ)

    # rotation matrix for rotation about y axis
    # return [cos(θ) 0 sin(θ); 0 1 0; -sin(θ) 0 cos(θ)]
    return [1 0 0;0 cos(θ) -sin(θ); 0 sin(θ) cos(θ)]
end

function meshcat_animate(params, X, dt,N)
    vis = mc.Visualizer()
    # println("visualizer started")
    mc.render(vis)
    # println("visualizer rendered")
    
    rod1 = mc.Cylinder(mc.Point(0,0,-params.L1/2), mc.Point(0,0,params.L1/2), 0.05)
    rod2 = mc.Cylinder(mc.Point(0,0,-params.L2/2), mc.Point(0,0,params.L2/2), 0.05)
    # println("rods created")

    mc.setobject!(vis[:rod1], rod1)
    mc.setobject!(vis[:rod2], rod2)

    sphere = mc.HyperSphere(mc.Point(0,0,0.0), 0.1)
    mc.setobject!(vis[:s1], sphere)
    mc.setobject!(vis[:s2], sphere)
    # println("spheres created")

    anim = mc.Animation(floor(Int,1/dt))
    # println("animation created")
    
    for k = 1:N
        mc.atframe(anim, k) do
            θ1,θ2 = X[k][[1,3]]
            # @show θ1,θ2

            r1 = [0, params.L1*sin(θ1), -params.L1*cos(θ1) + 2]
            r2 = r1 + [0, params.L2*sin(θ2), -params.L2*cos(θ2)]
            # @show r1, r2

            mc.settransform!(vis[:s1], mc.Translation(r1))
            mc.settransform!(vis[:s2], mc.Translation(r2))
            # println("spheres transformed")

            mc.settransform!(vis[:rod1], mc.compose(mc.Translation(0.5*([0,0,2] + r1)),mc.LinearMap(RotX(θ1))))
            mc.settransform!(vis[:rod2], mc.compose(mc.Translation(r1 + 0.5*(r2 - r1)),mc.LinearMap(RotX(θ2))))
            # println("rods transformed")

        end
        # @show k;
    end
    mc.setanimation!(vis, anim)
    mc.render(vis)
end