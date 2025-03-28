extends Node

@export var menu="res://scenes/menu.tscn"
@export var main_scene="res://scenes/main_scene.tscn"

func load_scene(scene):
	if (scene=="menu"):
		get_tree().change_scene_to_file(menu)
	if (scene=="main_scene"):
		get_tree().change_scene_to_file(main_scene)
