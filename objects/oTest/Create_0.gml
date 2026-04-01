quat = QuatNew();
z = 0;


#region unit tests


#region helpers


array_equals_epsilon = function(arr1,arr2,_epsilon=math_get_epsilon()) {
	var len1 = array_length(arr1);
	if array_length(arr2)!=len1 return false;
	for(var i=0; i<len1; i++) {
		var val1 = arr1[i];
		var val2 = arr2[i];
		if abs(val1-val2) > _epsilon return false;
	}
	return true;
}
array_num_difference = function(arr1,arr2) {
	var len = min(array_length(arr1),array_length(arr2));
	var arr3 = array_create(len,undefined);
	for(var i=0; i<len; i++) {
		arr3[i] = arr1[i] - arr2[i];
	}
	return arr3;
}
toString = function(val) {
	
	if is_array(val) {
		var str = "[ ";
		var len = array_length(val);
		for(var i=0; i<len; i++) {
			if i!=0 str += ", ";
			str += string_format(val[i],1,8);
		}
		return str + " ]";
	}
	else if is_numeric(val) {
		return string_format(val,1,8);
	}
	
	return string(val);
}

assert = function(condition,_message="") {
	if !condition throw _message;
}
assert_angle_equal = function(angle1,angle2,_message="",_epsilon=math_get_epsilon()) {
	var _diff = abs(angle_difference(angle1,angle2));
	_message += "\nExpected "+toString(angle1)+" to be near "+toString(angle2);
	_message += "\nDifference: "+toString(_diff);
	assert(_diff<_epsilon,_message);
}
assert_array_equal = function(arr1,arr2,_message="",_epsilon=undefined) {
	_message += "\nExpected "+toString(arr1)+"\nto equal  "+toString(arr2);
	_message += "\nDifference: "+toString(array_num_difference(arr1,arr2));
	assert(array_equals_epsilon(arr1,arr2,_epsilon),_message);
}
assert_equal = function(val1,val2,_message="",_epsilon=math_get_epsilon()) {
	var _diff = abs(val1-val2);
	_message += "\nExpected"+toString(val1)+"\nto equal "+toString(val2);
	_message += "\nDifference: "+toString(_diff);
	assert(_diff<_epsilon,_message);
}
testcase = function(name,func) {
	try {
		func();
	}
	catch(err) {
		show_error("Test case \"" + name + "\" failure!\n" + toString(err)+"\n\n",true);
	}
}

///@desc calculates the angle between two vectors
vector_angle = function(x1,y1,z1,x2,y2,z2) {
	var val = dot_product_3d_normalized( x1,y1,z1, x2,y2,z2 );
	val = clamp(val,-1,1);
	return radtodeg(arccos(val));
}
vector_array_angle = function(vec1,vec2) {
	return vector_angle( vec1[0],vec1[1],vec1[2], vec2[0],vec2[1],vec2[2] );
}
vector_dot_normalized = function(vec1,vec2) {
	return dot_product_3d_normalized( vec1[0],vec1[1],vec1[2], vec2[0],vec2[1],vec2[2] );
}

random_vector = function(length=random_range(0.5,2)) {
	
	//random non-zero normalized vector
	var len = 0;
	do {
		var r1 = random_range(-1,1);
		var r2 = random_range(-1,1);
		var r3 = random_range(-1,1);
		var len = point_distance_3d(0,0,0,r1,r2,r3)
	} until (!is_nan(len) && len!=0);
	
	//scaled to given length
	return [ r1/len*length, r2/len*length, r3/len*length ];
}
random_angles = function() {
	
	//random non-zero euler angles, negative and also > 360
	while (true) {
		var a1 = random_range(-720,720);
		var a2 = random_range(-720,720);
		var a3 = random_range(-720,720);
		if a1!=0 && a2!=0 && a3!=0 {
			return [a1,a2,a3];
		}
	}
}

nmod = function(num,md) { //mod with negative
	return (((num % md) + md) % md);
}

#endregion

/*
	tests todo:
	QuatAngleTo
	QuatRotateLocal*
	QuatRotateWorld*
	QuatRotateTowards
	QuatSlerp
*/

test_iters = 1000;
show_debug_message("Running unit tests...");



