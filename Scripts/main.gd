class_name Main
extends Node2D

@export_node_path("Bedroom") var bedroom_path
@export_node_path("Classroom") var classroom_path
@export_node_path("DogChase") var dog_chase_path

@export var room_reload_delay := 10.0

@onready var player := %Player as Player
@onready var planet := %Planet as Node2D

@onready var bedroom := %Bedroom as Bedroom
@onready var classroom := %Classroom as Classroom
@onready var dog_chase := %DogChase as DogChase

# Room <-> Scene
var room_to_scene : Dictionary = {}

var bedroom_scene := PackedScene.new()
var classroom_scene := PackedScene.new()
var dog_chase_scene := PackedScene.new()

var is_day_ruined := false

func _ready():
	Events.rotate_world.connect(_on_world_rotated)
	Events.day_ruined.connect(_on_day_ruined)
	
	_register_room(bedroom)
	_register_room(classroom)
	_register_room(dog_chase)


func _register_room(room: Node2D) -> void:
	var scene := PackedScene.new()
	if scene.pack(room) == OK:
		room_to_scene[room] = scene
		room.room_completed.connect(_on_room_completed)
	else:
		push_error("Failed to pack room: %s" % room.name)


func _on_room_completed(room: Node2D):
	await get_tree().create_timer(room_reload_delay).timeout
	
	var scene = room_to_scene.get(room)
	if scene:
		room_to_scene.erase(room)
		room.queue_free()
		
		var new_room = scene.instantiate()
		new_room.room_completed.connect(_on_room_completed)
		planet.add_child(new_room)
		
		room_to_scene[new_room] = scene
	else:
		push_error("No packed scene found for room: %s" % room.name)


func _on_world_rotated(angle_delta: float):
	planet.rotation += angle_delta


func _on_day_ruined():
	is_day_ruined = true
