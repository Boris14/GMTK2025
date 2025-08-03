extends Node2D
class_name SmallPhysLbl

@export var lbl_title: String
@export var drop_length: float
@export var duration_drop: float
@onready var button: Button = $String/RigidBody2D/ColorRect/HBoxContainer/Button
@onready var lbl: Label = $String/RigidBody2D/ColorRect/HBoxContainer/Label

@onready var rigid_body_sign: Node2D = $"."

signal pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lbl.text = lbl_title
	rigid_body_sign.rotation = randf_range(-0.25,0.25)
	var tween1 = get_tree().create_tween()
	tween1.tween_property($Begining,"global_position",Vector2($".".position.x,$".".position.y + drop_length),duration_drop).set_trans(Tween.TRANS_SPRING)

	#string.rotation = randi_range(-5,5)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	pressed.emit()
	pass # Replace with function body.
