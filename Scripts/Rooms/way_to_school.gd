class_name WayToSchool
extends Node2D

signal room_completed(room: Node2D)

@export var car_speed := 1000.0
@export var garbage_scene : PackedScene

@onready var trigger_area := %TriggerArea as Area2D
@onready var throw_area := %ThrowArea as Area2D
@onready var throw_path_follow := %ThrowPathFollow2D as PathFollow2D
@onready var car := %Car as Area2D
@onready var car_path_follow := %CarPathFollow2D as PathFollow2D

func start_room():
	car.visible = true
	car.global_position = Vector2.ZERO


func _ready():
	if Engine.is_editor_hint():
		return

	trigger_area.area_entered.connect(_on_area_entered_trigger_area)
	throw_area.area_entered.connect(_on_area_entered_throw_area)
	
	car.visible = false


func _physics_process(delta):
	if is_instance_valid(car) and car.visible:
		if car_path_follow.progress_ratio < 1.0:
			var actual_car_speed := car_speed
			if Events.is_day_ruined:
				actual_car_speed *= Events.ruined_day_speed_multiplier
			car_path_follow.progress += delta * actual_car_speed
			car.global_position = car_path_follow.global_position
			car.rotation = car_path_follow.rotation
		else:
			car.queue_free()


func _on_area_entered_throw_area(area: Area2D):
	if area == car:
		throw_area.area_entered.disconnect(_on_area_entered_throw_area)
		var garbage := garbage_scene.instantiate() as Garbage
		await get_tree().root.call_deferred("add_child", garbage)
		garbage.start(throw_path_follow)


func _on_area_entered_trigger_area(area: Area2D):
	if area.owner.is_in_group("Player"):
		start_room()
		trigger_area.area_entered.disconnect(_on_area_entered_trigger_area)
