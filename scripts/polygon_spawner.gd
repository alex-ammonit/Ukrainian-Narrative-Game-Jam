#@tool
extends Path2D

@export var clockhand:Node

@export var colors: Array[Color]
'''@export_tool_button("generate polygons")
var generate_pols:
	get: return func():
			print("AAA")
			generate_polygons()'''


func _ready():
	generate_polygons()
	pass

func points_to_polygon(in_points, color):
	var pol=Polygon2D.new()
	var area=Area2D.new()
	var pol_col=CollisionPolygon2D.new()
	pol.add_child(area)
	area.add_child(pol_col)
	pol.color=color
	var start_pos=in_points[0]
	var end_pos=in_points[-1]
	pol.position=start_pos
	var points: Array[Vector2]
	for k in len(in_points):
		points.append(in_points[k]-start_pos)
	for k in len(in_points):
		points.append(in_points[len(in_points)-1-k]-start_pos+Vector2(20,0))
	#var start_pos=baked_points[baked_div*i]
	#var end_pos=baked_points[baked_div*(i+1)]
	#pol.position=start_pos
	#var points: Array[Vector2]
	#for k in baked_div:
	#	points.append(baked_points[baked_div*i+k]-start_pos)
	#for k in baked_div:
	#	points.append(baked_points[baked_div*(i+1)-k]-start_pos+Vector2(20, 0))
		
	pol.polygon=points
	pol_col.polygon=points
	return pol

func clockhand_from_angle(angle):
	var new_point=clockhand.global_position.from_angle( angle )*80
	new_point=to_local(new_point+clockhand.global_position+clockhand.pivot_offset)
	return new_point

func generate_polygons():
	curve.clear_points()
	for i in range(10, -20, -5):
		print(i)
		var new_point=clockhand_from_angle(float(i)/10)
		#var new_point=clockhand.global_position.from_angle( float(i)/10 )*80
		#new_point=to_local(new_point+clockhand.global_position+clockhand.pivot_offset)
		print(new_point)
		curve.add_point(new_point)
		#print(clockhand.global_position.from_angle( float(i)/10 )*10)
		#curve.add_point( clockhand.global_position.from_angle( float(i)/10 )*10 )
	
	var col_len=len(colors)
	var baked_points=curve.get_baked_points()
	var baked_len=len(baked_points)
	var baked_div=baked_len/col_len
	#var baked_length=curve.get_baked_length()
	#var baked_interval=curve.bake_interval
	#var bak=baked_length/baked_interval
	#print(len(baked_points))
	for i in col_len:
		var pol=points_to_polygon(baked_points.slice(baked_div*i, baked_div*(i+1)+1), colors[i])
		add_child(pol)
