class_name Kitchen
extends Node2D

signal room_completed(room: Node2D)

@export var bad_thought_scene : PackedScene
@export var spawn_thought_delay := 2.5
@export var room_duration := 20.0
@export var post_room_delay := 1.5

@onready var trigger_area := %TriggerArea as Area2D
@onready var thought_spawns_container := %ThoughtSpawns as Node2D

var player: Player
var spawn_thought_timer: Timer
var room_duration_timer: Timer
var thought_spawns : Array[Marker2D]
var used_spawns : Array[Marker2D]
var bad_thoughts: Array[BadThought]


func start_room(in_player: Player):
	player = in_player
	player.play_anim(Player.EPlayerAnimation.EAT)
	spawn_thought_timer.start(spawn_thought_delay)
	room_duration_timer.start(room_duration)


func _ready():
	if Engine.is_editor_hint():
		return
	%Planet.visible = false
	trigger_area.area_entered.connect(_on_area_entered_trigger_area)
	
	thought_spawns.clear()
	for child in thought_spawns_container.get_children():
		thought_spawns.append(child)
	
	room_duration_timer = Timer.new()
	room_duration_timer.autostart = false
	room_duration_timer.one_shot = true
	room_duration_timer.timeout.connect(_on_room_duration_timer_timeout)
	add_child(room_duration_timer)
	
	spawn_thought_timer = Timer.new()
	spawn_thought_timer.autostart = false
	spawn_thought_timer.one_shot = false
	spawn_thought_timer.timeout.connect(_on_spawn_thought_timer_timeout)
	add_child(spawn_thought_timer)


func stop_room(thought_to_delay: BadThought = null):
	spawn_thought_timer.stop()
	for thought in bad_thoughts:
		if thought_to_delay != thought:
			thought.remove(post_room_delay)
	room_duration_timer.stop()
	await get_tree().create_timer(post_room_delay).timeout
	if is_instance_valid(thought_to_delay):
		thought_to_delay.remove(post_room_delay)
	player.play_anim(Player.EPlayerAnimation.WALK)
	room_completed.emit(self)


func _on_area_entered_trigger_area(area: Area2D):
	if area.owner and area.owner.is_in_group("Player"):
		start_room(area.owner as Player)
		trigger_area.area_entered.disconnect(_on_area_entered_trigger_area)


func _on_room_duration_timer_timeout():
	stop_room()


func _on_spawn_thought_timer_timeout():
	var spawn = thought_spawns.pick_random()
	while used_spawns.has(spawn):
		spawn = thought_spawns.pick_random()
	used_spawns.append(spawn)
	if used_spawns.size() >= thought_spawns.size():
		used_spawns.clear()

	var new_thought := bad_thought_scene.instantiate() as BadThought
	new_thought.position = spawn.position
	new_thought.set_player(player)
	new_thought.entered_player.connect(_on_bad_thought_entered_player)
	add_child(new_thought)
	bad_thoughts.append(new_thought)


func _on_bad_thought_entered_player(thought: BadThought):
	if not room_duration_timer.is_stopped():
		Events.day_ruined.emit()
		stop_room(thought)
