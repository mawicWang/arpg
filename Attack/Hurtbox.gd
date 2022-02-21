extends Area2D

const HitEffect = preload("res://Effects/HitEffect.tscn")

export var withHitEffect = true 
export var offset = Vector2.ZERO

func _on_Hurtbox_area_entered(area):
	if (withHitEffect):
		var hitEffect = HitEffect.instance()
		get_tree().current_scene.add_child(hitEffect)
		hitEffect.global_position = global_position + offset
