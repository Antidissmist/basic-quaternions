/// @desc Calculates the XYZ euler angles that the quaternion represents.
/// @param quaternion
/// @returns [x_angle,y_angle,z_angle]

function QuatToEulerAngles(q) {
    //https://github.com/rawify/Quaternion.js/blob/16adb12b3221f7ee9471aeb0fcd141170856d7cd/src/quaternion.js#L878

    var _x = q[0];
    var _y = q[1];
    var _z = q[2];
    var _w = q[3];

    var wx = _w * _x;
    var wy = _w * _y;
    var wz = _w * _z;
    var xx = _x * _x;
    var xy = _x * _y;
    var xz = _x * _z;
    var yy = _y * _y;
    var yz = _y * _z;
    var zz = _z * _z;

    static _asin = function(t) {
        return (t >= 1) ? (pi / 2) : ((t <= -1) ? (-pi / 2) : arcsin(t));
    };

    return [
        radtodeg(-arctan2(2 * (yz - wx), 1 - 2 * (xx + yy))),
        radtodeg(_asin(2 * (xz + wy))),
        radtodeg(-arctan2(2 * (xy - wz), 1 - 2 * (yy + zz)))
    ];
}
