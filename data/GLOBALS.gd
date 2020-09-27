extends Node

var levels = ["res://data/Stages/Start.tscn",
			"res://data/Stages/HydrogenPeroxide.tscn",
			"res://data/Stages/Methane.tscn",
			"res://data/Stages/Formaldehyde.tscn",
			"res://data/Stages/Isobutane.tscn",
			"res://data/Stages/Benzene.tscn",
			"res://data/Stages/HydrogenIsocyanide.tscn",
			"res://data/Stages/FulminicAcid.tscn",
			"res://data/Stages/ButyricAcid.tscn",
			"res://data/Stages/Menthone.tscn",
			"res://data/Stages/End.tscn"]
var current_level = 0

func next_level():
	current_level += 1
	if current_level == levels.size():
		current_level = -1
		next_level()
	else:
		get_tree().change_scene(levels[current_level])
