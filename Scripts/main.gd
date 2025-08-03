class_name Main
extends Node2D

@export var room_reload_delay := 10.0

@onready var player := %Player as Player
@onready var planet := %Planet as Node2D

@onready var bedroom := %Bedroom as Bedroom
@onready var kitchen := %Kitchen as Kitchen
@onready var way_to_school := %WayToSchool as WayToSchool
@onready var classroom := %Classroom as Classroom
@onready var dog_chase := %DogChase as DogChase

#Shitty scene transition
@onready var color_rect: ColorRect = $SceneTransition/ColorRect
@onready var animation_player: AnimationPlayer = $SceneTransition/AnimationPlayer

# Room <-> Scene
var room_to_scene : Dictionary = {}

var is_day_ruined := false

func _ready():
	animation_player.play("fade_in")
	color_rect.color.a = 255
	await get_tree().create_timer(0.9).timeout
	
	Events.rotate_world.connect(_on_world_rotated)
	
	_register_room(bedroom)
	_register_room(kitchen)
	_register_room(way_to_school)
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
	if is_day_ruined:
		angle_delta *= Events.ruined_day_speed_multiplier
	planet.rotation += angle_delta 
