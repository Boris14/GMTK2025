extends Node2D
class_name Player

@export var player_default_speed := 0.17

@onready var anim_tree: AnimationTree = $AnimationTree
@onready var player_speed := player_default_speed
@onready var state_machine : AnimationNodeStateMachinePlayback = anim_tree["parameters/playback"]

enum EPlayerAnimation
{
	WALK,
	SIT,
	LAY,
	FALL,
	EAT
}

var current_anim : EPlayerAnimation

func play_anim(anim: EPlayerAnimation):
	var node : String
	match anim:
		EPlayerAnimation.WALK:
			node = "SadWalk" if Events.is_day_ruined else "Walk"
		EPlayerAnimation.SIT:
			node = "Sit"
		EPlayerAnimation.FALL:
			node = "Fall"
		EPlayerAnimation.EAT:
			node = "Eat"
	current_anim = anim
	if state_machine.get_current_node() == node:
		return
	state_machine.travel(node)
	

func get_current_anim_length() -> float:
	return state_machine.get_current_length()


func _ready() -> void:
	state_machine.travel("Walk")
	Events.day_ruined.connect(_on_day_ruined)
	Events.day_reset.connect(_on_day_reset)


func _physics_process(delta) -> void:
	if current_anim == EPlayerAnimation.WALK:
		# Rotate world in the opposite direction of walking
		Events.rotate_world.emit(-player_speed * delta)
	

func _on_day_ruined():
	Events.is_day_ruined = true
	if state_machine.get_current_node() == "Walk":
		state_machine.travel("SadWalk")


func _on_day_reset():
	Events.is_day_ruined = false
	if state_machine.get_current_node() == "SadWalk":
		state_machine.travel("Walk")
