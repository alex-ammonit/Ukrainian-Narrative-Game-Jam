extends Control

@export var steps: Array[Node]

var cur_step := 0
var is_pause := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if (is_pause):
		get_tree().paused = false

func _on_tutorial(action: Variant) -> void:
	if action == "start":
		print("start tutotial")
		show()
		steps[0].show()
	elif action == "end":
		print("end tutotial")
		hide()
	elif action == "next":
		next_step()
	#elif action == "await_input":
		#is_pause = true
		#get_tree().paused = true
		
func next_step():
	cur_step += 1
	for i in range(0, steps.size()):
		steps[i].hide()
		if i == cur_step:
			steps[i].show()
