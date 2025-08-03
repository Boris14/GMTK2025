class_name Bedroom
extends Node2D

signal room_completed(room: Node2D)

@export var sleep_duration := 4.0

@onready var trigger_area := %TriggerArea as Area2D

var sleep_timer : Timer
var player: Player

func start_room(in_player: Player):
	player = in_player
	player.play_anim("Sit")
	sleep_timer.start(sleep_duration)


func _ready():
	if Engine.is_editor_hint():
		return
	
	sleep_timer = Timer.new()
	sleep_timer.one_shot = true
	sleep_timer.autostart = false
	sleep_timer.timeout.connect(_on_sleep_timer_timeout)
	add_child(sleep_timer)
	
	%Planet.visible = false
	trigger_area.area_entered.connect(_on_area_entered_trigger_area)


func _on_sleep_timer_timeout():
	player.play_anim("Walk")
	room_completed.emit(self)


func _on_area_entered_trigger_area(area: Area2D):
	if area.owner.is_in_group("Player"):
		start_room(area.owner as Player)
		trigger_area.area_entered.disconnect(_on_area_entered_trigger_area)
