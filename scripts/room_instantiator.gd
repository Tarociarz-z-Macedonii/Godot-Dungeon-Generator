extends Node2D

var room = preload("res://scenes/prefabs/room.tscn")
var room_generator 

func _ready() -> void:
	room_generator = get_node('../')

func instantiate_rooms(rooms_created):
	for room_cords in rooms_created:
		var temp_room = room.instantiate()
		add_child(temp_room)
		temp_room.position = Vector2(room_cords.x * room_generator.room_width, room_cords.y * room_generator.room_height) 
		_make_doors(room_cords, temp_room)

func _make_doors(cords, temp_room):
	if room_generator.is_room_existing(Vector2(cords.x + 1, cords.y)):
		temp_room.get_node('WallRightClosed').enabled = false
	else: 
		temp_room.get_node('WallRightOpen').enabled = false
		
	if room_generator.is_room_existing(Vector2(cords.x - 1, cords.y )):
		temp_room.get_node('WallLeftClosed').enabled = false
	else: 
		temp_room.get_node('WallLeftOpen').enabled = false
		
	if room_generator.is_room_existing(Vector2(cords.x, cords.y - 1)):
		temp_room.get_node('WallTopClosed').enabled = false
	else: 
		temp_room.get_node('WallTopOpen').enabled = false
		
	if room_generator.is_room_existing(Vector2(cords.x, cords.y + 1)):
		temp_room.get_node('WallBottomClosed').enabled = false
	else: 
		temp_room.get_node('WallBottomOpen').enabled = false
