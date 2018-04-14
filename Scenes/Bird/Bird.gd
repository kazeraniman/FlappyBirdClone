extends Area2D

signal start_flight

export (bool) var player_control

var GRAVITY = 8
var FLY_UPWARD_VELOCITY = -225
var MAX_DOWNWARD_VELOCITY = 300
var ROTATION_VELOCITY = 250
var FLYING_ROTATION = -45
var DIVING_ROTATION = 90

var ANIMATION_FLAP_SPEED = 3
var ANIMATION_FLY_SPEED = 2

var screen_size

var vertical_velocity = 0
var should_rotate = false

func _ready():
	# Get the screen size
	screen_size = get_viewport_rect().size
	# Ensure the player does not have control on creation
	set_player_control(false)

func _process(delta):
	# Cheat button for now to switch between the two states
	if Input.is_action_just_pressed("ui_up"):
		set_player_control(!player_control)

func _physics_process(delta):
	# Start the phase of player control if flight is triggered during the passive phase
	if !player_control and Input.is_action_just_pressed("fly"):
		emit_signal("start_flight")
		set_player_control(true)
	# Apply the physics only if the player has controls, otherwise just fly passively in a fixed position
	if player_control:
		# Apply the impact of gravity
		vertical_velocity = clamp(vertical_velocity + GRAVITY, FLY_UPWARD_VELOCITY, MAX_DOWNWARD_VELOCITY)
		# Check if the player is inputting a flight command
		if Input.is_action_just_pressed("fly"):
			# Play the flap animation and apply flight changes
			$AnimationPlayer.play("flying", -1, ANIMATION_FLAP_SPEED)
			vertical_velocity = FLY_UPWARD_VELOCITY
			should_rotate = false
			rotation_degrees = FLYING_ROTATION
			$RotationBeginTimout.start()
		# Actually apply the physics
		position.y += vertical_velocity * delta
		if should_rotate:
			rotation_degrees = clamp(rotation_degrees + ROTATION_VELOCITY * delta, FLYING_ROTATION, DIVING_ROTATION)

func set_player_control(control):
	if control:
		# Give the player control of the character
		player_control = true
		# Set other control properties
		should_rotate = true
		# Reset the flying animation and stop it as it will only trigger on fly command
		$AnimationPlayer.stop(false)
		$AnimationPlayer.get_animation("flying").loop = false
		$AnimationPlayer.seek(1.6, true)
	else:
		# Take away the player control
		player_control = false
		# Reset other control properties
		vertical_velocity = 0
		should_rotate = false
		# Reset the position and rotation of the player
		position.y = screen_size.y / 2
		position.x = screen_size.x / 3
		rotation_degrees = 0
		# Passively play the flying animation on loop
		$AnimationPlayer.get_animation("flying").loop = true
		$AnimationPlayer.seek(0, true)
		$AnimationPlayer.play("flying", -1, ANIMATION_FLY_SPEED)

func _on_RotationBeginTimout_timeout():
	# Time to start the rotation as it as been sufficient time after the flap
	should_rotate = true
