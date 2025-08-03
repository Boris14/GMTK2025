extends Node2D

@export var btn_title: String
@onready var button: Button = $String/RigidBody2D/ColorRect/HBoxContainer/Button
@onready var rigid_body_sign: Node2D = $"."

signal pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.text = btn_title
	rigid_body_sign.rotation = randf_range(-.75,.75)

	
	#string.rotation = randi_range(-5,5)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	pressed.emit()
	pass # Replace with function body.
