extends Node2D

var room_px_width = 30
var room_px_height = 22
var room_width: int = room_px_width * 16
var room_height: int =  room_px_height * 16
var offset_x = 4 * room_width
var offset_y = 4 * room_height 

var rooms_created = [] #
var end_rooms = [] 
var rooms_to_create_queue = []
var max_num_rooms = 20
var min_num_rooms = 19
var chance_for_room = .5

var finished_creating = false
var room_instantiator
var minimap_displayer
func _ready() -> void:
	position = Vector2(-offset_x, -offset_y)
	_try_to_add_to_neighbours(Vector2(4,4)) 
	rooms_created.append(Vector2(4,4))
	room_instantiator = get_node("RoomInstantiator")
	minimap_displayer = get_node("MinimapDisplayer")
	
func _process(_delta: float) -> void:
	if len(rooms_to_create_queue) > 0 and len(rooms_created) < max_num_rooms:
		var cords = rooms_to_create_queue.pop_front()
		_try_to_add_to_neighbours(cords) 
		return
		
	on_finished_creating()	

func on_finished_creating():
	if not finished_creating:
		finished_creating = true
		print(len(rooms_created))
		if len(rooms_created) <= min_num_rooms:
			restart()
			return
		room_instantiator.instantiate_rooms(rooms_created)
		minimap_displayer.display_minimap(rooms_created)

func restart():
	print('restarted')
	rooms_created.clear()
	end_rooms.clear()
	_try_to_add_to_neighbours(Vector2(4,4))
	rooms_created.append(Vector2(4,4))
	finished_creating = false

func is_room_existing(cords):
	for i in range(len(rooms_created)):
		if cords == rooms_created[i]:
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
	
func _try_to_add_to_neighbour(cords):
	if randf_range(0,1.0) < chance_for_room and not is_room_existing(cords) and _count_neighbours(cords) < 2:
		rooms_to_create_queue.push_back(cords)
		rooms_created.append(cords)
		return true
	return false

func _try_to_add_to_neighbours(cords):
	var added_neighbours = 0
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
		end_rooms.append(cords)
		 
	
