################################################################################
#                                 Euler Angles
################################################################################

export angle2dcm, angle2dcm!

################################################################################
#                                 Conversions
################################################################################

# Direction Cosine Matrix
# ==============================================================================

"""
### function angle2dcm!(dcm::Array{T,2}, angle_r1::T, angle_r2::T, angle_r3::T, rot_seq::AbstractString="ZYX") where T<:Real

Convert Euler angles to a direction cosing matrix.

##### Args

* dcm: (OUTPUT) Pre-allocated direction cosine matrix.
* angle_r1: Angle of the first rotation.
* angle_r2: Angle of the second rotation.
* angle_r3: Angle of the third rotation.
* rot_set: Rotation sequence.

##### Remarks

This function assigns dcm = A1 * A2 * A3 in which Ai is the DCM related with the
i-th rotation, i Є [1,2,3].

##### Example

     dcm = Array{Float64}(3,3)
     angle2dcm!(dcm, pi/2, pi/3, pi/4, "ZYX")

"""

function angle2dcm!(dcm::Array{T,2},
                    angle_r1::T,
                    angle_r2::T,
                    angle_r3::T,
                    rot_seq::AbstractString="ZYX") where T<:Real
    # Check if rot_seq has at least three characters.
    if (length(rot_seq) < 3)
        throw(ArgumentError)
    end

    # Compute the sines and cosines.
    c1 = cos(angle_r1)
    s1 = sin(angle_r1)

    c2 = cos(angle_r2)
    s2 = sin(angle_r2)

    c3 = cos(angle_r3)
    s3 = sin(angle_r3)

    # Check the rotation sequence and compute the DCM.
    rot_seq = uppercase(rot_seq)

    if ( startswith(rot_seq, "ZYX") )
        dcm[1,1] = c2*c1;
        dcm[1,2] = c2*s1;
        dcm[1,3] = -s2;

        dcm[2,1] = s3*s2*c1 - c3*s1;
        dcm[2,2] = s3*s2*s1 + c3*c1;
        dcm[2,3] = s3*c2;

        dcm[3,1] = c3*s2*c1 + s3*s1;
        dcm[3,2] = c3*s2*s1 - s3*c1;
        dcm[3,3] = c3*c2;
    elseif ( startswith(rot_seq, "XYX") )
        dcm[1,1] = c2;
        dcm[1,2] = s1*s2;
        dcm[1,3] = -c1*s2;

        dcm[2,1] = s2*s3;
        dcm[2,2] = -s1*c2*s3 + c1*c3;
        dcm[2,3] = c1*c2*s3 + s1*c3;

        dcm[3,1] = s2*c3;
        dcm[3,2] = -s1*c3*c2 - c1*s3;
        dcm[3,3] = c1*c3*c2 - s1*s3;
    elseif ( startswith(rot_seq, "XYZ") )
        dcm[1,1] = c2*c3;
        dcm[1,2] = s1*s2*c3 + c1*s3;
        dcm[1,3] = -c1*s2*c3 + s1*s3;

        dcm[2,1] = -c2*s3;
        dcm[2,2] = -s1*s2*s3 + c1*c3;
        dcm[2,3] = c1*s2*s3 + s1*c3;

        dcm[3,1] = s2;
        dcm[3,2] = -s1*c2;
        dcm[3,3] = c1*c2;
    elseif ( startswith(rot_seq, "XZX") )
        dcm[1,1] = c2;
        dcm[1,2] = c1*s2;
        dcm[1,3] = s1*s2;

        dcm[2,1] = -s2*c3;
        dcm[2,2] = c1*c3*c2 - s1*s3;
        dcm[2,3] = s1*c3*c2 + c1*s3;

        dcm[3,1] = s2*s3;
        dcm[3,2] = -c1*c2*s3 - s1*c3;
        dcm[3,3] = -s1*c2*s3 + c1*c3;
    elseif ( startswith(rot_seq, "XZY") )
        dcm[1,1] = c3*c2;
        dcm[1,2] = c1*c3*s2 + s1*s3;
        dcm[1,3] = s1*c3*s2 - c1*s3;

        dcm[2,1] = -s2;
        dcm[2,2] = c1*c2;
        dcm[2,3] = s1*c2;

        dcm[3,1] = s3*c2;
        dcm[3,2] = c1*s2*s3 - s1*c3;
        dcm[3,3] = s1*s2*s3 + c1*c3;
    elseif ( startswith(rot_seq, "YXY") )
        dcm[1,1] = -s1*c2*s3 + c1*c3;
        dcm[1,2] = s2*s3;
        dcm[1,3] = -c1*c2*s3 - s1*c3;

        dcm[2,1] = s1*s2;
        dcm[2,2] = c2;
        dcm[2,3] = c1*s2;

        dcm[3,1] = s1*c3*c2 + c1*s3;
        dcm[3,2] = -s2*c3;
        dcm[3,3] = c1*c3*c2 - s1*s3;
    elseif ( startswith(rot_seq, "YXZ") )
        dcm[1,1] = c1*c3 + s2*s1*s3;
        dcm[1,2] = c2*s3;
        dcm[1,3] = -s1*c3 + s2*c1*s3;

        dcm[2,1] = -c1*s3 + s2*s1*c3;
        dcm[2,2] = c2*c3;
        dcm[2,3] = s1*s3 + s2*c1*c3;

        dcm[3,1] = s1*c2;
        dcm[3,2] = -s2;
        dcm[3,3] = c2*c1;
    elseif ( startswith(rot_seq, "YZX") )
        dcm[1,1] = c1*c2;
        dcm[1,2] = s2;
        dcm[1,3] = -s1*c2;

        dcm[2,1] = -c3*c1*s2 + s3*s1;
        dcm[2,2] = c2*c3;
        dcm[2,3] = c3*s1*s2 + s3*c1;

        dcm[3,1] = s3*c1*s2 + c3*s1;
        dcm[3,2] = -s3*c2;
        dcm[3,3] = -s3*s1*s2 + c3*c1;
    elseif ( startswith(rot_seq, "YZY") )
        dcm[1,1] = c1*c3*c2 - s1*s3;
        dcm[1,2] = s2*c3;
        dcm[1,3] = -s1*c3*c2 - c1*s3;

        dcm[2,1] = -c1*s2;
        dcm[2,2] = c2;
        dcm[2,3] = s1*s2;

        dcm[3,1] = c1*c2*s3 + s1*c3;
        dcm[3,2] = s2*s3;
        dcm[3,3] = -s1*c2*s3 + c1*c3;
    elseif ( startswith(rot_seq, "ZXY") )
        dcm[1,1] = c3*c1 - s2*s3*s1;
        dcm[1,2] = c3*s1 + s2*s3*c1;
        dcm[1,3] = -s3*c2;

        dcm[2,1] = -c2*s1;
        dcm[2,2] = c2*c1;
        dcm[2,3] = s2;

        dcm[3,1] = s3*c1 + s2*c3*s1;
        dcm[3,2] = s3*s1 - s2*c3*c1;
        dcm[3,3] = c2*c3;
    elseif ( startswith(rot_seq, "ZXZ") )
        dcm[1,1] = -s1*c2*s3 + c1*c3;
        dcm[1,2] = c1*c2*s3 + s1*c3;
        dcm[1,3] = s2*s3;

        dcm[2,1] = -s1*c3*c2 - c1*s3;
        dcm[2,2] = c1*c3*c2 - s1*s3;
        dcm[2,3] = s2*c3;

        dcm[3,1] = s1*s2;
        dcm[3,2] = -c1*s2;
        dcm[3,3] = c2;
    elseif ( startswith(rot_seq, "ZYZ") )
        dcm[1,1] = c1*c3*c2 - s1*s3;
        dcm[1,2] = s1*c3*c2 + c1*s3;
        dcm[1,3] = -s2*c3;

        dcm[2,1] = -c1*c2*s3 - s1*c3;
        dcm[2,2] = -s1*c2*s3 + c1*c3;
        dcm[2,3] = s2*s3;

        dcm[3,1] = c1*s2;
        dcm[3,2] = s1*s2;
        dcm[3,3] = c2;
    else
        throw(RotationSequenceError)
    end

    nothing
