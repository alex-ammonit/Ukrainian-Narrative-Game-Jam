extends RichTextLabel

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
	var p=parse(t)
	var commands=p["script"]
	print(p["labels"])
	script_labels=p["labels"]
	script_play=p["script"]
	script_pickup=0
	#print(p, len(p))
	for i in len(commands):
		print(i,":", commands[i])

func _input(event):
	if (script_pickup==-1):
		return
	if (event is InputEventKey and event.is_pressed()):
		#print(event.as_text_keycode())
		if (event.as_text_keycode()=="Left"):
			#print("L")
			script_pickup=clamp(script_pickup-1, 0, len(script_play)-1)
		if (event.as_text_keycode()=="Right"):
			script_pickup=clamp(script_pickup+1, 0, len(script_play)-1)
			#script_pickup+=1
			#print("R")

func _process(delta):
	if (script_pickup==-1):
		return
	var cur=script_play[script_pickup]
	#print(cur)
	
	text=str(cur)
	if (cur["type"]=="line"):
		var line=cur["line"]
		#text=str(line)
		text=""
		for l in line:
			#print(l["type"])
			if l["type"]=="text":
				var app_text=""
				var color=l["color"]
				var txt=l["text"]
				if (color!="none"):
					app_text="[color=#"+color_dict[color].to_html()+"]"
				if (color!="none" and color_dict[color]!=WhatSelected.color):
					#app_text+="#"
					for i in range(len(txt)):
						#app_text+="#"
						#app_text+="#@!&"[randi_range(0,3)]
						if (txt[i]==' '):
							app_text+=' '
							continue
						var buf=(txt[i]).to_utf8_buffer()
						var bif=buf[0]
						for k in range(1, len(buf)):
							bif+=buf[k]
						app_text+=String.chr((bif%4+35))
				else:
					app_text+=txt
				if (l["color"]!="none"):
					app_text+="[/color]"
				text+=app_text
	if (cur["type"]=="jump"):
		script_pickup=script_labels[cur["to"]]
	#print(parse(t))
	#var elements=parse(t)
	#var new_text=""
	#var activeColor="none"
	'''for el in elements:
		if el["type"]=="control":
			if (el["data"]=="none"):
				activeColor="none"
			if (color_dict.has(el["data"])):
				#new_text=new_text+"[color=#"+color_dict[el["data"]].to_html()+"]"
				activeColor=el["data"]
		if el["type"]=="text":
			if (activeColor!="none" and color_dict[activeColor]==WhatSelected.color):
				new_text=new_text+"[color=#"+color_dict[activeColor].to_html()+"]"
				new_text=new_text+el["text"]
				new_text=new_text+"[/color]"
			elif (activeColor=="none"):
				#new_text=new_text+"[/color]"
				new_text=new_text+el["text"]
			else:
				new_text=new_text+"[color=#"+color_dict[activeColor].to_html()+"]"
				new_text=new_text+( String("#") )
				new_text=new_text+"[/color]"
			#if el["data"]=="red":'''
	#text=new_text
	#pass
