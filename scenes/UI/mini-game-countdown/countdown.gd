extends Control

@onready var label : Label = %TimerLabel
@onready var timer : Timer = $Timer

var seconds_elapsed : int = 3

func _ready() -> void:
	SignalBus.instructions_read_and_ready.connect(_on_instructions_read_and_ready)

func _on_instructions_read_and_ready() -> void:
	timer.start()
	visible = true

func update_label(new_text: String) -> void:
	label.text = new_text

func _on_timer_timeout() -> void:
	if seconds_elapsed <= 1:
		update_label("Go!")
		await get_tree().create_timer(0.3).timeout
		SignalBus.minigame_countdown_timeout.emit()
		queue_free()
	else:
		seconds_elapsed -= 1
		update_label(str(seconds_elapsed))
		timer.start()
