extends Node

var active_scene:Node

func _ready():
	if (SceneManager.cur_active_scene!=null):
		active_scene=get_node(SceneManager.cur_active_scene)
		for child in get_children():
			if child!=active_scene:
				child.visible=false
			else:
				child.visible=true
				if (child.get_node_or_null("Camera3D")!=null):
					child.get_node("Camera3D").current=true

func background_changed(new_background):
	print(new_background)
	var children=get_children()
	for child in children:
		print(child.name, child.name==new_background)
		if child.name==new_background:
			active_scene=child
			SceneManager.temp_active_scene=get_path_to(active_scene)
			#print(SceneManager.temp_active_scene)
			child.visible=true
			if (child.get_node_or_null("Camera3D")!=null):
				child.get_node("Camera3D").current=true
		else:
			child.visible=false
			if (child.get_node_or_null("Camera3D")!=null):
				child.get_node("Camera3D").current=false

func expression_changed(new_expression):
	#print(active_scene.get_node_or_null("AnimationPlayer"))
	var animation_player=active_scene.get_node_or_null("AnimationPlayer")
	if (animation_player!=null):
		if animation_player.has_animation(new_expression):
			animation_player.play(new_expression)
