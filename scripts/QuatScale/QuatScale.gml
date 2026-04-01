/// @desc Scales each component of the quaternion by a value

function QuatScale(_quat, _value) {
    return [
        _quat[0] * _value,
        _quat[1] * _value,
        _quat[2] * _value,
        _quat[3] * _value
    ];
}
