extends Node

func background_changed(new_background):
	print(new_background)
	var children=get_children()
	for child in children:
		print(child.name, child.name==new_background)
		if child.name==new_background:
			child.visible=true
			if (child.get_node("Camera3D")!=null):
				child.get_node("Camera3D").current=true
		else:
			child.visible=false
			if (child.get_node("Camera3D")!=null):
				child.get_node("Camera3D").current=false
