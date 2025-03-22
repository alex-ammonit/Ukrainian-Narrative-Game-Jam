extends RichTextLabel

@export_file() var file_path:String
@export_multiline var t:String
@export var color_dict:Dictionary[String, Color]
@export var polygon_spawner: PolygonSpawner
var script_play
var script_labels:Dictionary[String, int]
var script_pickup:int=-1
var theme_attention:Dictionary[String, Array ]
var cur_theme="none"
##change expression
signal change_expression(new_expression)
signal change_background(new_background)
signal change_music(new_music)
signal play_sound(sound)
signal beep_signal(char, ciphered)
signal tutorial(tutorial)
signal effect(new_effect)
signal change_name(new_name)

func tokenize(string:String):
	#print(string)
	var dictar=[]
	var in_brackets=false
	var p_t:String=""
	for i in len(string)+1:
		var shall_parse=false
		#var s=string[i]
		var s=''
		#print(s, in_brackets)
		if (i==len(string)):
			shall_parse=true
		else:
			s=string[i]
		if ( (s=='\n' or s=='\r') and in_brackets==false):
			shall_parse=true
		if (s=='<') or (s=='>'):
			shall_parse=true
		if (shall_parse==false and s!='\n'):
			p_t=p_t+s
		else:
			if (p_t==""):
				pass
			elif (in_brackets==false):
				dictar.append({"type":"text", "text":p_t})
				#in_brackets=true
			elif(in_brackets==true):
				dictar.append({"type":"control", "data":p_t})
			p_t=""
			if (s=='<'):
				in_brackets=true
			if (s=='>'):
				in_brackets=false
			if (s=='\n' or s=='\r'):
				dictar.append({"type":"new_line"})
	return dictar
	pass

func parse(string: String):
	#print("PAR")
	var elements=tokenize(string)
	var activeColor="none"
	var dictar=[]
	var el_length=len(elements)
	var line_buffer=[]
	var choice_buffer=[]
	var labels:Dictionary[String, int]
	var append_line= func():
		#print(el)
		#print(line_buffer)
		#var line=line_buffer.duplicate()
		if (not len(line_buffer)>0):
			return
		var has_text=false
		for l in line_buffer:
			if (l["type"]=="text"):
				has_text=true
		dictar.append({"type":"line", "line":line_buffer.duplicate(), "no_text":not has_text})
		line_buffer.clear()
		#line_buffer.clear()
	for i in range(el_length+1):
		if i==el_length:
			append_line.call()
			#print("END")
			#dictar.append({"type":"line", "line":line_buffer})
			#line_buffer=[]
			break
		var el=elements[i]
		if el["type"]=="control":
			var type=el["data"]
			var data=""
			var colon=type.find(':')
			if (colon!=-1):
				data=type.substr(colon+1)
				type=type.substr(0, colon)
			#print(type,colon, "DATA", data)
			if (len(choice_buffer)>0 and type!="choice" and type!="jump"):
				dictar.append({"type":"choices", "choices":choice_buffer.duplicate()})
				choice_buffer.clear()
			if (type=='label'):
				#labels.append({data:len(dictar)})
				labels[data]=len(dictar)
			if (type=="jump"):
				if (len(choice_buffer)>0):
					choice_buffer[len(choice_buffer)-1]["to"]=data
				elif (len(dictar)>0 and dictar[-1]["type"]=="check_attention" and dictar[-1]["to"]==""):
					dictar[-1]["to"]=data
				else:
					append_line.call()
					dictar.append({"type":"jump", "to":data})
			if (type=="speed"):
				line_buffer.append({"type":"speed", "speed":data.to_float()})
			if (type=="theme"):
				line_buffer.append({"type":"theme", "theme":data})
			if (type=="expression"):
				line_buffer.append({"type":"expression", "expression":data})
			if (type=="background"):
				line_buffer.append({"type":"background", "background":data})
			if (type=="music"):
				line_buffer.append({"type":"music", "music":data})
			if (type=="sound"):
				line_buffer.append({"type":"sound", "sound":data})
			if (type=="tutorial"):
				line_buffer.append({"type":"tutorial", "tutorial":data})
			if (type=="effect"):
				line_buffer.append({"type":"sound", "effect":data})
			if (type=="name"):
				line_buffer.append({"type":"name", "name":data})
			if (type=="choice"):
				append_line.call()
				choice_buffer.append({"type":"choice", "text":data, "to":-1})
			if (type=="check_attention"):
				append_line.call()
				dictar.append({"type":"check_attention", "data":data, "to":""})
				#i=i+1
				continue
			if (color_dict.has(type)):
				activeColor=type
			if (type=="none"):
				activeColor="none"
		if el["type"]=="text":
			var text={"type":"text","color":activeColor, "text":el["text"]}
			line_buffer.append(text)
		if el["type"]=="new_line":
			append_line.call()
	return {"script":dictar, "labels":labels}

