extends TileMapLayer


func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if enabled:
		SceneManager.load_next_dungeon()