testcase("QuatInvert",function(){
	
	//inverse (with a non-unit length quat)
	var q = QuatFromEulerAngles(30.1,370.5,400.7);
	var q2 = QuatScale(q,4);
	var inv = QuatInvert(q2);
	assert_array_equal(inv,QuatNew(-0.06829064786583154,0.0017679188770902752,-0.08917340483433214,0.22334136595615536),"matches expected");
	
	//test multiplication by inverse equals original
	repeat(test_iters) {
		var q1 = QuatRandom();
		var q2 = QuatRandom();
		var iq1 = QuatInvert(q1);
		
		assert_array_equal(QuatMultiply(q1,iq1),QuatIdentity(),"Q * Q^-1 = I");
		assert_array_equal(q2,QuatMultiply(QuatMultiply(q2,q1),iq1),"Q2*Q1 * Q1^-1 = Q2");
		assert_array_equal(q2,QuatMultiply(QuatMultiply(q2,iq1),q1),"Q2*Q1^-1 * Q1 = Q2");
	}	
})


testcase("QuatRotateVector",function(){
	var vx = 1;
	var vy = 2;
	var vz = 3;
	var q = QuatFromEulerAngles(30.1,370.5,400.7);
	var vec = QuatRotateVector(q,vx,vy,vz);
	assert_array_equal(vec,[ 0.009787971573815613, 0.346720848621596, 3.7255454431188446 ],"matches expected");
	
	
	repeat(test_iters) {
		
		//get randomly rotated basis vectors
		var qrand = QuatRandom();
		var vecx = QuatRotateVector(qrand,1,0,0);
		var vecy = QuatRotateVector(qrand,0,1,0);
		var vecz = QuatRotateVector(qrand,0,0,1);
		
		//they should remain perpendicular
		assert(vector_dot_normalized(vecx,vecy)==0)
		assert(vector_dot_normalized(vecx,vecz)==0)
		assert(vector_dot_normalized(vecy,vecz)==0)
		
		//get rotations on these axis
		var ang = random_range(-720,720);
		var qaxis_x = QuatFromAxisAngle(vecx[0],vecx[1],vecx[2],ang);
		var qaxis_y = QuatFromAxisAngle(vecy[0],vecy[1],vecy[2],ang);
		var qaxis_z = QuatFromAxisAngle(vecz[0],vecz[1],vecz[2],ang);
		
		//rotating on the axis does nothing
		assert(vector_dot_normalized(QuatRotateVector(qaxis_x,vecx[0],vecx[1],vecx[2]),vecx)==1);
		assert(vector_dot_normalized(QuatRotateVector(qaxis_y,vecy[0],vecy[1],vecy[2]),vecy)==1);
		assert(vector_dot_normalized(QuatRotateVector(qaxis_z,vecz[0],vecz[1],vecz[2]),vecz)==1);
		
		//rotating a perpendicular vector applies a full rotation, and remains perpendicular
		var _angle_epsilon = 0.5;
		var vecang = vector_array_angle(QuatRotateVector(qaxis_x,vecy[0],vecy[1],vecy[2]),vecy);
		assert(
			abs(angle_difference(vecang,ang))<_angle_epsilon
			|| abs(angle_difference(vecang,-ang))<_angle_epsilon //same value but might be negative..
		);
		assert(vector_dot_normalized(QuatRotateVector(qaxis_x,vecy[0],vecy[1],vecy[2]),vecx)==0);
		
	}
})


testcase("QuatFromVectors",function(){
	var x1 = 5.6;
	var y1 = -7.8;
	var z1 = 10.11;
	var x2 = 17.38;
	var y2 = 435.2334;
	var z2 = -42.2;
	var qv = QuatFromVectors(x1,y1,z1, x2,y2,z2);
	assert_array_equal(qv,QuatNew(-0.755763733296055,0.07649100756334654,0.47763667314065394,0.44139949441235393),"matches expected");
	
	//test the angle is correct between random vectors
	//it can have some precision loss
	var _epsilon = 1;
	repeat(test_iters) {
		var vec = random_vector();
		var x1 = vec[0];
		var y1 = vec[1];
		var z1 = vec[2];
		var vec = random_vector();
		var x2 = vec[0];
		var y2 = vec[1];
		var z2 = vec[2];
		var ang_expected = vector_angle(x1,y1,z1, x2,y2,z2);
		
		var qv = QuatFromVectors(x1,y1,z1, x2,y2,z2);
		//check the angle
		var quat_ang = QuatGetAngle(qv);
		
		assert(
			abs(angle_difference(quat_ang,ang_expected))<_epsilon,
			"vectors -> quat angle check"
			+"\nfor ang_expected:"+toString(ang_expected)+" quat_ang:"+toString(quat_ang)
		);
	}
})


