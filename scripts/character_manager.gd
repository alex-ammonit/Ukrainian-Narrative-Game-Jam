extends Node

signal send_expression(new_expression)
@export var characters:Dictionary[String, Node]

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
			var animation_player=characters[pre_colon].get_node_or_null("AnimationPlayer")
			if (animation_player!=null):
				animation_player.play(post_colon)
