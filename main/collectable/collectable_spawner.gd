class_name CollectableSpawner
extends Spatial
# Spawns in a random collectable from its list when placed in a scene
# Allows for some variation and random powerups

var collectables: Array = [
	preload("res://main/collectable/coin/Coin.tscn"),
	preload("res://main/collectable/frog/Frog.tscn"),
	preload("res://main/collectable/magnet/Magnet.tscn")
] 
var rarities: Array = [0.98, 0.982, 1.0]

func _ready() -> void:
	var rand: float = randf()
	
	for i in range(len(collectables)):
		var collectable: Collectable = collectables[i].instance()
		if rand< rarities[i] or i == len(collectables) - 1:
			yield(get_parent(), "ready")
			get_parent().add_child(collectable)
			collectable.transform = transform
			queue_free()
			return
		collectable.queue_free()
	
