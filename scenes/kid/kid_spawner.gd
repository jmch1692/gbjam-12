extends Area2D

@export var spawn_area_points : Array[Marker2D]

var randomizer : RandomNumberGenerator = RandomNumberGenerator.new()
var kid_packed_scene : PackedScene = preload("res://scenes/kid/kid.tscn")
var spawned_kids : Array[Kid]

func _pick_random_position(points : Array[Marker2D]) -> Marker2D:
	randomizer.randomize()
	var selected_point = points.pick_random()
	points.erase(selected_point)
	return selected_point

func _on_remove_kid(kid: Kid):
	if spawned_kids.size() >= 0:
		spawned_kids.erase(kid)

	if spawned_kids.size() <= 0:
		queue_free()

func _ready() -> void:
	SignalBus.remove_kid.connect(_on_remove_kid.bind())
	randomizer.randomize()
	var number_of_kids_to_spawn : int = randomizer.randi_range(1, spawn_area_points.size())
	for spawn_area in number_of_kids_to_spawn:
		var insantiated_kid : Kid = kid_packed_scene.instantiate()
		add_child(insantiated_kid)
		var kid_position = _pick_random_position(spawn_area_points).position
		insantiated_kid.position = kid_position
		spawned_kids.append(insantiated_kid)
	
	SignalBus.report_kids_in_area.emit(self, spawned_kids)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		SignalBus.player_within_this_spook_area.emit(self)

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		SignalBus.player_left_this_spook_area.emit(self)
