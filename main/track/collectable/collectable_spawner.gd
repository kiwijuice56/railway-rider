class_name CollectableSpawner
extends Spatial
# Spawns in a random collectable from its list when placed in a scene
# Allows for some variation and random powerups

var collectables: Array = [preload("res://main/track/collectable/coin/Coin.tscn")] 
var rarities: Array = [1.0]

func _ready() -> void:
	for i in range(len(collectables)):
		var collectable: Collectable = collectables[i].instance()
		if randf() < rarities[i]:
			yield(get_parent(), "ready")
			get_parent().add_child(collectable)
			collectable.transform = transform
			queue_free()
			return
		collectable.queue_free()
