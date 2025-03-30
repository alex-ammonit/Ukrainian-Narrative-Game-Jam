extends Node

signal send_expression(new_expression)
@export var characters:Dictionary[String, Node]
@export var faces:Dictionary[String, CompressedTexture2D]
@export var default_anim:Dictionary[String, String]

func _ready():
	if (SceneManager.cur_checkpoint!="none"):
		var cur_chars=SceneManager.cur_chars
		for k in cur_chars.keys():
			var c=cur_chars[k]
			characters[k].visible=c["visible"]
			var animation_player=characters[k].get_node_or_null("AnimationPlayer")
			if (animation_player!=null and c.has("animation") and c["animation"]!=""):
				animation_player.play(c["animation"])
	for char in default_anim.keys():
		var animation_player=characters[char].get_node_or_null("AnimationPlayer")
		if (animation_player!=null):
			#var anim_ended=func():
			#	animation_ended(char)
			animation_player.connect("animation_finished", func(name):animation_ended(char))

func animation_ended(character):
	print("END")
	var animation_player=characters[character].get_node_or_null("AnimationPlayer")
	if (animation_player!=null):
		animation_player.play(default_anim[character])
	pass

func expression_changed(new_expression):
	#send_expression.emit(new_expression)
	'''if (new_expression=="romana:sit_appear"):
		$romana_sit.visible=true
	elif (new_expression=="romana:clone_appear"):
		$romana_clone.visible=true
	if (new_expression=="romana:sit_disappear"):
		$romana_sit.visible=false
	elif (new_expression=="romana:clone_disappear"):
		$romana_clone.visible=false'''
	var colon=new_expression.find(':')
	if colon==-1:
		pass
	else:
		var pre_colon=new_expression.substr(0, colon)
		var post_colon=new_expression.substr(colon+1)
		
		if characters.has(pre_colon):
			if (post_colon=="appear"):
				characters[pre_colon].visible=true
				return
			if (post_colon=="disappear"):
				characters[pre_colon].visible=false
				return
			if (post_colon.substr(0, 4)=="face"):
				var s_colon=post_colon.find(':')
				if (s_colon!=-1):
					var post_post=post_colon.substr(colon)
					print("AAAAAAA")
					var mesh=characters[pre_colon].get_child(0).get_child(0).get_child(0)
					print(mesh is MeshInstance3D)
					var new_material=mesh.mesh.surface_get_material(1)
					new_material.albedo_texture=faces[post_post]
					#mesh.mesh.surface_set_material(1, new_material)
					#mesh.set_surface_override_material(1, new_material)
					print(new_material)
					#new_
					#mesh.set_surface_override_material(1, new StandardMaterial3D())
				return
			var animation_player=characters[pre_colon].get_node_or_null("AnimationPlayer")
			if (animation_player!=null):
				animation_player.play(post_colon)
	for char in characters.keys():
		var c={}
		c["visible"]=characters[char].visible
		var animation_player=characters[char].get_node_or_null("AnimationPlayer")
		if (animation_player!=null):
			c["animation"]=animation_player.current_animation
		SceneManager.temp_chars[char]=c
