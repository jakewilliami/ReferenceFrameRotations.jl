################################################################################
#                             Euler Angle and Axis
################################################################################

export angleaxis_to_quat

################################################################################
#                                  Operations
################################################################################

"""
    function *(ea₂::EulerAngleAxis{T1}, ea₁::EulerAngleAxis{T2}) where {T1,T2}

Compute the composed rotation of `ea₁ -> ea₂`. Notice that the rotation will be
represented by a Euler angle and axis (see `EulerAngleAxis`). By convention, the
output angle will always be in the range [0, π] [rad].

Notice that the vector representing the axis in `ea₁` and `ea₂` must be unitary.
This function neither verifies this nor normalizes the vector.

"""
function *(ea₂::EulerAngleAxis{T1}, ea₁::EulerAngleAxis{T2}) where {T1,T2}
    # Auxiliary variables.
    sθ₁o2, cθ₁o2 = sincos(ea₁.a/2)
    sθ₂o2, cθ₂o2 = sincos(ea₂.a/2)

    v₁ = ea₁.v
    v₂ = ea₂.v

    # Compute `cos(θ/2)` in which `θ` is the new Euler angle.
    cθo2 = cθ₁o2*cθ₂o2 - sθ₁o2*sθ₂o2 * dot(v₁, v₂)

    T = promote_type( T1, T2, typeof(sθ₁o2), typeof(sθ₂o2), typeof(cθo2) )

    if abs(cθo2) >= 1-eps()
        # In this case, the rotation is the identity.
        return EulerAngleAxis( T(0), SVector{3,T}(0,0,0) )
    else
        # Compute `sin(θ/2)` in which `θ` is the new Euler angle.
        sθo2 = sqrt(1 - cθo2*cθo2)

        # Compute the θ angle between [0, 2π].
        θ = 2acos(cθo2)

        # Keep the angle between [0, π].
        s = +1
        if θ > π
            θ = T(2)*π - θ
            s = -1
        end

        v = s*( sθ₁o2*cθ₂o2*v₁ + cθ₁o2*sθ₂o2*v₂ + sθ₁o2*sθ₂o2*(v₁ × v₂) )/sθo2

        return EulerAngleAxis(θ, v)
    end
end

"""
    @inline function inv(ea::EulerAngleAxis)

Compute the inverse rotation of `ea`. The Euler angle returned by this function
will always be in the interval [0, π].

"""
@inline function inv(ea::EulerAngleAxis{T}) where T<:Number
    # Make sure that the Euler angle is always in the inverval [0,π]
    s = -1
    θ = mod(ea.a, T(2)*π)

    if θ > π
        s = 1
        θ = T(2)π - θ
    end

    EulerAngleAxis(θ, s*ea.v)
end

################################################################################
#                                 Conversions
################################################################################

# Quaternions
# ==============================================================================

"""
    function angleaxis_to_quat(θ::Number, v::AbstractVector)

Convert the Euler angle `θ` [rad] and Euler axis `v`, which must be a unit
vector, to a quaternion.

# Remarks

It is expected that the vector `v` is unitary. However, no verification is
performed inside the function. The user must handle this situation.

# Example

```julia-repl
julia> v = [1;1;1];

julia> v /= norm(v);

julia> angleaxis_to_quat(pi/2,v)
Quaternion{Float64}:
  + 0.7071067811865476 + 0.408248290463863.i + 0.408248290463863.j + 0.408248290463863.k
```

"""
function angleaxis_to_quat(θ::Number, v::AbstractVector)
    # Check the arguments.
    (length(v) > 3) && throw(ArgumentError("The provided vector for the Euler axis must have 3 elements."))

    cθo2 = cos(θ/2)

    # Keep `q0` positive.
    s = (cθo2 < 0) ? -1 : +1

    # Create the quaternion.
    Quaternion( s*cos(θ/2), s*sin(θ/2)*v )
end

"""
    function angleaxis_to_quat(angleaxis::EulerAngleAxis)

Convert a Euler angle and Euler axis `angleaxis` (see `EulerAngleAxis`) to a
quaternion.

# Remarks

It is expected that the vector `angleaxis.v` is unitary. However, no
verification is performed inside the function. The user must handle this
situation.

# Example

```julia-repl
julia> v = [1;1;1];

julia> v /= norm(v);

julia> angleaxis_to_quat(EulerAngleAxis(pi/2,v))
Quaternion{Float64}:
  + 0.7071067811865476 + 0.408248290463863.i + 0.408248290463863.j + 0.408248290463863.k
```

"""
angleaxis_to_quat(angleaxis::EulerAngleAxis) = angleaxis_to_quat(angleaxis.a,
                                                                 angleaxis.v)
