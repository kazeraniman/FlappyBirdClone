extends Node2D

signal score_point

var PIPE_POSITION_RANGE = 440

var obstacle_scene

func _ready():
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
	obstacle.position.y = randi() % PIPE_POSITION_RANGE - (PIPE_POSITION_RANGE / 2)
	# Set up the score signal forwarding
	obstacle.connect("score_point", self, "forward_score_signal")
	# Add it to the scene
	$GeneratedObstacles.add_child(obstacle)

func forward_score_signal():
	emit_signal("score_point")