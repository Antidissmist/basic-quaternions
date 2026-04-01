/// @desc Gets euler angles from the YXZ rotation matrix.
/// @param {array} m The YXZ rotation matrix.
/// @return {array} An array containing the euler angles `[rotX, rotY, rotZ]`.
/// @source https://www.geometrictools.com/Documentation/EulerAngles.pdf

function MatrixGetEuler(mat) {
    var _thetaX, _thetaY, _thetaZ;

    if (mat[6] < 1) {
        if (mat[6] > -1) {
            _thetaX = darcsin(-mat[6]);
            _thetaY = darctan2(mat[2], mat[10]);
            _thetaZ = darctan2(mat[4], mat[5]);
        } else {
            _thetaX = 90;
            _thetaY = -darctan2(-mat[1], mat[0]);
            _thetaZ = 0;
        }
    } else {
        _thetaX = -90;
        _thetaY = darctan2(-mat[1], mat[0]);
        _thetaZ = 0;
    }

    return [(_thetaX + 360) % 360, (_thetaY + 360) % 360, (_thetaZ + 360) % 360];
}
