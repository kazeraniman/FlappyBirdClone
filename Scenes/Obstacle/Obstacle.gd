extends Node2D

signal score_point

var velocity = 150
var active = true
var triggered = false

func _physics_process(delta):
	if active:
		position.x -= velocity * delta

func _on_ScoreArea_area_entered(area):
	if not triggered:
	# Signal that a point has been scored and prevent double counting on further collisions
		triggered = true
		$ScoreArea/CollisionShape2D.call_deferred("set_disabled", true)
		emit_signal("score_point")

func _on_TopPipe_area_entered(area):
	if area.get_name() == "DestructionZone":
		# We hit the object destroyer so we no longer need the obstacle
		queue_free()

func set_active(is_active):
	active = is_active
