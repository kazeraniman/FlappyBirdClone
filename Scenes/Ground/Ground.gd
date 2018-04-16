extends Area2D

func _ready():
	# Default state is for the ground to be scrolling
	set_active(true)

func set_active(is_active):
	if is_active:
		# Start up the scrolling ground
		$AnimationPlayer.play("scrolling")
	else:
		# Stop the scrolling ground
		$AnimationPlayer.stop()
