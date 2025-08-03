class_name Bedroom
extends Node2D

signal room_completed(room: Node2D)

@export var sleep_duration := 7.0
@export var dance_duration := 3.0

@onready var trigger_area := %TriggerArea as Area2D

var is_winning: bool
var sleep_timer : Timer
var player: Player


func start_room(in_player: Player):
	player = in_player
	player.play_anim(Player.EPlayerAnimation.SIT)
	sleep_timer.start(sleep_duration)


func _ready():
	if Engine.is_editor_hint():
		return
	
	sleep_timer = Timer.new()
	sleep_timer.one_shot = true
	sleep_timer.autostart = false
	sleep_timer.timeout.connect(_on_sleep_timer_timeout)
	add_child(sleep_timer)
	
	trigger_area.area_entered.connect(_on_area_entered_trigger_area)



func _on_sleep_timer_timeout():	
	if Events.is_day_ruined or Events.is_first_sleep:
		# Start the day over	
		Events.day_reset.emit()
		player.play_anim(Player.EPlayerAnimation.WALK)
		room_completed.emit(self)
		if Events.is_first_sleep:
			Events.is_first_sleep = false
	else:
		player.play_anim(Player.EPlayerAnimation.DANCE)
		await get_tree().create_timer(dance_duration).timeout
		Events.win.emit()


func _on_area_entered_trigger_area(area: Area2D):
	if area.owner.is_in_group("Player"):
		start_room(area.owner as Player)
		trigger_area.area_entered.disconnect(_on_area_entered_trigger_area)
