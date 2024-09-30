extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var spawners_nodes = get_tree().get_nodes_in_group("spawner") as Array[KidSpawner]
	if spawners_nodes.is_empty():
		print("You win")
