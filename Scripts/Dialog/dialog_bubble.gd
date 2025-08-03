#@tool
class_name DialogBubble
extends Node2D

signal clicked(dialog_bubble)

@export var drop_time := 0.5
@export var bounce_height := 65.0
@export var bounce_time := 0.2
@export var y_offset := Vector2(-130.0, 0.0)
@export var lift_duration := 0.5

@export var dialog_texture : Texture:
	set(new_dialog_texture):
		dialog_texture = new_dialog_texture
		_on_dialog_texture_changed()

@onready var background := $Background as Sprite2D
@onready var dialog := $DialogSprite as Sprite2D

var top_position: Vector2
var bottom_position: Vector2
var overshoot_y: float
var bounce_up_y: float 

func _ready():
	bottom_position = position
	top_position = bottom_position + Vector2(0, -700)


func init():
	visible = false
	pull_up()
	await get_tree().create_timer(lift_duration).timeout
	visible = true


func drop_and_bounce():
	var tween := get_tree().create_tween()
	var target_position := bottom_position
	target_position.y += randf_range(y_offset.x, y_offset.y)
	var overshoot_y = target_position.y + bounce_height * 0.5
	var bounce_up_y = target_position.y - bounce_height * 0.3
	# Drop with slight overshoot
	tween.tween_property(self, "position:y", overshoot_y, drop_time).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	# Bounce up
	tween.tween_property(self, "position:y", bounce_up_y, bounce_time).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	# Settle down
	tween.tween_property(self, "position:y", target_position.y, bounce_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func pull_up():
	var tween := get_tree().create_tween()
	tween.tween_property(self, "position:y", top_position.y, lift_duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)


func _on_dialog_texture_changed():
	if is_instance_valid(dialog):
		dialog.texture = dialog_texture


func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		clicked.emit(self)
