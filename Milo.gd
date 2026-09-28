extends CharacterBody2D

const SPEED = 200.0
const FOLLOW_OFFSET = 40.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D

func follow_taruq(taruq_position: Vector2, taruq_flipped: bool, taruq_on_floor: bool, delta: float):
	if not is_on_floor():
		velocity.y += gravity * delta

	var target_x = taruq_position.x + (FOLLOW_OFFSET if taruq_flipped else -FOLLOW_OFFSET)
	var distance = target_x - global_position.x

	if abs(distance) > 8.0:
		velocity.x = sign(distance) * SPEED
		animated_sprite.flip_h = (velocity.x < 0)
		animated_sprite.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animated_sprite.play("sit")

	if not taruq_on_floor and is_on_floor() and abs(distance) < 80.0:
		velocity.y = -350.0

	move_and_slide()
