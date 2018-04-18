extends Node

# Score limit to prevent breaking the UI
var MAX_SCORE = 99999999
# The save game path
var SAVE_GAME_PATH = "user://game_save.save"

var score = 0

func _ready():
	randomize()
	$BackgroundMusic.play()

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
	score = clamp(score, 0, MAX_SCORE)
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
	# Check for a previous best value, ensuring it is within the allowed range to not break the UI
	var previous_best = load_save()
	previous_best = clamp(previous_best, 0, MAX_SCORE)
	# If the current score is better, write in the new score
	if previous_best <= score:
		write_save(score)
	# Update the previous best in the HUD
	$HUD.set_previous_best(previous_best)
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

func load_save():
	var saved_game = File.new()
	# If there is no save file, just return a previous best of 0
	if not saved_game.file_exists(SAVE_GAME_PATH):
		return 0
	# Otherwise load up the save file
	saved_game.open(SAVE_GAME_PATH, File.READ)
	# Load up the value
	var save = parse_json(saved_game.get_line())
	# Close the file since we're done with it
	saved_game.close()
	# Return the previous best value
	return save["best"]

func write_save(new_best):
	# Prepare the save file for writing
	var saved_game = File.new()
	saved_game.open(SAVE_GAME_PATH, File.WRITE)
	# Create the dictionary for writing
	var save = to_json({"best": new_best})
	# Write the save
	saved_game.store_line(save)
	# Close the file since we're done with it
	saved_game.close()
