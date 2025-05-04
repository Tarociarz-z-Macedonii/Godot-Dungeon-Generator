extends CharacterBody2D

@onready var target = $"/root/Place/Player"
var speed = 150
var room

func _ready() -> void:
	room = get_node("../../../")

func _physics_process(_delta):
	var direction = (target.global_position - global_position).normalized()
	velocity = direction * speed
	look_at(target.global_position)
	move_and_slide()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Kill") and randi_range(1, 2) == 1:
		death()

func death():
	room.on_enemy_death()
	queue_free()
