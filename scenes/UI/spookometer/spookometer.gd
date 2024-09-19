extends Control

var units_to_fill : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.broadcast_set_difficulty.connect(_on_broadcast_set_difficulty.bind())

func _on_broadcast_set_difficulty(difficulty : int) -> void:
	print(100 / difficulty)
	
#TODO: I just need to know the minimum achiavable score. Spookometer will reach it's top when the minimum is hit 
