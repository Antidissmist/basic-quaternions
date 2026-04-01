/// @param matrix

function QuatFromRotationMatrix(_mat) {
    var m00 = _mat[0];
    var m11 = _mat[5];
    var m22 = _mat[10];
    var m21 = _mat[9];
    var m12 = _mat[6];
    var m02 = _mat[2];
    var m20 = _mat[8];
    var m10 = _mat[4];
    var m01 = _mat[1];

    var _x, _y, _z, _w;

    _w = sqrt(max(0, 1 + m00 + m11 + m22)) / 2;
    _x = sqrt(max(0, 1 + m00 - m11 - m22)) / 2;
    _y = sqrt(max(0, 1 - m00 + m11 - m22)) / 2;
    _z = sqrt(max(0, 1 - m00 - m11 + m22)) / 2;
    _x = abs(_x) * sign(m21 - m12);
    _y = abs(_y) * sign(m02 - m20);
    _z = abs(_z) * sign(m10 - m01);

    return [_x, _y, _z, _w];
}