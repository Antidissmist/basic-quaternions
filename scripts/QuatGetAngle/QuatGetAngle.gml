/// @desc Gets the angle (in degrees) that the quaternion represents on some axis.
/// @param quaternion
/// @returns angle

function QuatGetAngle(_quat) {
    return radtodeg(2 * arccos(_quat[3]));
}