@tool
extends Path2D

@export var colors: Array[Color]
'''@export_tool_button("generate polygons")
var generate_pols:
	get: return func():
			print("AAA")
			generate_polygons()'''


func _ready():
	generate_polygons()
	pass


func generate_polygons():
	var col_len=len(colors)
	var baked_points=curve.get_baked_points()
	var baked_len=len(baked_points)
	var baked_div=baked_len/col_len
	#var baked_length=curve.get_baked_length()
	#var baked_interval=curve.bake_interval
	#var bak=baked_length/baked_interval
	#print(len(baked_points))
	for i in col_len:
		var pol=Polygon2D.new()
		var area=Area2D.new()
		var pol_col=CollisionPolygon2D.new()
		pol.add_child(area)
		area.add_child(pol_col)
		pol.color=colors[i]
		var start_pos=baked_points[baked_div*i]
		var end_pos=baked_points[baked_div*(i+1)]
		pol.position=start_pos
		#pol.position=baked_points[baked_div*i]
		#print(curve.get_closest_point(baked_points[baked_div*i]))
		#pol.position=baked_points[ bak*i ]
		var points: Array[Vector2]
		for k in baked_div:
			points.append(baked_points[baked_div*i+k]-start_pos)
		for k in baked_div:
			points.append(baked_points[baked_div*(i+1)-k]-start_pos+Vector2(20, 0))
		#points.append(start_pos+Vector2(-20, 0))
		#points.append(start_pos+Vector2(20, 0))
		#points.append(end_pos+Vector2(-20, 0))
		#points.append(end_pos+Vector2(20, 0))
		#points.append( Vector2(-20, -20) )
		#points.append( Vector2(20, -20) )
		#points.append( Vector2(20, 20) )
		#points.append( Vector2(-20, 20) )
		pol.polygon=points
		pol_col.polygon=points
		add_child(pol)
	'''var path_follow=PathFollow2D.new()
	add_child(path_follow)
	var col_len=len(colors)
	for i in col_len:
		print(i, "  ", col_len)
		var percentage=(float(i))/(float(col_len))
		var pol=Polygon2D.new()
		var area=Area2D.new()
		var pol_col=CollisionPolygon2D.new()
		pol.add_child(area)
		area.add_child(pol_col)
		pol.color=colors[i]
		path_follow.progress_ratio=percentage
		#pol.position=curve.get_point_position(0)
		pol.position=path_follow.position
		var points: Array[Vector2]
		points.append( Vector2(-20, -20) )
		points.append( Vector2(20, -20) )
		points.append( Vector2(20, 20) )
		points.append( Vector2(-20, 20) )
		pol.polygon=points
		pol_col.polygon=points
		add_child(pol)'''
