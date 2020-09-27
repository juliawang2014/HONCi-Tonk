extends Node2D

onready var line = preload("res://data/UI/Line2D.tscn")

var line_instance
var positions = []
var old_positions = []
var following_mouse = false
var connection_count = 0
var pairs_needed
var round_won = false
var times_won = 0
var xpairs_needed

func _ready():
	Music.reset_audio()
	$Elements.modulate.a = 0
	for i in $Elements.get_child_count():
		var element = $Elements.get_child(i)
		element.connect('new_position', self, 'line_update')
		for j in element.connections:
			var my_connection = element.get_child(4)
			var my_point = my_connection.get_child(j)
			connection_count += 1
			my_point.connect("send_info", self, "point_position")
			positions.append(my_point.global_position)
	xpairs_needed = connection_count / 2
	pairs_needed = xpairs_needed
	$AnimationPlayer.play("fade")


func get_point_info():
	old_positions = positions.duplicate()
	positions.clear()
	for i in $Elements.get_child_count():
		var element = $Elements.get_child(i)
		for j in element.connections:
			var my_connection = element.get_child(4)
			var my_point = my_connection.get_child(j)
			positions.append(my_point.global_position)

func difference(arr1, arr2):
	var only_in_arr1 = []
	for v in arr1:
		if not (v in arr2):
			only_in_arr1.append(v)
	return only_in_arr1

func difference2(arr1, arr2):
	var only_in_arr2 = []
	for v in arr2:
		if not (v in arr1):
			only_in_arr2.append(v)
	return only_in_arr2

func point_position(point, status):
	if !status:
		line_instance = line.instance()
		line_instance.connect('reset_status', point, 'set_status')
		$Lines.call_deferred('add_child', line_instance)
		line_instance.add_point(point.global_position)
#		positions.append(point.global_position)
#		point.begin = true
#		point.end = false
		following_mouse = true
	else:
		line_instance.connect('reset_status', point, 'set_status')
		line_instance.connect('remove_line', self, 'change_score')
		line_instance.add_point(point.global_position)
#		positions.append(point.global_position)
#		point.end = true
#		point.begin = false
		following_mouse = false
		pairs_needed -= 1
		if pairs_needed < xpairs_needed:
			Music.unmute_1()

func change_score():
	pairs_needed += 1
	Music.mute()

func _process(delta):
	if following_mouse:
		line_instance.remove_point(1)
		line_instance.add_point(get_global_mouse_position())
	if pairs_needed <= 0 and times_won == 0:
		times_won += 1
		on_win()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT and following_mouse:
			Mouse.connection = false
			following_mouse = false
			line_instance.call_deferred('free')
			pairs_needed += 1
	if event and round_won:
		$AnimationPlayer.play_backwards("fade")
		Globals.next_level()
	if event.is_action("pause"):
		Pause.show_self()

func line_update(new_point):
	if new_point.has_a_line:
		get_point_info()
		var old_diff = difference(old_positions, positions)
		var new_diff = difference2(old_positions, positions)
		for i in $Lines.get_child_count():
			var my_line = $Lines.get_child(i)
			for j in old_diff.size():
				var compare_array = my_line.points
				if poolvector_has(compare_array, old_diff[j]) and new_point.begin:
					my_line.update_begin(new_diff[j])
				elif poolvector_has(compare_array, old_diff[j]) and new_point.end:
					my_line.update_end(new_diff[j])
#		update()


static func poolvector_has(poolvector, value):
	for v in poolvector:
		if v == value:
			return true
	return false

func on_win():
	$Info/CompoundName.show()
	$Info/CompoundName/AnimationPlayer.play("fade")
	$Timer.start()

func _on_Timer_timeout():
	round_won = true
