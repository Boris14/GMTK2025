class_name Main
extends Node2D

@onready var player := %Player as Player
@onready var planet := %Planet as Node2D

var is_day_ruined := false

func _ready():
	Events.rotate_world.connect(_on_world_rotated)
	Events.day_ruined.connect(_on_day_ruined)


func _on_world_rotated(angle_delta: float):
	planet.rotation += angle_delta


func _on_day_ruined():
	is_day_ruined = true
