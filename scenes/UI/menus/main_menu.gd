extends Control

@onready var start_button : Button = %StartButton
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var menu : ColorRect = %ColorRect
@onready var transition_bg : ColorRect = %TransitionBackground
@onready var control_info : Control = $Controls
@onready var credits_info : Control = $Credits

func _ready() -> void:
	start_button.grab_focus()
	SignalBus.hide_info_panel.connect(_on_hide_info_panel)
	
func _on_hide_info_panel():
	start_button.grab_focus()
	menu.show()
	
func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_start_button_pressed() -> void:
	SignalBus.start_game.emit()
	transition_bg.show()
	transition_bg.z_index = 100
	animation_player.play("screen_transition")
	menu.hide()

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	SignalBus.enable_player.emit()
	queue_free()

func _on_controls_pressed() -> void:
	control_info.show()
	control_info.back_button.grab_focus()
	menu.hide()

func _on_credits_pressed() -> void:
	credits_info.show()
	credits_info.back_button.grab_focus()
	menu.hide()