testcase("QuatFromAxisAngle",function(){
	//test matches expected
	var ax = 17.38;
	var ay = 435.2334;
	var az = -42.2;
	var angle = -35.6;
	var q = QuatFromAxisAngle(ax,ay,az,angle);
	assert_array_equal(q,QuatNew(-0.012140642186656463,-0.30402836461921334,0.029478429244931117,0.9521293927421387),"matches expected");
})


testcase("axis -> quat -> axis",function(){
	repeat(test_iters) {
		var axis_vector = random_vector();
		var ax = axis_vector[0];
		var ay = axis_vector[1];
		var az = axis_vector[2];
		var ang = random_range(-720,720);
		
		/*
			we want to see that the axis represents the same transformation,
			but it could be 180 or 360 degrees off or something and still work
			so axis -> quat_in -> axis -> quat_out,
			and compare how quat_in and quat_out transform a vector
		*/
		var quat_in = QuatFromAxisAngle(ax,ay,az,ang);
		var axis_out = QuatGetAxisAngle(quat_in);
		var quat_out = QuatFromAxisAngle(axis_out[0],axis_out[1],axis_out[2],axis_out[3]);
		
		var v1 = QuatRotateVector(quat_in,1,1,1);
		var v2 = QuatRotateVector(quat_out,1,1,1);
		assert_array_equal(v1,v2,"quat -> axis same rotation");
	}
})


testcase("matrix -> quat -> matrix",function(){
	//QuatGetRotationMatrix has a little precision loss
	var _epsilon = math_get_epsilon()*10;
	repeat(test_iters) {
		var ang = random_angles();
		var xang = ang[0];
		var yang = ang[1];
		var zang = ang[2];
	
		var mat_in = matrix_build(0,0,0, xang,yang,zang, 1,1,1);
		var mat_out = QuatGetRotationMatrix(QuatFromRotationMatrix(mat_in));
	
		assert_array_equal(
			mat_out,mat_out,
			"matrix -> quat -> matrix for angles x:"+toString(xang)+", y:"+toString(yang)+", z:"+toString(zang),
			_epsilon
		);
	}
})

testcase("QuatFromEulerAngles",function(){
	var q = QuatFromEulerAngles(30.1,370.5,400.7);
	assert_array_equal(q,QuatNew(0.2731625914633262,-0.007071675508361103,0.3566936193373286,0.8933654638246217),"matches expected");
})

testcase("from euler to euler",function(){
	
	//sort of matching this test:
	//https://github.com/rawify/Quaternion.js/blob/16adb12b3221f7ee9471aeb0fcd141170856d7cd/tests/quaternion.test.js#L1033
	//the resulting euler angles may not be the same, but the matrix is
	repeat(test_iters) {
		var ang = random_angles();
		var xang = ang[0];
		var yang = ang[1];
		var zang = ang[2];
		
		var q1 = QuatFromEulerAngles(xang,yang,zang);
		var angles = QuatToEulerAngles(q1);
		var q2 = QuatFromEulerAngles(angles[0],angles[1],angles[2]);
		
		var mat1 = QuatGetRotationMatrix(q1);
		var mat2 = QuatGetRotationMatrix(q2);
		//test matrix is similar by transforming a vector
		var vec1 = matrix_transform_vertex(mat1,1,1,1);
		var vec2 = matrix_transform_vertex(mat2,1,1,1);
		var _angdiff = vector_angle(vec1[0],vec1[1],vec1[2],vec2[0],vec2[1],vec2[2]);
		var _epsilon = 0.5; //close enough
		
		assert(
			_angdiff<_epsilon,
			"vector angle difference: "+toString(_angdiff)
		);
	}
});

show_debug_message("Passed unit tests :)");

#endregion