func _ready():
	chars_arr = flicker_chars.split("")
	flicker_arr = flicker_chars.split("")
	if file_path!="":
		var file=FileAccess.open(file_path, FileAccess.READ)
		t=file.get_as_text()
	var p=parse(t)
	var commands=p["script"]
	print(p["labels"])
	script_labels=p["labels"]
	script_play=p["script"]
	cur_theme="none"
	#script_pickup=0
	#print(p, len(p))
	for i in len(commands):
		print(i,":", commands[i])
	#exec_line()
	turn_to_line(0)

func turn_to_line(line:int):
	script_pickup=line
	cur_command=-1
	cur_text_pos=-1
	cur_time=0
	dis_text=""
	if (cur_tween!=null):
		cur_tween.kill()

func back_line():
	turn_to_line( clamp(script_pickup-1, 0, len(script_play)-1) )
	#script_pickup=clamp(script_pickup-1, 0, len(script_play)-1)
	#exec_line()

func next_line():
	turn_to_line( clamp(script_pickup+1, 0, len(script_play)-1) )
	#script_pickup=clamp(script_pickup+1, 0, len(script_play)-1)
	#exec_line()

func _input(event):
	if (script_pickup==-1):
		return
	if (event is InputEventKey and event.is_pressed()):
		#print(event.as_text_keycode())
		if (event.as_text_keycode()=="Left"):
			back_line()
			#print("L")
			#script_pickup=clamp(script_pickup-1, 0, len(script_play)-1)
		if (event.as_text_keycode()=="Right"):
			next_line()
			#script_pickup=clamp(script_pickup+1, 0, len(script_play)-1)
			#script_pickup+=1
			#print("R")

func return_text(text:String, color:String="none"):
	var d={"open":"", "text":"", "close":"","cipher":false}
	if (color!="none"):
		d["open"]="[color=#"+color_dict[color].to_html()+"]"
		d["close"]="[/color]"
		is_cipher_shown = false
		if (color_dict[color]!=WhatSelected.color):
			d["cipher"]=true
			is_cipher_shown = true
			var app_text=""
			for i in range(len(text)):
				#app_text+="#"
				#app_text+="#@!&"[randi_range(0,3)]
				#var col_dif=(color_dict[color]-WhatSelected.color)
				if (text[i]==' '):
					app_text+=' '
					continue
				#var buf=(text[i]).to_utf8_buffer()
				#var bif=buf[0]
				#for k in range(1, len(buf)):
					#bif+=buf[k]+int(col_dif.r*1+col_dif.g*2+col_dif.b*3)
				#app_text+=String.chr( bif )
				app_text += flicker_text(text, i, color_dict[color])
				
			d["text"]=app_text
	if (color=="none" or color_dict[color]==WhatSelected.color):
		d["text"]=text
	return d

var cur_command:int=-1
var cur_text_pos:int=-1
var old_text_pos:int=-1
var cur_time=0
var dis_text=""
var cur_tween:Tween
var speed_coef=0.2
func set_speed(speed:float):
	speed_coef=1/speed
