extends CanvasLayer

signal restart

enum State {SETUP, PLAYING, MENU}

func _ready():
	show_mode(State.SETUP)

func set_score_label(score):
	$ScoreLabel.text = str(score)
	
func show_mode(mode):
	match mode:
		State.SETUP:
			$ScoreLabel.hide()
			$Menu.hide()
		State.PLAYING:
			$ScoreLabel.show()
			$Menu.hide()
		State.MENU:
			$ScoreLabel.hide()
			$Menu.show()

func _on_TextureButton_pressed():
	emit_signal("restart")
