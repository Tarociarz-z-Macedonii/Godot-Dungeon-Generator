extends Node2D

var room_icon = preload('res://scenes/prefabs/room_minimap.tscn')
var room_width = 70
var room_height = 50
var room_generator
var canvas
func _ready() -> void:
	room_generator = get_node('../')
	canvas = get_node('/root/Place/CanvasLayer')
func draw_minimap(rooms_created):
	for room_cords in rooms_created:
		var temp_icon = room_icon.instantiate()
		canvas.add_child(temp_icon)
		temp_icon.position = Vector2(room_generator.cords_to_x(room_cords) * room_width, room_generator.cords_to_y(room_cords) * room_height) 
