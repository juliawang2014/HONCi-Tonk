extends Area2D

var connections = 0
var being_dragged = false
var clicked = false
var can_be_moved = false

signal new_position(point)

func _ready():
	connections = $Connections.get_child_count()
	other_setup()

func other_setup():
	pass

func _process(delta):
	if being_dragged:
		position = get_global_mouse_position()
		for i in connections:
			var my_point = $Connections.get_child(i)
			if my_point.has_a_line:
				emit_signal('new_position', my_point)

func _input(event):
	if event is InputEventMouseButton and can_be_moved:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				being_dragged = true
			else:
				being_dragged = false

func _on_Element_mouse_entered():
	can_be_moved = true


func _on_Element_mouse_exited():
	can_be_moved = false

func fade_away():
	$AnimationPlayer.play("fade")

func fade_in():
	$AnimationPlayer.play_backwards("fade")
