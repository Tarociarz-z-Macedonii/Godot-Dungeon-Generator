extends Node2D

var cords: Vector2
var minimap_displayer

func _ready() -> void:
	minimap_displayer = get_node("/root/Place/RoomGenerator/MinimapDisplayer")

func on_hitbox_enter():
	if minimap_displayer.currnet_room_cords != cords:
		minimap_displayer.currnet_room_cords = cords
		if minimap_displayer.minimap_room_types[cords] == 'unexplored':
			print('Entered First Time')
		minimap_displayer.on_room_change(cords)
		
