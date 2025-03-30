extends Node

var active_scene:Node

func _ready():
	#for child in get_children():
	#	child.visible=false
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
	if (animation_player==null):
		return
	var colon=new_expression.find(':')
	#if (animation_player!=null):
	if colon==-1:
		if animation_player.has_animation(new_expression):
			animation_player.play(new_expression)
	else:
		var pre_colon=new_expression.substr(0, colon)
		var post_colon=new_expression.substr(colon+1)
		#var loc_player=
		if active_scene.get_node_or_null("AnimationPlayer_"+pre_colon)!=null:
			active_scene.get_node_or_null("AnimationPlayer_"+pre_colon).play(post_colon)
		else:
			var loc_player=animation_player.duplicate()
			loc_player.name="AnimationPlayer_"+pre_colon
			active_scene.add_child(loc_player)
			loc_player.play(post_colon)