var seen_char=0
var all_char=0
func exec_line():
	var cur=script_play[script_pickup]
	text=str(cur)
	#print(cur_command, "  ", cur_text_pos, "  ", speed_coef, "  ", all_char, "  ", seen_char, "  ", cur_theme)
	if (cur["type"]=="line"):
		var line=cur["line"]
		#text=str(line)
		text=""
		'''if (cur_command==-1):
			var tween=create_tween()
			cur_command=0
			print(cur_command)
			tween.tween_property(self, "cur_command", len(line)-1, 1)'''
		var l;
		if (cur_command==-1): cur_command=0
		if (cur_command<len(line)):
			l=line[cur_command]
		#for l in line:
		if (cur_command<len(line)):
			#print(l["type"])
			if l["type"]=="text":
				var prev_text=text
				var app_text=""
				var color=l["color"]
				var txt=l["text"]
				var d=return_text(txt, color)
				#app_text=d["open"]+d["text"]+d["close"]
				if (cur_text_pos==-1):
					cur_text_pos=0
					cur_tween=create_tween()
					cur_tween.tween_property(self, "cur_text_pos", len(d["text"]), len(d["text"])*speed_coef)
				app_text=d["open"]+d["text"].substr(0, cur_text_pos)+d["close"]
				text=dis_text+app_text
				if (cur_text_pos!=-1 and cur_text_pos<len(txt) and cur_text_pos!=old_text_pos):
					beep_signal.emit(d["text"][cur_text_pos], d["cipher"])
					old_text_pos=cur_text_pos
				if (cur_text_pos==len(txt)):
					cur_tween.kill()
					if (d["cipher"]==false):
						dis_text+=d["text"]
					else:
						dis_text+="[color=dark_gray]"+d["text"]+"[/color]"
					#print("AAA")
					if (cur_theme!="none"):
						var s_char=0
						if (d["cipher"]==false):
							s_char=len(txt)
						var a_char=len(txt)
						#print(theme_attention.has(cur_theme))
						if (theme_attention.has(cur_theme)):
							var th=theme_attention[cur_theme]
							theme_attention[cur_theme]=[th[0]+a_char, th[1]+s_char]
						else:
							theme_attention[cur_theme]=[a_char, s_char]
						'''theme_attention[cur_theme][0]+=len(txt)
						if (d["cipher"]==false):
							theme_attention[cur_theme][1]+=len(txt)'''
						pass
						#print(theme_attention)
						#theme_attention[cur_theme]
					if (d["cipher"]==false):
						seen_char+=len(txt)
					all_char+=len(txt)
					cur_text_pos=-1
					cur_command+=1
			if l["type"]=="speed":
				set_speed(l["speed"])
				cur_command+=1
			if l["type"]=="theme":
				cur_theme=(l["theme"])
				cur_command+=1
			if l["type"]=="expression":
				change_expression.emit(l["expression"])
				cur_command+=1
			if l["type"]=="background":
				change_background.emit(l["background"])
				cur_command+=1
			if l["type"]=="music":
				change_music.emit(l["music"])
				cur_command+=1
			if l["type"]=="sound":
				play_sound.emit(l["sound"])
				cur_command+=1
			if l["type"]=="tutorial":
				tutorial.emit(l["tutorial"])
				cur_command+=1
			if l["type"]=="effect":
				effect.emit(l["effect"])
				cur_command+=1
			if l["type"]=="name":
				change_name.emit(l["name"])
				cur_command+=1
		else:
			text=dis_text	
	if (cur["type"]=="jump"):
		turn_to_line(script_labels[cur["to"]])
		#script_pickup=script_labels[cur["to"]]
	if (cur["type"]=="check_attention"):
		#text=str(cur)
		var data=cur["data"]
		data=data.replace(";more;", ">")
		data=data.replace(";less;", "<")
		data=data.replace(";equal;", "==")
		data=data.replace(";more_equal;", ">=")
		data=data.replace(";less_equal;", "<=")
		#text=data
		var regex=RegEx.new()
		regex.compile("[a-zA-Z\\_][a-z-A-Z\\_0-9]*")
		var reg_result=regex.search_all(data)
		var themes=[]
		if (reg_result):
			#print(result.get_string())
			for r in reg_result:
				themes.append(r.get_string())
				#print(r.get_string())
		var theme_values=[]
		for th in themes:
			if th=="global":
				theme_values.append(float(seen_char)/float(all_char))
			else:
				if (theme_attention.has(th)):
					var th_v=theme_attention[th]
					theme_values.append( float(th_v[1])/float(th_v[0]) )
				else:
					OS.alert("there is no such theme in the list")
		var expression=Expression.new()
		expression.parse(data, themes)
		var ex_result=expression.execute(theme_values)
		#text=str(ex_result)
		print(themes, theme_values)
		#text=str(ex_result)
		if (ex_result is bool):
			if cur["to"]!="" and ex_result:
				turn_to_line(script_labels[cur["to"]])
			else:
				next_line()
		#evaluate()
		#print(cur["type"])

func _process(delta):
	if is_cipher_shown:
		update_flicker_chars(delta)
	exec_line()
	pass
	
var is_cipher_shown := false
var flicker_timeout := 0.06
var flicker_timer := 0.0
var cur_flicker_rnd := 0
@export var flicker_chars: String = "1234567890йцукенгшщзхїфівапролджєячсмитьбю"
#"abcdefghijklmnopqrstuvwxyz1234567890!@#$^&*()…æ_+-=;[]/~`"
 #"йцукенгшщзхїфівапролджєячсмитьбюЙЦУКЕНГШЩЗХЇФІВАПРОЛДЖЄЯЧСМИТЬБЮ"
var chars_arr
var flicker_arr

func update_flicker_chars(delta):
	if flicker_timer > flicker_timeout:
		flicker_timer = 0.0
	flicker_timer += delta
	for i in range(0, flicker_arr.size()):
		var shift = flicker_timeout * (i+1) / flicker_arr.size()
		var diff = shift - flicker_timer
		if abs(diff) < delta:
			var rnd = randi() % flicker_arr.size()
			flicker_arr[i] = chars_arr[rnd] 

func flicker_text(text: String, i: int, target_color: Color):
	var cur_freq = WhatSelected.freq
	var target_range: Vector2 = polygon_spawner.color_to_range_dict[target_color]
	var dist_to_target = min(abs(target_range.x - cur_freq), abs(cur_freq - target_range.y))
	if randf() < dist_to_target:
		return flicker_arr[i % flicker_arr.size()]
	else:
		return text[i]
