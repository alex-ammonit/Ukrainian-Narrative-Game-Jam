extends RichTextLabel

@export_multiline var t:String
@export var color_dict:Dictionary[String, Color]

func parse(string:String):
	print(string)
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
		if (s=='<') or (s=='>'):
			shall_parse=true
		if (shall_parse==false):
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
	'''var xml_parser=XMLParser.new()
	xml_parser.open_buffer(string.to_utf8_buffer())
	while xml_parser.read()!=ERR_FILE_EOF:
		#print(xml_parser.get_node_type())
		match xml_parser.get_node_type():
			XMLParser.NODE_ELEMENT:
				print(xml_parser.get_node_name())
				dictar.append({"type":"node", "name":xml_parser.get_node_name() })
			XMLParser.NODE_TEXT:
				print(xml_parser.get_node_data())
				dictar.append({"type":"text", "text":xml_parser.get_node_data()})'''
	#for s in string:
	#	print(s)
	return dictar
	pass

func _process(delta):
	print(parse(t))
	var elements=parse(t)
	var new_text=""
	var activeColor="none"
	for el in elements:
		if el["type"]=="control":
			if (el["data"]=="none"):
				activeColor="none"
			if (color_dict.has(el["data"])):
				new_text=new_text+"[color=#"+color_dict[el["data"]].to_html()+"]"
				activeColor=el["data"]
		if el["type"]=="text":
			if (color_dict[activeColor]==WhatSelected.color or activeColor=="none"):
				new_text=new_text+el["text"]
			else:
				new_text=new_text+( String("#") )
			#if el["data"]=="red":
	text=new_text
	#pass
	'''var xmlParser=XMLParser.new()
	xmlParser.open_buffer( t.to_utf8_buffer() )
	#print(bytes_to_var(var_to_bytes(t)))
	while xmlParser.read()!= ERR_FILE_EOF:
		print("AAA")
		print(xmlParser.get_node_type())
		#print(xmlParser.get_node_data())
		if xmlParser.get_node_type()==XMLParser.NODE_ELEMENT:
			print("BBB")
			var node_name=xmlParser.get_node_name()
			var attribute_dict={}
			for idx in xmlParser.get_attribute_count():
				attribute_dict[xmlParser.get_attribute_name(idx)]=xmlParser.get_attribute_value(idx)
			print(attribute_dict)
			#print(node_name)'''