end

"""
### function angle2dcm(angle_r1::T, angle_r2::T, angle_r3::T, rot_seq::AbstractString="ZYX") where T<:Real

Convert Euler angles to direction cosine matrix.

##### Args

* angle_r1: Angle of the first rotation.
* angle_r2: Angle of the second rotation.
* angle_r3: Angle of the third rotation.
* rot_seq: Rotation sequence.

##### Returns

* The direction cosine matrix.

##### Remarks

This function assigns dcm = A1 * A2 * A3 in which Ai is the DCM related with the
i-th rotation, i Є [1,2,3].

##### Example

     dcm = angle2dcm(pi/2, pi/3, pi/4, "ZYX")

"""

function angle2dcm(angle_r1::T,
                   angle_r2::T,
                   angle_r3::T,
                   rot_seq::AbstractString="ZYX") where T<:Real

    # Check if rot_seq has at least three characters.
    if (length(rot_seq) < 3)
        throw(ArgumentError)
    end

    # Allocate the output matrix.
    dcm = Array{T}(3,3)

    # Fill the DCM.
    angle2dcm!(dcm, angle_r1, angle_r2, angle_r3, rot_seq)

    # Return the DCM.
    dcm
end


"""
### function angle2dcm!(dcm::Array{T,2}, eulerang::EulerAngles{T}) where T<:Real

Convert Euler angles to a direction cosine matrix.

##### Args

* dcm: (OUTPUT) Pre-allocated direction cosine matrix.
* eulerang: Euler angles (*see* EulerAngle).

##### Returns

* The direction cosine matrix.

##### Remarks

This function assigns dcm = A1 * A2 * A3 in which Ai is the DCM related with the
i-th rotation, i Є [1,2,3].

##### Example

     dcm = Array{Float64}(3,3)
     dcm = angle2dcm(EulerAngle(pi/2, pi/3, pi/4, "ZYX"))

"""

function angle2dcm!(dcm::Array{T,2}, eulerang::EulerAngles{T}) where T<:Real
    angle2dcm!(dcm,
               eulerang.a1,
               eulerang.a2,
               eulerang.a3,
               eulerang.rot_seq)
end

"""
### function angle2dcm(eulerang::EulerAngles{T}) where T<:Real

Convert Euler angles to a direction cosine matrix.

##### Args

* eulerang Euler angles (*see* EulerAngle).

##### Returns

* The direction cosine matrix.

##### Remarks

This function assigns dcm = A1 * A2 * A3 in which Ai is the DCM related with the
i-th rotation, i Є [1,2,3].

##### Example

     dcm = angle2dcm(EulerAngle(pi/2, pi, pi/4, "ZYX"))

"""

function angle2dcm(eulerang::EulerAngles{T}) where T<:Real
    angle2dcm(eulerang.a1,
              eulerang.a2,
              eulerang.a3,
              eulerang.rot_seq)
end
