extends CharacterBody2D

signal game_over
signal level_completed

const SPEED = 220.0
const JUMP_VELOCITY = -420.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_active = true

@onready var animated_sprite = $AnimatedSprite2D
@onready var milo = $"../Milo"

func _physics_process(delta):
	if not is_active:
		return

	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
		animated_sprite.flip_h = (direction < 0)
		animated_sprite.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animated_sprite.play("idle")

	if not is_on_floor():
		animated_sprite.play("jump")

	move_and_slide()

	if milo and milo.has_method("follow_taruq"):
		milo.follow_taruq(global_position, animated_sprite.flip_h, is_on_floor(), delta)
