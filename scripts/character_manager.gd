extends Node

signal send_expression(new_expression)
@export var characters:Dictionary[String, Node]

func _ready():
	if (SceneManager.cur_checkpoint!="none"):
		var cur_chars=SceneManager.cur_chars
		for k in cur_chars.keys():
			var c=cur_chars[k]
			characters[k].visible=c["visible"]
			var animation_player=characters[k].get_node_or_null("AnimationPlayer")
			if (animation_player!=null and c.has("animation") and c["animation"]!=""):
				animation_player.play(c["animation"])

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
