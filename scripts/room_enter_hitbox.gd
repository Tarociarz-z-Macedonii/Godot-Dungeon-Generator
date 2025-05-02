extends Area2D

var room

func _ready() -> void:
	room = get_node('../../')
	

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == 'Player':
		room.on_hitbox_enter()
