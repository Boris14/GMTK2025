class_name BadThought
extends Area2D

signal entered_player(thought: BadThought)

@export var speed := 100.0
@export var sway_strength := 6.0
@export var sway_speed := 4.0

var player: Player
var is_under_mouse_control := false
var mouse_offset := Vector2.ZERO
var has_reached_player := false

func _ready():
	area_entered.connect(_on_area_entered_area)

	
func set_player(in_player: Player):
	player = in_player
	

func _physics_process(delta):
	if has_reached_player:
		return

	if is_under_mouse_control:
		global_position = get_global_mouse_position() + mouse_offset
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			is_under_mouse_control = false


	elif is_instance_valid(player):
		var new_position = position + (player.position - position).normalized() * speed * delta
		var sway_offset = Vector2(sin(Time.get_ticks_msec() / 1000.0 * sway_speed) * sway_strength, 0)
		position = new_position + sway_offset


func remove(pull_up_duration: float):
	is_under_mouse_control = false
	player = null
	var target_position := position + Vector2(0, -1100)
	var tween := get_tree().create_tween()
	var pull_up_tweener = tween.tween_property(self, "position", target_position, pull_up_duration)
	pull_up_tweener.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	pull_up_tweener.finished.connect(_on_pull_up_finished)


func _on_pull_up_finished():
	queue_free()


func _on_area_entered_area(area: Area2D):
	if not is_instance_valid(area) or not is_instance_valid(area.owner):
		return
	if area.owner.is_in_group("Player"):
		entered_player.emit(self)
		has_reached_player = true
		area_entered.disconnect(_on_area_entered_area)


func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT: 
		is_under_mouse_control = event.pressed
		if event.pressed:
			mouse_offset = global_position - event.position
