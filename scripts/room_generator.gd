extends Node2D

var room_prefab = preload('res://scenes/prefabs/room.tscn')
var room_width: int = 500
var room_height: int =  350
var rooms_created = [] #
var end_rooms = [] 
var room_prefabs = []
var rooms_to_create_queue = []
var max_num_rooms = 24
var min_num_rooms = 20
var chance_for_room = 0.7

var finished_creating = false

func _ready() -> void:
	_create(43)
	rooms_created.append(43)
	
func _process(_delta: float) -> void:
	if len(rooms_to_create_queue) > 0 and len(rooms_created) < max_num_rooms:
		var cords = rooms_to_create_queue.pop_front()
		_create(cords)
		return
		
	on_finished_creating()	

func on_finished_creating():
	if not finished_creating:
		finished_creating = true
		print(len(rooms_created))
		if len(rooms_created) <= min_num_rooms:
			restart()

func restart():
	print('restarted')
	rooms_created.clear()
	end_rooms.clear()
	for room in room_prefabs:
		room.queue_free()
	room_prefabs.clear()
	_create(43)
	rooms_created.append(43)
	finished_creating = false

func cords_to_x(cords):
	return int(cords/10)
	
func cords_to_y(cords):
	return cords%10

func _is_room_existing(cords):
	for i in range(len(rooms_created)):
		if cords == rooms_created[i]:
			return true
	return false

func _count_neighbours(cords):
	var neighbours = 0
	if _is_room_existing(cords-1):
		neighbours += 1
	if _is_room_existing(cords+1):
		neighbours += 1
	if _is_room_existing(cords-10):
		neighbours += 1
	if _is_room_existing(cords+10):
		neighbours += 1
	return neighbours
	
func _try_to_add_to_neighbour(cords):
	if randf_range(0,1.0) < chance_for_room and not _is_room_existing(cords - 10) and _count_neighbours(cords) < 2:
		rooms_to_create_queue.push_back(cords)
		rooms_created.append(cords)
		return true
	return false

func _try_to_add_to_neighbours(cords):
	var added_neighbours = 0
	if cords - 10 >= 0:
		if _try_to_add_to_neighbour(cords - 10):
			added_neighbours += 1
	if cords + 10 <= 99:
		if _try_to_add_to_neighbour(cords + 10):
			added_neighbours += 1
	if cords_to_y(cords) > cords_to_y(cords - 1) and cords - 1 >= 0:
		if _try_to_add_to_neighbour(cords -1 ):
			added_neighbours += 1
	if cords_to_y(cords) < cords_to_y(cords + 1) and cords + 1 <= 99:
		if _try_to_add_to_neighbour(cords + 1):
			added_neighbours += 1
	if added_neighbours == 0:
		end_rooms.append(cords)
	#print('created' + str(len(rooms_created)))
		 
	
func _create(cords):
	var temp_room = room_prefab.instantiate() 
	add_child(temp_room)
	room_prefabs.append(temp_room)
	temp_room.position = Vector2( cords_to_x(cords) * room_width, cords_to_y(cords) * room_height)
	_try_to_add_to_neighbours(cords) 
