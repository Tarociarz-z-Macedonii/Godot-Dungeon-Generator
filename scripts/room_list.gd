extends Node

var enemy1 = []
var chest1 = []

var interiors = {
	Enums.RoomType.ENEMY1 : enemy1,
	Enums.RoomType.CHEST1 : chest1,
}

func _ready() -> void:
	_assign_interiors()

func _assign_interiors() -> void:
	enemy1.append(load('res://scenes/prefabs/rooms/room1.tscn'))
	enemy1.append(load('res://scenes/prefabs/rooms/room2.tscn'))
	chest1.append(load('res://scenes/prefabs/rooms/chest1.tscn'))
		
func pick_random(array):
	print(len(array))
	var array_len = len(array) - 1
	var rand_index = randi_range(0, array_len)
	return array[rand_index]
