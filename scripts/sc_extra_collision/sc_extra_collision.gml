function colMovRotate(angle) {

var _movAngle = angle;

// Start rotating here
repeat (ceil(abs(_movAngle))) {
	
	var _movedAngle = min(abs(_movAngle), 1) * sign(_movAngle);
	// take off
	_movAngle -= _movedAngle;
	// Add an check
	image_angle += _movedAngle;
	// How much it moved
	var _movedDirection = sign(_movedAngle);
	
	// Update collisions
	colUpdate();
	
	// Get all collisions in this place
	//ds_list_clear(global.colList);
	ds_list_delete_all(global.colList);
	var _collisions = instance_place_list(x, y, ob_soul, global.colList, false);
	for (var i = 0; i < _collisions; i++) {
		var _instance = global.colList[| i];
		// instance points
		var _insPoints = [	new Vec2(_instance.bbox_left, _instance.bbox_top),
				new Vec2(_instance.bbox_right, _instance.bbox_top),
				new Vec2(_instance.bbox_right, _instance.bbox_bottom),
				new Vec2(_instance.bbox_left, _instance.bbox_bottom) ];
		// It intersect here
		if (polygon_intersect_polygon(colPoints, _insPoints)) {
			
			if (debugVGetValue("showData")) { var _tempMask = instance_create_depth(_instance.x, _instance.y, -99, ob_box_debug, { mask_index : sp_soul_1, image_blend : c_aqua }); };
			
			//show_debug_message("ins collide");
			// has found
			var _hasFound = false, _rayCollected = [];
			// Get all points
			for (var n = 0; n < array_length(_insPoints); n++) {
				// get angle from origin to popint
				var _origin2Point = point_direction(x, y, _insPoints[n].x, _insPoints[n].y);
				var _origin2PointDistance = point_distance(x, y, _insPoints[n].x, _insPoints[n].y);
				// move constant
				var _moveDistance = _origin2PointDistance * sqrt(2 * (1 - cos(degtorad(abs(_movAngle)))));
				
				// get past angle
				var _pastAngle = _origin2Point - _movedAngle;
				// get now position
				var _pastX, _pastY;
				_pastX = x + lengthdir_x(_origin2PointDistance, _pastAngle);
				_pastY = y + lengthdir_y(_origin2PointDistance, _pastAngle);
				// distances
				var _past2NowDist = point_distance(_insPoints[n].x, _insPoints[n].y, _pastX, _pastY);
				// move angle too
				/*var _shotAngle = abs(arctan((1 - cos(degtorad(abs(_movAngle)))) / sin(degtorad(abs(_movAngle)))));
				// moving antihorario
				if (_movedDirection > 0) {
					// invert
					_shotAngle = 90 - radtodeg(_shotAngle);
				} else {
					// horario angle
					_shotAngle = radtodeg(_shotAngle) + abs(_movAngle);
				};*/
				
				
				_moveDistance = _past2NowDist * 10;
				// Add to direction
				//_origin2Point += _movedDirection * 90;
				_origin2Point = point_direction(_pastX, _pastY, _insPoints[n].x, _insPoints[n].y);
				//show_debug_message(angle_difference(_shotAngle, _origin2Point))
				// check ray
				var _rayShot;
				with (_instance) {
					_rayShot = colRay(_insPoints[n].x, _insPoints[n].y, _origin2Point, _moveDistance + 0.1, [other.id]);
					if (debugVGetValue("showData")) {
						var _tempRay = instance_create_depth(0, 0, -99, ob_ray_debug, { image_blend : c_orange });
						_tempRay.myRay = _rayShot; };
				};
				
				// Found
				if (_rayShot.found) {
					//show_debug_message("point " + string(n) + "(" + string(array_length(_rayCollected)) + "), d:" + string(_rayShot.distance) + ", a:" + string(_origin2Point));
					// add to this
					array_push(_rayCollected, [ _rayShot.distance, _origin2Point, n, _insPoints[n] ]);
					// Add distance to it
					//_instance.x += lengthdir_x(_rayShot.distance, _origin2Point);
					//_instance.y += lengthdir_y(_rayShot.distance, _origin2Point);
					_hasFound = true;
					//break;
				};
			};
			// create temporal collision
			var _tempCol = instance_create_depth(_instance.bbox_left, _instance.bbox_top, 0, ob_collision, {
				image_xscale : _instance.bbox_right - _instance.bbox_left,
				image_yscale : _instance.bbox_bottom - _instance.bbox_top
			});
			/*
			// Get all points from collision itself
			for (var n = 0; n < array_length(colPoints); n++) {
				// get angle from origin to popint
				var _origin2Point = point_direction(x, y, colPoints[n].x, colPoints[n].y);
				var _origin2PointDistance = point_distance(x, y, colPoints[n].x, colPoints[n].y);
				// move constant
				var _moveDistance = _origin2PointDistance * sqrt(2 * (1 - cos(degtorad(abs(_movAngle)))));
				
				// get past angle
				var _pastAngle = _origin2Point - _movedAngle;
				// get now position
				var _pastX, _pastY;
				_pastX = x + lengthdir_x(_origin2PointDistance, _pastAngle);
				_pastY = y + lengthdir_y(_origin2PointDistance, _pastAngle);
				// distances
				var _past2NowDist = point_distance(colPoints[n].x, colPoints[n].y, _pastX, _pastY);
				
				
				_moveDistance = _past2NowDist * 10;
				// Add to direction
				_origin2Point = point_direction(_pastX, _pastY, colPoints[n].x, colPoints[n].y);
				//_origin2Point -= _movedDirection * 90;
				
				
				
				// check ray
				var _rayShot;
				with (_instance) {
					_rayShot = colRay(other.colPoints[n].x, other.colPoints[n].y, _origin2Point, _moveDistance + 0.1, [_tempCol]);
					var _tempRay = instance_create_depth(0, 0, -99, ob_ray_debug, { image_blend : c_fuchsia });
					_tempRay.myRay = _rayShot;
				};
				
				// Found
				if (_rayShot.found) {
					show_debug_message("COL point " + string(n) + "(" + string(array_length(_rayCollected)) + "), d:" + string(_rayShot.distance) + ", a:" + string(_origin2Point));
					// add to this
					array_push(_rayCollected, [ _rayShot.distance, _origin2Point + 180, n, colPoints[n] ]);
					
					_hasFound = true;
				};
			};//*/
			// kill temporal col
			instance_destroy(_tempCol);
			
			
			
			// has founf?
			if (_hasFound) {
				var _maximun = [ 0, -1 ];
				// loop for all of this and choose the maximun
				for (var n = 0; n < array_length(_rayCollected); n++) {
					// is bigger than maximun
					if (_maximun[0] < _rayCollected[n][0]) {
						_maximun[1] = n;
						_maximun[0] = _rayCollected[n][0];
					};
				};
				// visited everything
				if (_maximun[1] != -1) {
					
					var _choosenPoint = _maximun[1];
					var _choosenVertex = _rayCollected[_choosenPoint][3];
					// choosen
					//show_debug_message("p: " + string(_choosenPoint));
					
					var _saveCollision = collisionActive;
					collisionActive = false;
					
					// Add distance to it
					with (_instance) {
						npcMoveX(lengthdir_x(_rayCollected[_choosenPoint][0], _rayCollected[_choosenPoint][1]), 0);
						npcMoveY(lengthdir_y(_rayCollected[_choosenPoint][0], _rayCollected[_choosenPoint][1]), 0);
					};
					collisionActive = _saveCollision;
					//_instance.x += lengthdir_x(_rayCollected[_choosenPoint][0], _rayCollected[_choosenPoint][1]);
					//_instance.y += lengthdir_y(_rayCollected[_choosenPoint][0], _rayCollected[_choosenPoint][1]);
					
					// create on position
					if (debugVGetValue("showData")) { instance_create_depth(_choosenVertex.x, _choosenVertex.y, -99, ob_point_debug, { image_blend : c_red }); };
				};
			} else {
				/*
				_hasFound = false;
				// create temporal collision
				var _tempCol = instance_create_depth(_instance.bbox_left, _instance.bbox_top, 0, ob_collision, {
					image_xscale : _instance.bbox_right - _instance.bbox_left,
					image_yscale : _instance.bbox_bottom - _instance.bbox_top
				});
				// Get all points
				for (var n = 0; n < array_length(colPoints); n++) {
					// get angle from origin to popint
					var _origin2Point = point_direction(x, y, colPoints[n].x, colPoints[n].y);
					var _origin2PointDistance = point_distance(x, y, colPoints[n].x, colPoints[n].y);
					// move constant
					var _moveDistance = _origin2PointDistance * sqrt(2 * (1 - cos(degtorad(abs(_movAngle)))));
					
					
					_moveDistance = _moveDistance * 10;
					// Add to direction
					_origin2Point -= _movedDirection * 90;
					//show_debug_message(angle_difference(_shotAngle, _origin2Point))
					// check ray
					var _rayShot;
					with (_instance) {
						_rayShot = colRay(other.colPoints[n].x, other.colPoints[n].y, _origin2Point, _moveDistance + 0.1, [_tempCol]); };
					
					// Found
					if (_rayShot.found) {
						show_debug_message("COL point " + string(n) + "(" + string(array_length(_rayCollected)) + "), d:" + string(_rayShot.distance) + ", a:" + string(_origin2Point));
						// add to this
						array_push(_rayCollected, [ _rayShot.distance, _origin2Point + 180, n ]);
						// Add distance to it
						//_instance.x += lengthdir_x(_rayShot.distance, _origin2Point);
						//_instance.y += lengthdir_y(_rayShot.distance, _origin2Point);
						_hasFound = true;
						//break;
					};
				};
				// has found
				if (_hasFound) {
					
					var _maximun = [ 0, -1 ];
					// loop for all of this and choose the maximun
					for (var n = 0; n < array_length(_rayCollected); n++) {
						// is bigger than maximun
						if (_maximun[0] < _rayCollected[n][0]) {
							_maximun[1] = n;
							_maximun[0] = _rayCollected[n][0];
						};
					};
					// visited everything
					if (_maximun[1] != -1) {
						
						var _choosenPoint = _maximun[1];
						var _choosenVertex = _rayCollected[_choosenPoint][2];
						// choosen
						show_debug_message("p: " + string(_choosenPoint));
						// Add distance to it
						_instance.x += lengthdir_x(_rayCollected[_choosenPoint][0], _rayCollected[_choosenPoint][1]);
						_instance.y += lengthdir_y(_rayCollected[_choosenPoint][0], _rayCollected[_choosenPoint][1]);
						
						// create on position
						instance_create_depth(colPoints[_choosenVertex].x, colPoints[_choosenVertex].y, -99, ob_point_debug, { image_blend : c_red });
					};
				};*/
			};
		};
	};
};

};

