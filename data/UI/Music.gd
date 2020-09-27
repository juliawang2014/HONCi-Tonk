extends AudioStreamPlayer

var iterator = 1

func _ready():
	reset_audio()

func reset_audio():
	iterator = 1
	for i in range(2, 11):
		AudioServer.set_bus_mute(i, true)

func unmute_1():
	iterator += 1
	var i = clamp(iterator, 2.0, 11.0)
	AudioServer.set_bus_mute(i, false)

func mute():
	var i = clamp(iterator, 2.0, 11.0)
	AudioServer.set_bus_mute(i, true)
	iterator -= 1
	
