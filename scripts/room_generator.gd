extends Node2D

var room_px_width: int = 30
var room_px_height: int = 22
var room_width: int = room_px_width * 16
var room_height: int =  room_px_height * 16
var offset_x: int = 4 * room_width
var offset_y: int = 4 * room_height 

var rooms = {} 
var end_rooms = []
var cords_to_create_neighbours = []
var max_num_rooms: int = 20 #inclusive
var min_num_rooms: int  = 20 #inclusive
var chance_for_room: float  = 0.5
var max_neighbours: int  = 1
var room_level: int  = 1
var added_neighbours = 0

var finished_creating := false
var minimap_displayer
var room = preload("res://scenes/prefabs/room.tscn")

func _ready() -> void:
	minimap_displayer = get_node("MinimapDisplayer")
	position = Vector2(-offset_x, -offset_y)
	
	_create_room(Vector2(4,4))
	cords_to_create_neighbours.append(Vector2(4,4))

func _process(_delta: float) -> void:
	if len(cords_to_create_neighbours) > 0:
		var cords = cords_to_create_neighbours.pop_front()
		_try_to_add_to_neighbours(cords) 
		return
		
	if not finished_creating:
		on_finished_creating()	

func _create_room(cords):
	var temp_room = room.instantiate()
	rooms[cords] = temp_room
	add_child(temp_room)

func _try_to_add_to_neighbours(cords):
	print(cords)
	print(finished_creating)
	added_neighbours = 0
	if cords.y - 1 >= 0:
		_try_to_add_to_neighbour(Vector2(cords.x, cords.y - 1))
	if cords.y + 1 <= 9:
		_try_to_add_to_neighbour(Vector2(cords.x, cords.y + 1))
	if cords.x - 1 >= 0:
		_try_to_add_to_neighbour(Vector2(cords.x - 1, cords.y ))
	if cords.x + 1 <= 9:
		_try_to_add_to_neighbour(Vector2(cords.x + 1, cords.y ))
	if added_neighbours == 0:
		end_rooms.push_back(cords)

func _try_to_add_to_neighbour(cords):
	if (randf_range(0,1.0) < chance_for_room 
	and not is_room_existing(cords) 
	and _count_neighbours(cords) <= max_neighbours 
	and len(rooms) < max_num_rooms):
		cords_to_create_neighbours.push_back(cords)
		_create_room(cords)
		added_neighbours += 1

func is_room_existing(cords):
	for key in rooms:
		if cords == key:
			return true
	return false

func _count_neighbours(cords):
	var neighbours = 0
	if is_room_existing(Vector2(cords.x, cords.y - 1)):
		neighbours += 1
	if is_room_existing(Vector2(cords.x, cords.y + 1)):
		neighbours += 1
	if is_room_existing(Vector2(cords.x - 1, cords.y )):
		neighbours += 1
	if is_room_existing(Vector2(cords.x + 1, cords.y )):
		neighbours += 1
	return neighbours

func on_finished_creating():
	if len(rooms) < min_num_rooms or len(end_rooms) < 2:
		restart()
		return
	finished_creating = true
	_assign_final_room_values()
	minimap_displayer.display_minimap(rooms)

func restart():
	print("restarted: " + str(len(rooms)))
	rooms.clear()
	end_rooms.clear()
	_create_room(Vector2(4,4))
	cords_to_create_neighbours.append(Vector2(4,4))
	
func _assign_final_room_values():
	print("Rooms: " + str(len(rooms)) + " EndRooms: " + str(len(end_rooms)))
	
	for key in rooms:
		rooms[key].type = Enums.RoomType.ENEMY
	rooms[end_rooms.pop_back()].type = Enums.RoomType.BOSS
	rooms[end_rooms.pop_back()].type = Enums.RoomType.CHEST
	
	for key in rooms:
		rooms[key].cords = key
		rooms[key].status = "unexplored"
		rooms[key].level = room_level
		rooms[key].position = Vector2(key.x * room_width, key.y * room_height) 
		rooms[key].instantiate_interior()
		_assign_openings(key, rooms[key])
		rooms[key].make_corridors()

func _assign_openings(cords, temp_room):
	if is_room_existing(Vector2(cords.x + 1, cords.y)):
		temp_room.is_right_open = true	
	if is_room_existing(Vector2(cords.x - 1, cords.y )):
		temp_room.is_left_open = true
	if is_room_existing(Vector2(cords.x, cords.y - 1)):
		temp_room.is_top_open = true
	if is_room_existing(Vector2(cords.x, cords.y + 1)):
		temp_room.is_bottom_open = true
