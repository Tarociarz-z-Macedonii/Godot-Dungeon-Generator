extends Node

var enemies_1 = [] # tier 1 Enemies etc.
var chests_1 = []
var bosses_1 = []

func _ready() -> void:
	_assign_interiors()

func _assign_interiors() -> void:
	enemies_1.append(load('res://scenes/prefabs/rooms/room1.tscn'))
	enemies_1.append(load('res://scenes/prefabs/rooms/room2.tscn'))
	chests_1.append(load('res://scenes/prefabs/rooms/chest1.tscn'))
	bosses_1.append(load('res://scenes/prefabs/rooms/boss_1.tscn'))
		
func pick_interior_array(type, level):
	match type:
		Enums.RoomType.ENEMY:
			match level:
				1:
					return enemies_1
		Enums.RoomType.CHEST:
			match level:
				1:
					return chests_1
		Enums.RoomType.BOSS:
			match level:
				1:
					return bosses_1
					
func pick_random(array):
	var array_len = len(array) - 1
	var rand_index = randi_range(0, array_len)
	return array[rand_index]
