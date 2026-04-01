function QuatInvert(_quat) {
    //https://github.com/rawify/Quaternion.js/blob/16adb12b3221f7ee9471aeb0fcd141170856d7cd/src/quaternion.js#L470
    //Q^-1 := Q' / |Q|^2
    
    var _x = _quat[0];
    var _y = _quat[1];
    var _z = _quat[2];
    var _w = _quat[3];
    
    var _normsq = _x*_x + _y*_y + _z*_z + _w*_w;
    
    if _normsq==0 {
        return QuatNew();
    }
    
    _normsq = 1 / _normsq;
    
    return [
        -_x * _normsq,
        -_y * _normsq,
        -_z * _normsq,
        _w * _normsq
    ];
}
