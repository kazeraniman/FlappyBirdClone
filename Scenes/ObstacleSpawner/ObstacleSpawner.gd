extends Node2D

var PIPE_POSITION_RANGE = 440

var obstacle_scene

func _ready():
	# Load the obstacle scene for further use
	obstacle_scene = load("res://Scenes/Obstacle/Obstacle.tscn")

func start_generation():
	$GenerationTimeout.start()

func _on_GenerationTimeout_timeout():
	# Generate a new obstacle
	var obstacle = obstacle_scene.instance()
	# Position it at a random valid point
	obstacle.position.y = randi() % PIPE_POSITION_RANGE - (PIPE_POSITION_RANGE / 2)
	# Add it to the scene
	add_child(obstacle)
