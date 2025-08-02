@tool
class_name DialogBubble
extends Node2D

signal clicked(dialog_bubble)

@onready var background := $Background as Sprite2D
@onready var dialog := $DialogSprite as Sprite2D

@export var dialog_texture : Texture:
	set(new_dialog_texture):
		dialog_texture = new_dialog_texture
		_on_dialog_texture_changed()


func _on_dialog_texture_changed():
	if is_instance_valid(dialog):
		dialog.texture = dialog_texture


func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		clicked.emit(self)
