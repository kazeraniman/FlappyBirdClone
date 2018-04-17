extends Node2D

signal score_point

var IMMOVABLE_PIPE_GAP_SIZE = 220 # Size of pipe opening + two pipe heads with some leniency (206 is the true value)
var GROUND_ALLOWANCE = 50 # Thickness of the ground texture with some leniency (49 is the true value)

var pipe_opening_position_range

var obstacle_scene

func _ready():
	# Determine the range of allowed values for the pipe opening position
	var screen_size = get_viewport_rect().size
	pipe_opening_position_range = int(round(screen_size.y - IMMOVABLE_PIPE_GAP_SIZE - GROUND_ALLOWANCE))
	# Load the obstacle scene for further use
	obstacle_scene = load("res://Scenes/Obstacle/Obstacle.tscn")

func start_generation():
	$GenerationTimeout.start()

func stop_generation():
	$GenerationTimeout.stop()

func _on_GenerationTimeout_timeout():
	# Generate a new obstacle
	var obstacle = obstacle_scene.instance()
	# Position it at a random valid point
	obstacle.position.y = randi() % pipe_opening_position_range + int(round(IMMOVABLE_PIPE_GAP_SIZE / 2))
	# Set up the score signal forwarding
	obstacle.connect("score_point", self, "forward_score_signal")
	# Add it to the scene
	$GeneratedObstacles.add_child(obstacle)

func wipe_obstacles():
	for obstacle in $GeneratedObstacles.get_children():
		obstacle.queue_free()

func forward_score_signal():
	emit_signal("score_point")