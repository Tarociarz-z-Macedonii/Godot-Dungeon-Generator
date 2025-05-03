extends Node2D

var cords: Vector2
var status: String
var interior: PackedScene
var walls: PackedScene = preload("res://scenes/prefabs/room_walls.tscn")
var wall_instance: Node2D
var is_left_open := false
var is_right_open := false
var is_top_open := false
var is_bottom_open := false 

var block_left 
var block_right
var block_bottom
var block_top

var room_generator
var minimap_displayer

func _ready() -> void:
	room_generator = get_node("/root/Place/RoomGenerator")
	minimap_displayer = get_node("/root/Place/RoomGenerator/MinimapDisplayer")

	
func block_doors():
	block_left.enabled = is_left_open
	block_right.enabled = is_right_open
	block_bottom.enabled = is_bottom_open
	block_top.enabled = is_top_open

func instantiate_interior():
	var temp_interior = interior.instantiate()
	wall_instance = walls.instantiate()
	add_child(temp_interior)
	add_child(wall_instance)
	
func make_corridors():
	wall_instance.get_node("WallLeftOpen").enabled = is_left_open
	wall_instance.get_node("WallLeftClose").enabled = !is_left_open
	wall_instance.get_node("WallRightOpen").enabled = is_right_open
	wall_instance.get_node("WallRightClose").enabled = !is_right_open
	wall_instance.get_node("WallTopOpen").enabled = is_top_open
	wall_instance.get_node("WallTopClose").enabled = !is_top_open
	wall_instance.get_node("WallBottomOpen").enabled = is_bottom_open
	wall_instance.get_node("WallBottomClose").enabled = !is_bottom_open
	
	block_left = wall_instance.get_node('BlockLeft')
	block_right = wall_instance.get_node('BlockRight')
	block_bottom = wall_instance.get_node('BlockBottom')
	block_top = wall_instance.get_node('BlockTop')

func on_hitbox_enter():
	if minimap_displayer.currnet_room_cords != cords:
		minimap_displayer.currnet_room_cords = cords
		if room_generator.rooms[cords].status == 'unexplored':
			print('Entered First Time')
			block_doors()
		minimap_displayer.on_room_change(cords)
		
