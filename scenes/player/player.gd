extends CharacterBody2D
class_name Player

@onready var state_machine : FiniteStateMachine = $FiniteStateMachine

var closest_area : Area2D = null

func _ready() -> void:
	SignalBus.enable_player.connect(_on_enabled)
	
func _on_enabled() -> void:
	state_machine.change_state("Idle")
