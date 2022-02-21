extends KinematicBody2D

export var MAX_SPEED = 100
export var ROLL_SPEED = 150
export var ACCELERATION = 400

onready var animationTree = $AnimationTree
onready var animationPlayer = $AnimationPlayer
onready var playerStatus = get_node("/root/PlayStatus")

var facingVector = Vector2.DOWN
var moveVector = Vector2.ZERO


var status = RUN

enum {
	RUN, ROLL, ATTACK
}

func _ready():
	animationTree.active = true
	playerStatus.connect("no_health", self, "queue_free")

func _physics_process(delta):
	if Input.is_action_just_pressed("attack"):
		status = ATTACK
	match status:
		RUN:
			run(delta)
		ATTACK:
			attack()
		ROLL:
			roll()
			
func run(delta):
	var x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	var inputVector = Vector2(x, y).normalized()
	if (inputVector.length() > 0):
		updateFacing(inputVector)
		animationTree["parameters/playback"].travel("RUN")
		moveVector = moveVector.move_toward(inputVector * MAX_SPEED,  ACCELERATION * delta)
	else:
		animationTree["parameters/playback"].travel("IDLE")
		moveVector = moveVector.move_toward(Vector2.ZERO,  ACCELERATION * delta)
		
	moveVector = move_and_slide(moveVector)
	
	if Input.is_action_just_pressed("roll"):
		moveVector = facingVector * ROLL_SPEED
		status = ROLL
	
	if Input.is_action_just_pressed("attack"):
		status = ATTACK

func updateFacing(facing):
	facingVector = facing
	animationTree.set("parameters/RUN/blend_position", facingVector)
	animationTree.set("parameters/IDLE/blend_position", facingVector)
	animationTree.set("parameters/ATTACK/blend_position", facingVector)
	animationTree.set("parameters/ROLL/blend_position", facingVector)

func attack():
	moveVector = Vector2.ZERO
	animationTree["parameters/playback"].travel("ATTACK")
	
func onAttackFinish():
	status = RUN
	
	
func roll():
	animationTree["parameters/playback"].travel("ROLL")
	moveVector = move_and_slide(moveVector)
	
func onRollSlowDown():
	moveVector = moveVector * 0.5
	
func onRollFinished():
	moveVector = moveVector * 0.8
	status = RUN


func _on_Hurtbox_area_entered(area):
	playerStatus.health -= 1
