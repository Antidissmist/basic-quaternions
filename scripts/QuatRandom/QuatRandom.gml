function QuatRandom() {
    //https://github.com/rawify/Quaternion.js/blob/16adb12b3221f7ee9471aeb0fcd141170856d7cd/src/quaternion.js#L1192

    var u1 = random(1);
    var u2 = random(1);
    var u3 = random(1);

    var s = sqrt(1 - u1);
    var t = sqrt(u1);

    return QuatNew(
        s * sin(2 * pi * u2), //x
        s * cos(2 * pi * u2), //y
        t * sin(2 * pi * u3), //z
        t * cos(2 * pi * u3) //w
    );
}
