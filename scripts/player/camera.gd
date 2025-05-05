extends Camera2D

func cameraUpdate():
	var pos = get_local_mouse_position() * 0.2
	set_position(pos)

func _physics_process(_delta: float) -> void:
	cameraUpdate()