function colMovMoveX(xMov) {

var _movTotal = xMov;

// Start rotating here
//repeat (ceil(abs(_movTotal))) {
	
	//var _movedPos = min(abs(_movTotal), 1) * sign(_movTotal);
	// take off
	//_movTotal -= _movedPos;
	var _movedPos = xMov;
	
	// Add an check
	x += _movedPos;
	// How much it moved
	var _movedDirection = sign(_movedPos);
	
	// Update collisions
	colUpdate();
	
	// Get all collisions in this place
	//ds_list_clear(global.colList);
	ds_list_delete_all(global.colList);
	
	var _collisions = collision_rectangle_list(bbox_left - 1, bbox_top - 1, bbox_right + 1, bbox_bottom + 1, ob_soul, true, true, global.colList, false); //instance_place_list(x, y, ob_soul, global.colList, false);
	for (var i = 0; i < _collisions; i++) {
		var _instance = global.colList[| i];
		// instance points
		var _insPoints = [	new Vec2(_instance.bbox_left, _instance.bbox_top),
				new Vec2(_instance.bbox_right, _instance.bbox_top),
				new Vec2(_instance.bbox_right, _instance.bbox_bottom),
				new Vec2(_instance.bbox_left, _instance.bbox_bottom) ];
				//show_debug_message(_insPoints);
		//show_debug_message("ins collide prev points");
		// It intersect here
		if (polygon_intersect_polygon(colPoints, _insPoints)) {
			
			if (debugVGetValue("showData")) { var _tempMask = instance_create_depth(_instance.x, _instance.y, -99, ob_box_debug, { mask_index : sp_soul_1, image_blend : c_aqua }); };
			colIgnoreInside = true;
			
			//show_debug_message("ins collide");
			// has found
			var _hasFound = false, _rayCollected = [];
			// Get all points
			for (var n = 0; n < array_length(_insPoints); n++) {
				
				var _angleDir = (_movedDirection > 0) ? DIR_RIGHT : DIR_LEFT;
				var _length = abs(_movedPos);
				//show_debug_message(_angleDir);
				// check ray
				var _rayShot = -1;
				with (_instance) {
					_rayShot = colRay(_insPoints[n].x, _insPoints[n].y, _angleDir, _length + 0.25/*max(_length + 0.1, 1)*/, [ other ]);
					if (debugVGetValue("showData")) { 
						var _tempRay = instance_create_depth(0, 0, -99, ob_ray_debug, { image_blend : c_orange });
						_tempRay.myRay = _rayShot; };
					/*
					show_debug_message({
						initX : _rayShot.initX,
						initY : _rayShot.initY,
						endTrueX : _rayShot.endTrueX,
						endTrueY : _rayShot.endTrueY
					})*/
					//show_debug_message(json_stringify(_rayShot, true))
				};
				
				// Found
				if (_rayShot.found) {
					//show_debug_message("mov point " + string(n) + "(" + string(array_length(_rayCollected)) + "), d:" + string(_rayShot.distance) + ", a:" + string(_angleDir));
					// add to this
					array_push(_rayCollected, [ _rayShot.distance, _angleDir, n, _insPoints[n] ]);
					
					_hasFound = true;
				};
			};
			// create temporal collision
			var _tempCol = instance_create_depth(_instance.bbox_left, _instance.bbox_top, 0, ob_collision, {
				image_xscale : _instance.bbox_right - _instance.bbox_left,
				image_yscale : _instance.bbox_bottom - _instance.bbox_top
			});
			/*
			// Get all points from collision itself
			for (var n = 0; n < array_length(colPoints); n++) {
				// get angle from origin to popint
				var _origin2Point = point_direction(x, y, colPoints[n].x, colPoints[n].y);
				var _origin2PointDistance = point_distance(x, y, colPoints[n].x, colPoints[n].y);
				// move constant
				var _moveDistance = _origin2PointDistance * sqrt(2 * (1 - cos(degtorad(abs(_movAngle)))));
				
				// get past angle
				var _pastAngle = _origin2Point - _movedAngle;
				// get now position
				var _pastX, _pastY;
				_pastX = x + lengthdir_x(_origin2PointDistance, _pastAngle);
				_pastY = y + lengthdir_y(_origin2PointDistance, _pastAngle);
				// distances
				var _past2NowDist = point_distance(colPoints[n].x, colPoints[n].y, _pastX, _pastY);
				
				
				_moveDistance = _past2NowDist * 10;
				// Add to direction
				_origin2Point = point_direction(_pastX, _pastY, colPoints[n].x, colPoints[n].y);
				//_origin2Point -= _movedDirection * 90;
				
				
				
				// check ray
				var _rayShot;
				with (_instance) {
					_rayShot = colRay(other.colPoints[n].x, other.colPoints[n].y, _origin2Point, _moveDistance + 0.1, [_tempCol]);
					var _tempRay = instance_create_depth(0, 0, -99, ob_ray_debug, { image_blend : c_fuchsia });
					_tempRay.myRay = _rayShot;
				};
				
				// Found
				if (_rayShot.found) {
					show_debug_message("COL point " + string(n) + "(" + string(array_length(_rayCollected)) + "), d:" + string(_rayShot.distance) + ", a:" + string(_origin2Point));
					// add to this
					array_push(_rayCollected, [ _rayShot.distance, _origin2Point + 180, n, colPoints[n] ]);
					
					_hasFound = true;
				};
			};//*/
			// kill temporal col
			instance_destroy(_tempCol);
			
			
			
			// has founf?
			if (_hasFound) {
				var _maximun = [ -600, -1 ];
				// loop for all of this and choose the maximun
				for (var n = 0; n < array_length(_rayCollected); n++) {
					// is bigger than maximun
					if (_maximun[0] < _rayCollected[n][0]) {
						_maximun[1] = n;
						_maximun[0] = _rayCollected[n][0];
					};
				};
				// visited everything
				if (_maximun[1] != -1) {
					
					var _choosenPoint = _maximun[1];
					var _choosenVertex = _rayCollected[_choosenPoint][3];
					// choosen
					//show_debug_message("p: " + string(_choosenPoint));
					
					var _saveCollision = collisionActive;
					collisionActive = false;
					
					// Add distance to it
					with (_instance) {
						npcMoveX(lengthdir_x(_rayCollected[_choosenPoint][0], _rayCollected[_choosenPoint][1]), 0);
					};
					collisionActive = _saveCollision;
					//_instance.x += lengthdir_x(_rayCollected[_choosenPoint][0], _rayCollected[_choosenPoint][1]);
					//_instance.y += lengthdir_y(_rayCollected[_choosenPoint][0], _rayCollected[_choosenPoint][1]);
					
					// create on position
					if (debugVGetValue("showData")) { instance_create_depth(_choosenVertex.x, _choosenVertex.y, -99, ob_point_debug, { image_blend : c_red }); };
				};
			};
			colIgnoreInside = false;
		};
	};
//};

};

