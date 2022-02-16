extends AnimatedSprite


# Called when the node enters the scene tree for the first time.
func _ready():
	play("Animate")

func _on_Effects_animation_finished():
	queue_free()
