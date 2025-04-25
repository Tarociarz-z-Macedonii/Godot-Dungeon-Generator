extends Node2D

var room_icon = preload('res://scenes/prefabs/room_minimap.tscn')
var room_width = 30
var room_height = 22
var offset_x = 1920.0
var offset_y = 1280
var minimap_rooms = {}
var minimap_created = false
var room_generator
var canvas
var minimap_background
var player
func _ready() -> void:
	room_generator = get_node('../')
	canvas = get_node('/root/Place/CanvasLayer')
	player = get_node('/root/Place/Player')
	minimap_background = canvas.get_node('MinimapBackground')
	minimap_background.size = Vector2(30*10,22*10)
	
func _process(delta: float) -> void:
	if minimap_created:
		_update_current_room()
	
func draw_minimap(rooms_created):
	for room_cords in rooms_created:
		var temp_icon = room_icon.instantiate()
		canvas.add_child(temp_icon)
		minimap_rooms[room_cords] = temp_icon
		temp_icon.position = Vector2(room_generator.cords_to_x(room_cords) * room_width, room_generator.cords_to_y(room_cords) * room_height) 
	minimap_created = true
		
func _get_current_room_cords():
	return int((player.position.x + offset_x)/ (room_width*16)) + int((player.position.y + offset_y) / (room_height*16)) * 10

func _update_current_room():
	print(_get_current_room_cords())
	#minimap_rooms[_get_current_room_cords()].visible = false
