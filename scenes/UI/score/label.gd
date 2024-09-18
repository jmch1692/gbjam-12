extends Label

func _ready() -> void:
	SignalBus.set_new_score.connect(_on_new_score.bind())

func _on_new_score(new_score: int):
	text = str(new_score)
