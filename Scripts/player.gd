extends Node2D
class_name Player

@export var player_default_speed := 0.17

@onready var anim_tree: AnimationTree = $AnimationTree
@onready var player_speed := player_default_speed
@onready var state_machine : AnimationNodeStateMachinePlayback = anim_tree["parameters/playback"]

var is_sitting := false

func play_anim(anim: String):
	if state_machine.get_current_node() == anim:
		return
	state_machine.travel(anim)
	

func get_current_anim_length() -> float:
	return state_machine.get_current_length()


func _ready() -> void:
	state_machine.travel("Walk")


func _physics_process(delta) -> void:
	state_machine.get_current_length()
	if state_machine.get_current_node() == "Walk":
		# Rotate world in the opposite direction of walking
		Events.rotate_world.emit(-player_speed * delta)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey: 
		if event.pressed:
			if event.is_action("space"):
				state_machine.travel("Dance")
				is_sitting = false
			elif event.is_action("down"):
				state_machine.travel("Sit")
				is_sitting = true
			elif event.is_action("right"):
				state_machine.travel("Walk")
				is_sitting = false
		elif not is_sitting:
				state_machine.travel("Idle")
	
