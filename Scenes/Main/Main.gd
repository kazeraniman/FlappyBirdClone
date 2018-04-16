extends Node

func _ready():
	randomize()

func _on_Bird_start_flight():
	# Player has initiated control, prepare to start generating obstacles
	$StartObstacleSpawningTimeout.start()

func _on_StartObstacleSpawningTimeout_timeout():
	# Enough time has passed to acclimatize the user, start generating objects
	$ObstacleSpawner.start_generation()
