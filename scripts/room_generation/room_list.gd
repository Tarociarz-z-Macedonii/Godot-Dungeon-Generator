extends Node

var starter_room
var enemies_1 = [] # tier 1 Enemies etc.
var chests_1 = []
var bosses_1 = []

func _ready() -> void:
	_assign_interiors()

func _assign_interiors() -> void:
	starter_room = load('res://scenes/prefabs/rooms/chest/level_1/four_rocks.tscn')
	enemies_1.append(load('res://scenes/prefabs/rooms/enemy/level_1/knight_jump_walls.tscn'))
	enemies_1.append(load('res://scenes/prefabs/rooms/enemy/level_1/waters_and_wall.tscn'))
	chests_1.append(load('res://scenes/prefabs/rooms/chest/level_1/four_rocks.tscn'))
	bosses_1.append(load('res://scenes/prefabs/rooms/boss/level_1/godoteus_maximus.tscn'))
		
func pick_interior(type, level):
	match type:
		Enums.RoomType.START:
			return starter_room
		Enums.RoomType.ENEMY:
			match level:
				1:
					return enemies_1.pick_random()
		Enums.RoomType.CHEST:
			match level:
				1:
					return chests_1.pick_random()
		Enums.RoomType.BOSS:
			match level:
				1:
					return bosses_1.pick_random()
