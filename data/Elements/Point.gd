extends Area2D

var has_a_line = false
var connection_ready = false
var start_connecting = false
var following_mouse = false
var status
var begin = false
var end = false
signal send_info

func _input(event):
	if event is InputEventMouseButton and connection_ready:
		if event.button_index == BUTTON_LEFT and !has_a_line:
			if event.pressed and !Mouse.connection:
				emit_signal('send_info', self, Mouse.connection)
				begin = true
				end = false
				Mouse.connection = true
			else:
				emit_signal("send_info", self, Mouse.connection)
				begin = false
				end = true
				Mouse.connection = false
			has_a_line = true
			

func _on_Point_mouse_entered():
	connection_ready = true


func _on_Point_mouse_exited():
	connection_ready = false

func set_status():
	has_a_line = false
	begin = false
	end = false

