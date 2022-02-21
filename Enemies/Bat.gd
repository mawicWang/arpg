extends KinematicBody2D

export var ACCELERATION = 300
export var MAX_SPEED = 50

onready var animateSprite = $AnimatedSprite
var DeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	animateSprite.playing = true
	

func _physics_process(delta):
	var player = findPlayer()
	var distance = 9999
	if (player != null):
		distance = global_position.distance_squared_to(player.position)
		var direction = global_position.direction_to(player.position)
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)

	if (distance < 3600): 
		velocity = move_and_slide(velocity)
		animateSprite.flip_h = velocity.x < 0
		
	
func findPlayer(): 
	# TODO
	return get_parent().get_parent().get_node("Player")

func _on_Hurtbox_area_entered(area):
	var deathEffect = DeathEffect.instance()	
	get_parent().add_child(deathEffect)
	deathEffect.global_position = global_position
	queue_free()
