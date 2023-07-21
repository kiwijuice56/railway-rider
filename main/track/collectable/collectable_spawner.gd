class_name CollectableSpawner
extends Spatial
# Spawns in a random collectable from its list when placed in a scene
# Allows for some variation and random powerups

var collectables: Array = [
	preload("res://main/track/collectable/coin/Coin.tscn"),
	preload("res://main/track/collectable/frog/Frog.tscn")
] 
var rarities: Array = [0.985, 0.05]

func _ready() -> void:
	for i in range(len(collectables)):
		var collectable: Collectable = collectables[i].instance()
		if randf() < rarities[i] or i == len(collectables) - 1:
			yield(get_parent(), "ready")
			get_parent().add_child(collectable)
			collectable.transform = transform
			queue_free()
			return
		collectable.queue_free()
	
