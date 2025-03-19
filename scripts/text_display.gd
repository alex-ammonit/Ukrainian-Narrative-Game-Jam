extends RichTextLabel

@export_file() var file_path:String
@export_multiline var t:String
@export var color_dict:Dictionary[String, Color]
var script_play
var script_labels:Dictionary[String, int]
var script_pickup:int=-1

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
		if (s=='\n' and in_brackets==false):
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
			if (s=='\n'):
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
				else:
					append_line.call()
					dictar.append({"type":"jump", "to":data})
			if (type=="speed"):
				line_buffer.append({"type":"speed", "speed":data.to_float()})
			if (type=="choice"):
				append_line.call()
				choice_buffer.append({"type":"choice", "text":data, "to":-1})
			if (color_dict.has(type)):
				activeColor=type
			if (type=="none"):
				activeColor="none"
		if el["type"]=="text":
			var text={"type":"text","color":activeColor, "text":el["text"]}
			line_buffer.append(text)
		if el["type"]=="new_line":
			#pass
			#if (len(line_buffer)>0):
			#print(line_buffer)
			#dictar.append({"type":"line", "line":line_buffer})
			#line_buffer=[]
			append_line.call()
	#print(text_buffer)
	return {"script":dictar, "labels":labels}

func _ready():
	if file_path!="":
		var file=FileAccess.open(file_path, FileAccess.READ)
		t=file.get_as_text()
	var p=parse(t)
	var commands=p["script"]
	print(p["labels"])
	script_labels=p["labels"]
	script_play=p["script"]
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
		if (color_dict[color]!=WhatSelected.color):
			d["cipher"]=true
			var app_text=""
			for i in range(len(text)):
				#app_text+="#"
				#app_text+="#@!&"[randi_range(0,3)]
				var col_dif=(color_dict[color]-WhatSelected.color)
				if (text[i]==' '):
					app_text+=' '
					continue
				var buf=(text[i]).to_utf8_buffer()
				var bif=buf[0]
				for k in range(1, len(buf)):
					bif+=buf[k]+int(col_dif.r*1+col_dif.g*2+col_dif.b*3)
					#print(type_string(typeof(bif)))
				#app_text+=String.chr((bif%4+35))
				app_text+=String.chr( bif )
			d["text"]=app_text
	if (color=="none" or color_dict[color]==WhatSelected.color):
		d["text"]=text
	return d
	
var cur_command:int=-1
var cur_text_pos:int=-1
var cur_time=0
var dis_text=""
var cur_tween:Tween
var speed_coef=0.2
func set_speed(speed:float):
	speed_coef=1/speed
#var seen_char=0
#var all_char=0
func exec_line():
	var cur=script_play[script_pickup]
	text=str(cur)
	print(cur_command, "  ", cur_text_pos)
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
				if (cur_text_pos==len(txt)):
					cur_tween.kill()
					dis_text+=app_text
					cur_text_pos=-1
					cur_command+=1
		else:
			text=dis_text	
	if (cur["type"]=="jump"):
		turn_to_line(cur["to"])
		#script_pickup=script_labels[cur["to"]]

func _process(delta):
	exec_line()
	pass
