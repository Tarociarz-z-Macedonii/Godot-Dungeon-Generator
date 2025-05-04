extends Node

var enemy1 = []
var chest1 = []

func _ready() -> void:
	_assign_interiors()

func _assign_interiors() -> void:
	enemy1.append(load('res://scenes/prefabs/rooms/room1.tscn'))
	enemy1.append(load('res://scenes/prefabs/rooms/room2.tscn'))
	chest1.append(load('res://scenes/prefabs/rooms/chest1.tscn'))
		
func pick_interior_array(type, level):
	match type:
		Enums.RoomType.ENEMY:
			match level:
				1:
					return enemy1
		Enums.RoomType.CHEST:
			match level:
				1:
					return chest1
					
func pick_random(array):
	print(len(array))
	var array_len = len(array) - 1
	var rand_index = randi_range(0, array_len)
	return array[rand_index]
