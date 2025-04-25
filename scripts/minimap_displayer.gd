extends Node2D

var room_icon = preload('res://scenes/prefabs/room_minimap.tscn')
var current_room_icon = preload('res://sprites/current_room_icon.png')
var visited_room_icon = preload('res://sprites/room_discovered.png')
var room_width = 30
var room_height = 22
var offset_x = 2400 - 240
var offset_y = 1760.0 + 176
var minimap_rooms = {}
var minimap_created = false
var last_current_cords 
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
		temp_icon.position = Vector2(room_cords.x * room_width, room_cords.y * room_height) 
	minimap_created = true
		
func _get_current_room_cords():
	return Vector2( int((player.position.x + offset_x) / (room_width*16)), int((player.position.y + offset_y) / (room_height*16)))

func _update_current_room():
	var current_cords = _get_current_room_cords()
	print( (player.position.x + offset_x) / (room_width*16)  )
	if minimap_rooms.get(current_cords) and last_current_cords != current_cords:
		for key in minimap_rooms:
			minimap_rooms[key].texture = visited_room_icon
		last_current_cords = current_cords
		minimap_rooms[current_cords].texture = current_room_icon
