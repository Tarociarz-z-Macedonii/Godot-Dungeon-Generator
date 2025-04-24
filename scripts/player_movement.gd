extends CharacterBody2D

var current_speed: float = 1500
var animator: AnimatedSprite2D

func _ready() -> void:
	animator = $AnimatedSprite2D
	_play_anims()

func _physics_process(_delta: float) -> void:
	_move()
	_play_anims()
	_flip()

func _move():
	var dir = Input.get_vector("movement_left", "movement_right", "movement_forward", "movement_backward")
	velocity = current_speed * dir
	move_and_slide()

func _play_anims():
	if velocity.length() > 0:
		animator.play('walk')
		return
	animator.play('idle')
	
func _flip():
	if velocity.x < 0 and not animator.flip_h:
		animator.flip_h = true
	elif velocity.x > 0 and animator.flip_h:
		animator.flip_h = false
