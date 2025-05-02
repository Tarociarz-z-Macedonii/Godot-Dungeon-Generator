extends Node2D

var room = preload("res://scenes/prefabs/room.tscn")
var room_prefab_list = []
var room_list = {}
var room_generator 


func _ready() -> void:
	room_generator = get_node('../')
	_append_rooms()

func _append_rooms() -> void:
	room_prefab_list.append(load('res://scenes/prefabs/rooms/room1.tscn'))
	room_prefab_list.append(load('res://scenes/prefabs/rooms/room2.tscn'))

func _pick_random_room():
	var rand = randi_range(0,len(room_prefab_list) - 1)
	print(rand)
	return room_prefab_list[rand]

func instantiate_rooms(rooms_created):
	for room_cords in rooms_created:
		var temp_room_walls = room.instantiate()
		var temp_room = _pick_random_room().instantiate()
		add_child(temp_room_walls)
		add_child(temp_room)
		temp_room_walls.position = Vector2(room_cords.x * room_generator.room_width, room_cords.y * room_generator.room_height) 
		temp_room_walls.cords = room_cords
		room_list[room_cords] = temp_room_walls
		temp_room.position = Vector2(room_cords.x * room_generator.room_width, room_cords.y * room_generator.room_height) 
		_make_doors(room_cords, temp_room_walls)

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
