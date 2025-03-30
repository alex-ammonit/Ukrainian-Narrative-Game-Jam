extends Node

@export var polygon_spawner: PolygonSpawner
@export var music_dic:Dictionary[String, MusicTuple]
#@export var mt:music_tuple

var cur_music_name
var cur_music_a:AudioStream
var cur_music_b:AudioStream

'''class music_tuple:
	extends Resource
	@export var music_a:AudioStream
	@export var music_b:AudioStream'''

func music_a_finished():
	if (cur_music_name=="сніготяг" && cur_music_b!=null):
		print("Snih")
		cur_music_a=cur_music_b
		$AudioStreamPlayer.stream=cur_music_a
		cur_music_b=null
		$AudioStreamPlayer.play()
	
func _ready():
	$AudioStreamPlayer.connect("finished", music_a_finished)
	pass

func change_music(new_music):
	
	cur_music_name=new_music
	if (new_music=="none"):
		$AudioStreamPlayer.stop()
		$AudioStreamPlayer2.stop()
		return
	cur_music_a=music_dic[new_music].music_a
	cur_music_b=music_dic[new_music].music_b
	$AudioStreamPlayer.stream=cur_music_a
	$AudioStreamPlayer.play()
	if (cur_music_b!=null):
		$AudioStreamPlayer2.stream=cur_music_b
		$AudioStreamPlayer2.play()
	else:
		$AudioStreamPlayer2.stop()
		return
	
	#$AudioStreamPlayer.play()
	#print(new_music)
	#pass
func _process(delta):
	#print($AudioStreamPlayer.volume_linear, "  ", $AudioStreamPlayer2.volume_linear, "  ", WhatSelected.target_color)
	#print(cur_music_b)
	#if (cur_music_b==null or WhatSelected.target_color==Color.TRANSPARENT or WhatSelected.color==WhatSelected.target_color):
	if (cur_music_b==null or WhatSelected.ciphered_text==false):
		$AudioStreamPlayer.volume_linear=1
		$AudioStreamPlayer2.volume_linear=0
		return
	#print("AA")
	if (WhatSelected.text_displaying==false):
		return
	var cur_freq = WhatSelected.freq
	print(WhatSelected.target_color)
	var target_range: Vector2 = polygon_spawner.color_to_range_dict[WhatSelected.target_color.to_html()]
	var dist_to_target = min(abs(target_range.x - cur_freq), abs(cur_freq - target_range.y))
	if (dist_to_target==0):
		$AudioStreamPlayer.volume_linear=1
		$AudioStreamPlayer2.volume_linear=0
	else:
		$AudioStreamPlayer.volume_linear=clamp( (1-dist_to_target)/2.5, 0, 1)
		$AudioStreamPlayer2.volume_linear=clamp( 1-$AudioStreamPlayer.volume_linear, 0, 1)  #'''dist_to_target*4'''
	'''dist_to_target=clamp(dist_to_target, 0, 1)
	$AudioStreamPlayer.volume_linear=1-dist_to_target
	$AudioStreamPlayer2.volume_linear=dist_to_target'''
	#print (dist_to_target)
	pass
