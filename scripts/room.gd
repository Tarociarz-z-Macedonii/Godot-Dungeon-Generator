extends Node2D

var cords: Vector2
var minimap_displayer
var is_left_open := false
var is_right_open := false
var is_top_open := false
var is_bottom_open := false 

var block_left 
var block_right
var block_bottom
var block_top

func _ready() -> void:
	minimap_displayer = get_node("/root/Place/RoomGenerator/MinimapDisplayer")
	block_left = get_node('BlockLeft')
	block_right = get_node('BlockRight')
	block_bottom = get_node('BlockBottom')
	block_top = get_node('BlockTop')
	
func block_doors():
	block_left.enabled = is_left_open
	block_right.enabled = is_right_open
	block_bottom.enabled = is_bottom_open
	block_top.enabled = is_top_open

func on_hitbox_enter():
	if minimap_displayer.currnet_room_cords != cords:
		minimap_displayer.currnet_room_cords = cords
		if minimap_displayer.minimap_room_types[cords] == 'unexplored':
			print('Entered First Time')
			block_doors()
		minimap_displayer.on_room_change(cords)
		
