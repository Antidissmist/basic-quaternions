/// @desc Calculates the quaternion to rotate vector 1 onto vector 2
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2

function QuatFromVectors(ux, uy, uz, vx, vy, vz) {
    //https://github.com/rawify/Quaternion.js/blob/16adb12b3221f7ee9471aeb0fcd141170856d7cd/src/quaternion.js#L1137

    var uLen = point_distance_3d(0, 0, 0, ux, uy, uz);
    var vLen = point_distance_3d(0, 0, 0, vx, vy, vz);

    // Normalize u and v
    if (uLen > 0) {
        ux /= uLen;
        uy /= uLen;
        uz /= uLen;
    }
    if (vLen > 0) {
        vx /= vLen;
        vy /= vLen;
        vz /= vLen;
    }

    // Calculate dot product of normalized u and v
    var dot = dot_product_3d(ux, uy, uz, vx, vy, vz);

    // Parallel when dot > 0.999999
    if (dot >= (1 - math_get_epsilon())) {
        return QuatNew();
    }

    // Anti-Parallel (close to PI) when dot < -0.999999
    if (1 + dot <= math_get_epsilon()) {
        if (abs(ux) > abs(uz)) {
            return QuatNewNormalized(-uy, ux, 0, 0);
        } else {
            return QuatNewNormalized(0, -uz, uy, 0);
        }
    }

    // w = cross(u, v)
    var wx = uy * vz - uz * vy;
    var wy = uz * vx - ux * vz;
    var wz = ux * vy - uy * vx;

    // |Q| = sqrt((1.0 + dot) * 2.0)
    return QuatNewNormalized(wx, wy, wz, 1 + dot);
}
