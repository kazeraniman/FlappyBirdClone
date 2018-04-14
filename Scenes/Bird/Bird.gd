extends Area2D

var GRAVITY = 8
var FLY_UPWARD_VELOCITY = -225
var MAX_DOWNWARD_VELOCITY = 300

var vertical_velocity = 0

func _physics_process(delta):
	vertical_velocity += GRAVITY
	vertical_velocity = clamp(vertical_velocity, FLY_UPWARD_VELOCITY, MAX_DOWNWARD_VELOCITY)
	if Input.is_action_just_pressed("fly"):
		$AnimationPlayer.play("flying", -1, 3)
		vertical_velocity = FLY_UPWARD_VELOCITY
	position.y += vertical_velocity * delta
