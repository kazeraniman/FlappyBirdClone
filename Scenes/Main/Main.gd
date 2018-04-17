extends Node

var score = 0

func _ready():
	randomize()

func _on_Bird_start_flight():
	# Player has initiated control, prepare to start generating obstacles
	$StartObstacleSpawningTimeout.start()
	# Show the score
	$HUD.show_mode($HUD.State.PLAYING)

func _on_StartObstacleSpawningTimeout_timeout():
	# Enough time has passed to acclimatize the user, start generating objects
	$ObstacleSpawner.start_generation()

func _on_ObstacleSpawner_score_point():
	score += 1
	$HUD.set_score_label(score)

func _on_Bird_death():
	# Stop further obstacle generation
	$ObstacleSpawner.stop_generation()
	# Stop the obstacles from moving further
	for obstacle in $ObstacleSpawner/GeneratedObstacles.get_children():
		obstacle.set_active(false)
	# Stop the ground and background from scrolling
	$Ground.set_active(false)
	$Background.set_active(false)
	# Show the menu
	$HUD.show_mode($HUD.State.MENU)

func _on_HUD_restart():
	# Wipe all the obstacles currently on the screen
	$ObstacleSpawner.wipe_obstacles()
	# Get the ground and background scrolling again
	$Ground.set_active(true)
	$Background.set_active(true)
	# Reset the score
	score = 0
	$HUD.set_score_label(score)
	# Reset the player
	$Bird.set_player_state($Bird.State.AUTO_PILOT)
	# Set the UI back to standby mode
	$HUD.show_mode($HUD.State.SETUP)
