extends Line2D

var can_be_erased = false
#var point_one = Vector2(0,0)
#var point_two = Vector2(0,0)
#var point_one = Vector2(0,0)
#var point_two = Vector2(0,0)

signal reset_status
signal remove_line

func update_begin(point_one):
	set_point_position(0, point_one)

func update_end(point_two):
	set_point_position(1, point_two)
	if points.size() == 3:
		remove_point(2)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT:
			var mouse_click = get_global_mouse_position()
			var squared_width = width * width
			var offset = 0
			
			for i in range(points.size() -1):
				var closest_point = Geometry.get_closest_point_to_segment_2d(mouse_click, global_position + points[i], global_position + points[i+1])
				if closest_point.distance_squared_to(mouse_click) <= squared_width:
					offset += closest_point.distance_to(global_position + points[i])
					on_click()
					break
				else:
					offset += points[i].distance_to(points[i+1])

func on_click():
	Mouse.connection = false
	emit_signal('reset_status')
	emit_signal('remove_line')
	call_deferred('free')

func fade_away():
	$AnimationPlayer.play("fade")
