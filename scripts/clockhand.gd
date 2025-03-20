extends TextureRect

@export var wheelStep: float = 1.0

var mouse_hover: bool
var mouse_pressed: bool=false
var mouse_pressed_position: Vector2

func _process(delta):
	#rotation=WhatSelected.freq
	#print(mouse_hover)
	#if mouse_hover==false:
	#	mouse_pressed=false
	if mouse_pressed:
		var mouse_position=get_viewport().get_mouse_position()
		#print(mouse_pressed_position)
		#var new_rotation=global_position.angle_to_point(mouse_position)
		#var new_rotation=global_position.angle_to_point( (global_position-mouse_pressed_position)+mouse_position)
		#var new_rotation=(global_position-mouse_pressed_position).angle_to_point(mouse_position-mouse_pressed_position)
		#rotation=rotate_toward(rotation, new_rotation, delta)
		var delta_mouse=mouse_position-mouse_pressed_position
		#print(delta_mouse)
		#rotation=rotation+delta_mouse.x
		#var new_rotation=rotation+global_position.angle_to_point(global_position+delta_mouse)
		var new_rotation=rotation+(global_position.angle_to_point(mouse_pressed_position)-global_position.angle_to_point(mouse_position))
		#print(rotation, "   ", new_rotation)
		WhatSelected.freq=rotate_toward(rotation, new_rotation, delta)
		mouse_pressed_position=mouse_position
		#rotation=global_position.angle_to_point(mouse_position)
		#rotate_toward(rotation, global_position.angle_to_point(mouse_position), delta)
	rotation=WhatSelected.freq
	var col=$RayCast2D.get_collider()
	if col!=null:
		#print(col.get_parent().color)
		var col_col=col.get_parent().color
		if (col_col!=null):
			#print(col_col)
			#WhatSelected.color=col_col
			pass

func _input(event):
	if event is InputEventMouseButton:
		if mouse_hover==true:
			if event.pressed:
				mouse_pressed=true
				mouse_pressed_position=get_viewport().get_mouse_position()
		if event.pressed==false:
			mouse_pressed=false
			#rotation=position.angle_to_point(event.position)
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			rotateHandle(-wheelStep)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			rotateHandle(wheelStep)

func rotateHandle(amount):
	WhatSelected.freq += amount
	rotation = WhatSelected.freq
	
func _on_mouse_entered():
	mouse_hover=true
	pass # Replace with function body.


func _on_mouse_exited():
	mouse_hover=false
	pass # Replace with function body.
