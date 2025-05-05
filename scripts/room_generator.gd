extends Node2D

var room_px_width: int = 30
var room_px_height: int = 22
var room_width: int = room_px_width * 16
var room_height: int =  room_px_height * 16
var offset_x: int = 4 * room_width
var offset_y: int = 4 * room_height 

var room_cords = []
var rooms = {} 
var end_rooms = []
var rooms_to_create_queue = []
var max_num_rooms: int = 20
var min_num_rooms: int  = 30
var chance_for_room: float  = 0.5
var max_neighbours: int  = 1
var room_level: int  = 1
var sum_of_rooms = 0

var finished_creating := false
var minimap_displayer
var room = preload("res://scenes/prefabs/room.tscn")

func _ready() -> void:
	minimap_displayer = get_node("MinimapDisplayer")
	position = Vector2(-offset_x, -offset_y)
	
	_create_room(Vector2(4,4))
	_try_to_add_to_neighbours(Vector2(4,4)) 

func _process(_delta: float) -> void:
	if len(rooms_to_create_queue) > 0:
		var cords = rooms_to_create_queue.pop_front()
		_try_to_add_to_neighbours(cords) 
		return
		
	on_finished_creating()	

func _create_room(cords):
	var temp_room = room.instantiate()
	rooms[cords] = temp_room
	add_child(temp_room)

func _try_to_add_to_neighbours(cords):
	var added_neighbours = 0
	if len(rooms) < max_num_rooms:
		if cords.y - 1 >= 0:
			if _try_to_add_to_neighbour(Vector2(cords.x, cords.y - 1)):
				added_neighbours += 1
		if cords.y + 1 <= 9:
			if _try_to_add_to_neighbour(Vector2(cords.x, cords.y + 1)):
				added_neighbours += 1
		if cords.x - 1 >= 0:
			if _try_to_add_to_neighbour(Vector2(cords.x - 1, cords.y )):
				added_neighbours += 1
		if cords.x + 1 <= 9:
			if _try_to_add_to_neighbour(Vector2(cords.x + 1, cords.y )):
				added_neighbours += 1
	if added_neighbours == 0:
		end_rooms.push_back(cords)

func _try_to_add_to_neighbour(cords):
	if randf_range(0,1.0) < chance_for_room and not is_room_existing(cords) and _count_neighbours(cords) <= max_neighbours:
		rooms_to_create_queue.push_back(cords)
		_create_room(cords)
		return true
	return false

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
	if not finished_creating:
		finished_creating = true
		#print(len(rooms))
		if len(rooms) < min_num_rooms or len(end_rooms) < 2:
			restart()
			return
		_assign_final_room_values()
		minimap_displayer.display_minimap(rooms)

func restart():
	sum_of_rooms += len(rooms)
	print('restarted: ' + str(sum_of_rooms))
	rooms.clear()
	end_rooms.clear()
	_create_room(Vector2(4,4))
	_try_to_add_to_neighbours(Vector2(4,4)) 
	finished_creating = false
	
func _assign_final_room_values():
	for key in rooms:
		rooms[key].cords = key
		rooms[key].status = "unexplored"
		rooms[key].type = Enums.RoomType.ENEMY
		rooms[key].level = room_level
		rooms[key].position = Vector2(key.x * room_width, key.y * room_height) 
	print("EndRooms: " + str(len(end_rooms)))
	rooms[end_rooms.pop_back()].type = Enums.RoomType.BOSS
	rooms[end_rooms.pop_back()].type = Enums.RoomType.CHEST
	for key in rooms:
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
