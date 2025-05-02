extends Node2D

var room_icon = preload('res://scenes/prefabs/room_minimap.tscn')
var current_icon = preload('res://sprites/current_room_icon.png')
var explored_icon = preload('res://sprites/room_discovered.png')
var unexplored_icon = preload('res://sprites/unexplored.png')

var minimap_offset_x 
var minimap_offset_y 

var minimap_rooms = {}
var minimap_room_types = {}
var minimap_created = false
var last_current_cords := Vector2(4,4)
var currnet_room_cords := Vector2(4,4)
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
	
func display_minimap(rooms_created):
	for cords in rooms_created:
		minimap_room_types[cords] = 'unseen'
		var temp_icon = room_icon.instantiate()
		canvas.add_child(temp_icon)
		minimap_rooms[cords] = temp_icon
		temp_icon.position = Vector2(cords.x * room_generator.room_px_width, cords.y * room_generator.room_px_height) 
	_update_room_types(Vector2(4,4),Vector2(4,4))
	_update_room_icons()
	minimap_created = true

func on_room_change(current_cords):
	_update_room_types(current_cords, last_current_cords)
	_update_room_icons()
	last_current_cords = current_cords

func _give_room_type_unexplored(cords):
	if room_generator.is_room_existing(cords):
		if minimap_room_types[cords] == 'unseen': 
			minimap_room_types[cords] = 'unexplored'

func _update_room_types(current_cords, last_current_cords):
	_give_room_type_unexplored(Vector2(current_cords.x - 1,current_cords.y))
	_give_room_type_unexplored(Vector2(current_cords.x + 1,current_cords.y))
	_give_room_type_unexplored(Vector2(current_cords.x,current_cords.y - 1))
	_give_room_type_unexplored(Vector2(current_cords.x,current_cords.y + 1))
	minimap_room_types[last_current_cords] = 'explored'
	minimap_room_types[current_cords] = 'current'

func _update_room_icons():
	for key in minimap_rooms:
		if minimap_room_types[key] == 'unseen':
			minimap_rooms[key].visible = false
		else:
			minimap_rooms[key].visible = true
		if minimap_room_types[key] == 'unexplored':
			minimap_rooms[key].texture = unexplored_icon
		if minimap_room_types[key] == 'explored':
			minimap_rooms[key].texture = explored_icon
		if minimap_room_types[key] == 'current':
			minimap_rooms[key].texture = current_icon
