extends Node

export(int) var max_health = 5
var health = max_health setget setHealth

signal no_health
signal health_changed(value)

func _ready():
	self.health = max_health
	
func setHealth(value): 
	health = value
	emit_signal("health_changed", value)
	if (health <= 0):
		emit_signal("no_health")


