/// @desc Gets the axis and angle (in degrees) the quaternion represents
/// @returns [ vx,vy,vz, angle ]

function QuatGetAxisAngle(_quat) {
    //https://github.com/rawify/Quaternion.js/blob/16adb12b3221f7ee9471aeb0fcd141170856d7cd/src/quaternion.js#L858

    var _x = _quat[0];
    var _y = _quat[1];
    var _z = _quat[2];
    var _w = _quat[3];

    _w = max(-1, min(1, _w));
    var sin2 = 1 - _w * _w;

    //no rotation
    if (sin2 < math_get_epsilon()) {
        return [_x, _y, _z, 0];
    }

    var isin = 1 / sqrt(sin2);
    var angle = radtodeg(2 * arccos(_w));
    return [_x * isin, _y * isin, _z * isin, angle];
}
