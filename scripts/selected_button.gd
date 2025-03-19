extends BaseButton

@export var id:int

func _pressed():
	WhatSelected.selected_id=id
