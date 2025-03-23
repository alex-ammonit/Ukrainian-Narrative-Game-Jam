extends AudioStreamPlayer

var sample_hz=22050.0
var pulse_hz=440
var phase=0

var playback:AudioStreamPlayback

func _ready():
	stream.mix_rate=sample_hz
	playback=get_stream_playback()
	pass

func _on_beep_signal(char, ciphered):
	#print(char, ciphered)
	var increment=pulse_hz/sample_hz
	var frames_available=playback.get_frames_available()
	if (ciphered): pitch_scale=0.1
	else: pitch_scale=2.0
	for i in range(frames_available):
		var bchar=char.to_utf8_buffer()
		var bif=bchar[0]
		#print(bif)
		var new_frame
		if (ciphered):
			new_frame=Vector2.ONE* (sin(phase*TAU*(bif/50)* i ) + sin(phase*TAU*(bif/50) ))/2
		else:
			new_frame=Vector2.ONE*sin(phase*TAU*(bif/50)/i )
		#var new_frame=Vector2.ONE*sin(phase*TAU*(bif/50) )
		#var new_frame=Vector2.ONE*sin(phase*TAU)
		playback.push_frame(new_frame)
		#playback.push_frame(Vector2.ONE*sin(phase*TAU))
		phase=fmod(phase+increment, 1.0)
	'''var increment=pulse_hz/sample_hz
	
	var to_fill=playback.get_frames_available()
	while to_fill>0:
		playback.push_frame(Vector2.ONE * sin(phase*TAU) )
		phase=fmod(phase+increment, 1.0)
		to_fill-=1'''
	'''volume_db=-12
	var audio_sample=AudioStream.new()
	var data=PackedByteArray([])'''
	
	pass
