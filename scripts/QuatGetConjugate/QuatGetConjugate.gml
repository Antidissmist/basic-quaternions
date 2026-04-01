function QuatGetConjugate(_quat) {
    //https://github.com/rawify/Quaternion.js/blob/16adb12b3221f7ee9471aeb0fcd141170856d7cd/src/quaternion.js#L540
    //-x -y -z w
    return [-_quat[0], -_quat[1], -_quat[2], _quat[3]];
}
