extends Node

signal send_expression(new_expression)

func expression_changed(new_expression):
	send_expression.emit(new_expression)
	if (new_expression=="romana:sit_appear"):
		$romana_sit.visible=true
	elif (new_expression=="romana:clone_appear"):
		$romana_clone.visible=true
	if (new_expression=="romana:sit_disappear"):
		$romana_sit.visible=false
	elif (new_expression=="romana:clone_disappear"):
		$romana_clone.visible=false
