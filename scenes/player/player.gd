extends CharacterBody2D
class_name Player

@onready var state_machine : FiniteStateMachine = $FiniteStateMachine

var closest_area : Area2D = null :
	set(value):
		closest_area = value

func _ready() -> void:
	SignalBus.enable_player.connect(_on_enabled)
	SignalBus.player_left_this_spook_area.connect(_on_player_left_spook_area.bind())
	SignalBus.player_within_this_spook_area.connect(_on_player_within_spook_area.bind())
	
func _on_enabled() -> void:
	state_machine.change_state("Idle")

func _on_player_left_spook_area(area: Area2D):
	closest_area = null
	
func _on_player_within_spook_area(area: Area2D):
	GameManager.make_random_kid_talk(area)
	closest_area = area
