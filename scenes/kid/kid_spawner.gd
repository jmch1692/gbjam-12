extends Area2D

@export var spawn_area_quadrants : Array[CollisionShape2D]
@export var costumes : Array[Kid.COSTUME]

var randomizer : RandomNumberGenerator = RandomNumberGenerator.new()
var kid : PackedScene = preload("res://scenes/kid/kid.tscn")
var spawned_kids : Array[Kid]

func _pick_quadrant_position(quadrants : Array[CollisionShape2D]) -> CollisionShape2D:
	randomizer.randomize()
	var selected_quadrant = quadrants.pick_random()
	quadrants.erase(selected_quadrant)
	return selected_quadrant

func _pick_kid_costume(costumes_array : Array[Kid.COSTUME]) -> Kid.COSTUME:
	randomizer.randomize()
	var selected_costume = costumes_array.pick_random()
	costumes_array.erase(selected_costume)
	return selected_costume
	
func _ready() -> void:
	randomizer.randomize()
	var number_of_kids_to_spawn : int = randomizer.randi_range(1, 3)
	for spawn_area in number_of_kids_to_spawn:
		var insantiated_kid : Kid = kid.instantiate()
		add_child(insantiated_kid)
		var kid_position = _pick_quadrant_position(spawn_area_quadrants)
		var costume = _pick_kid_costume(costumes)
		# Vector2(20, 20) is half the area size, so, the center of the area
		var area_center = Vector2i(kid_position.position.x, kid_position.position.y) + Vector2i(20, 20)
		insantiated_kid.put_on_costume(Kid.COSTUME.keys()[costume])
		insantiated_kid.position = area_center
		spawned_kids.append(insantiated_kid)
	
	SignalBus.report_kids_in_area.emit(self, spawned_kids)
