extends Node2D

signal score_point

export (int) var VELOCITY

func _physics_process(delta):
	position.x -= VELOCITY * delta

func _on_ScoreArea_area_entered(area):
	# Signal that a point has been scored and then 
	$ScoreArea/CollisionShape2D.disabled = true
	emit_signal("score_point")
	print("POINT!")

func _on_TopPipe_area_entered(area):
	if area.get_name() == "DestructionZone":
		# We hit the object destroyer so we no longer need the obstacle
		queue_free()
