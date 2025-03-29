extends Node

@export var selected_id:int=0;
var color: Color
var max_freq=1
var min_freq=-1.5
@export var freq:float=0:
	set(value):
		freq=clamp(value, min_freq, max_freq)
		#freq=value
	get:
		return freq

var target_color:Color=Color.TRANSPARENT

#func _process(delta):
	#print(selected_id)
