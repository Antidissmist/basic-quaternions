/// @desc Returns a new, empty quaternion that represents no rotation
///
/// Quaternions are expressed as vec4s with the format [x, y, z, w]

function QuatNew(_x=0, _y=0, _z=0, _w=1)
{
    return [_x, _y, _z, _w];
}