extends Node

@export var menu="res://scenes/menu.tscn"
@export var main_scene="res://scenes/main_scene.tscn"

var cur_checkpoint="none"
var cur_active_scene=null
var temp_active_scene=null
var cur_theme_attention={}
var cur_global_attention=[0, 0]
var cur_theme="none"

func load_scene(scene):
	if (scene=="menu"):
		get_tree().change_scene_to_file(menu)
	if (scene=="main_scene"):
		get_tree().change_scene_to_file(main_scene)
