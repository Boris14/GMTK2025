extends Node2D
class_name Player

@export var rotation_speed: float
@export var player_speed : float
@onready var anim_tree: AnimationTree = $AnimationTree

var state_machine
var is_sitting := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_machine = anim_tree["parameters/playback"]
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("space"):
		state_machine.travel("Dance")
		is_sitting = false
		
	elif Input.is_action_pressed("down"):
		state_machine.travel("Sit")
		is_sitting = true
		
	elif Input.is_action_pressed("right"):
		state_machine.travel("Walk")
		is_sitting = false
		# Rotate the world
		Events.rotate_world.emit()
	elif !is_sitting:  # Only go to Idle if we're not sitting
		state_machine.travel("Idle")
	
	
	pass
	