function colMovMoveY(yMov) {

var _movTotal = yMov;

// Start rotating here
//repeat (ceil(abs(_movTotal))) {
	
	//var _movedPos = min(abs(_movTotal), 1) * sign(_movTotal);
	// take off
	//_movTotal -= _movedPos;
	var _movedPos = yMov;
	
	// Add an check
	y += _movedPos;
	// How much it moved
	var _movedDirection = sign(_movedPos);
	
	// Update collisions
	colUpdate();
	
	// Get all collisions in this place
	//ds_list_clear(global.colList);
	ds_list_delete_all(global.colList);
	
	var _collisions = collision_rectangle_list(bbox_left - 1, bbox_top - 1, bbox_right + 1, bbox_bottom + 1, ob_soul, true, true, global.colList, false); //instance_place_list(x, y, ob_soul, global.colList, false);
	for (var i = 0; i < _collisions; i++) {
		var _instance = global.colList[| i];
		// instance points
		var _insPoints = [	new Vec2(_instance.bbox_left, _instance.bbox_top),
				new Vec2(_instance.bbox_right, _instance.bbox_top),
				new Vec2(_instance.bbox_right, _instance.bbox_bottom),
				new Vec2(_instance.bbox_left, _instance.bbox_bottom) ];
				//show_debug_message(_insPoints);
		//show_debug_message("ins collide prev points");
		// It intersect here
		if (polygon_intersect_polygon(colPoints, _insPoints)) {
			
			if (debugVGetValue("showData")) { 
				var _tempMask = instance_create_depth(_instance.x, _instance.y, -99, ob_box_debug, { mask_index : sp_soul_1, image_blend : c_aqua }); };
			colIgnoreInside = true;
			
			//show_debug_message("ins collide");
			// has found
			var _hasFound = false, _rayCollected = [];
			// Get all points
			for (var n = 0; n < array_length(_insPoints); n++) {
				
				var _angleDir = (_movedDirection > 0) ? DIR_BOTTOM : DIR_TOP;
				var _length = abs(_movedPos);
				//show_debug_message(_angleDir);
				// check ray
				var _rayShot = -1;
				with (_instance) {
					_rayShot = colRay(_insPoints[n].x, _insPoints[n].y, _angleDir, _length + 0.25/*max(_length + 0.1, 1)*/, [ other ]);
					if (debugVGetValue("showData")) {
						var _tempRay = instance_create_depth(0, 0, -99, ob_ray_debug, { image_blend : c_orange });
						_tempRay.myRay = _rayShot; };
					
					/*show_debug_message({
						initX : _rayShot.initX,
						initY : _rayShot.initY,
						endTrueX : _rayShot.endTrueX,
						endTrueY : _rayShot.endTrueY
					})*/
				};
				
				// Found
				if (_rayShot.found) {
					//show_debug_message("mov Y point " + string(n) + "(" + string(array_length(_rayCollected)) + "), d:" + string(_rayShot.distance) + ", a:" + string(_angleDir));
					// add to this
					array_push(_rayCollected, [ _rayShot.distance, _angleDir, n, _insPoints[n] ]);
					
					_hasFound = true;
				};
			};
			// create temporal collision
			var _tempCol = instance_create_depth(_instance.bbox_left, _instance.bbox_top, 0, ob_collision, {
				image_xscale : _instance.bbox_right - _instance.bbox_left,
				image_yscale : _instance.bbox_bottom - _instance.bbox_top
			});
			/*
			// Get all points from collision itself
			for (var n = 0; n < array_length(colPoints); n++) {
				// get angle from origin to popint
				var _origin2Point = point_direction(x, y, colPoints[n].x, colPoints[n].y);
				var _origin2PointDistance = point_distance(x, y, colPoints[n].x, colPoints[n].y);
				// move constant
				var _moveDistance = _origin2PointDistance * sqrt(2 * (1 - cos(degtorad(abs(_movAngle)))));
				
				// get past angle
				var _pastAngle = _origin2Point - _movedAngle;
				// get now position
				var _pastX, _pastY;
				_pastX = x + lengthdir_x(_origin2PointDistance, _pastAngle);
				_pastY = y + lengthdir_y(_origin2PointDistance, _pastAngle);
				// distances
				var _past2NowDist = point_distance(colPoints[n].x, colPoints[n].y, _pastX, _pastY);
				
				
				_moveDistance = _past2NowDist * 10;
				// Add to direction
				_origin2Point = point_direction(_pastX, _pastY, colPoints[n].x, colPoints[n].y);
				//_origin2Point -= _movedDirection * 90;
				
				
				
				// check ray
				var _rayShot;
				with (_instance) {
					_rayShot = colRay(other.colPoints[n].x, other.colPoints[n].y, _origin2Point, _moveDistance + 0.1, [_tempCol]);
					var _tempRay = instance_create_depth(0, 0, -99, ob_ray_debug, { image_blend : c_fuchsia });
					_tempRay.myRay = _rayShot;
				};
				
				// Found
				if (_rayShot.found) {
					show_debug_message("COL point " + string(n) + "(" + string(array_length(_rayCollected)) + "), d:" + string(_rayShot.distance) + ", a:" + string(_origin2Point));
					// add to this
					array_push(_rayCollected, [ _rayShot.distance, _origin2Point + 180, n, colPoints[n] ]);
					
					_hasFound = true;
				};
			};//*/
			// kill temporal col
			instance_destroy(_tempCol);
			
			
			
			// has founf?
			if (_hasFound) {
				var _maximun = [ -600, -1 ];
				// loop for all of this and choose the maximun
				for (var n = 0; n < array_length(_rayCollected); n++) {
					// is bigger than maximun
					if (_maximun[0] < _rayCollected[n][0]) {
						_maximun[1] = n;
						_maximun[0] = _rayCollected[n][0];
					};
				};
				// visited everything
				if (_maximun[1] != -1) {
					
					var _choosenPoint = _maximun[1];
					var _choosenVertex = _rayCollected[_choosenPoint][3];
					// choosen
					//show_debug_message("p: " + string(_choosenPoint));
					
					var _saveCollision = collisionActive;
					collisionActive = false;
					
					// Add distance to it
					with (_instance) {
						npcMoveY(lengthdir_y(_rayCollected[_choosenPoint][0], _rayCollected[_choosenPoint][1]), 0);
					};
					collisionActive = _saveCollision;
					//_instance.x += lengthdir_x(_rayCollected[_choosenPoint][0], _rayCollected[_choosenPoint][1]);
					//_instance.y += lengthdir_y(_rayCollected[_choosenPoint][0], _rayCollected[_choosenPoint][1]);
					
					// create on position
					if (debugVGetValue("showData")) { instance_create_depth(_choosenVertex.x, _choosenVertex.y, -99, ob_point_debug, { image_blend : c_red }); };
				};
			};
			colIgnoreInside = false;
		};
	};
//};

};