function QuatNewNormalized(_x=0, _y=0, _z=0, _w=1)
{
    var _il = 1 / sqrt(_x*_x + _y*_y + _z*_z + _w*_w);
    return [ _x*_il, _y*_il, _z*_il, _w*_il ];
}