extends Control

onready var heartUIEmpty = $HeartUIEmpty
onready var heartUIFull = $HeartUIFull
onready var playerStatus = get_node("/root/PlayStatus")

func _ready():
	setMaxHeart(playerStatus.max_health)
	setHeart(playerStatus.health)
	playerStatus.connect("health_changed", self, "setHeart")


func setHeart(value):
	heartUIFull.rect_size.x = value * 15
	
func setMaxHeart(value):
	heartUIEmpty.rect_size.x = value * 15
