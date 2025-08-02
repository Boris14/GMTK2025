extends Node2D

signal room_completed(is_successful: bool)

@export var dog_speed := 200.0
@export var bark_cooldown_range := Vector2(2.0, 3.0)
@export var dog_stutter_duration := 0.3

@onready var planet = %Planet
@onready var dog = %Dog as Area2D
@onready var dog_path_follow := %PathFollow2D as PathFollow2D

var bark_cooldown := 0.0
var dog_stutter_timer : Timer
var is_dog_stuttered := false

func _ready():
	if Engine.is_editor_hint():
		return
	dog_stutter_timer = Timer.new()
	dog_stutter_timer.autostart = false
	dog_stutter_timer.one_shot = true
	dog_stutter_timer.timeout.connect(_on_dog_stutter_timer_timeout)
	add_child(dog_stutter_timer)
		
	#planet.visible = false
	dog.visible = false
	dog.input_event.connect(_on_dog_input_event)
	start_room()


func start_room():
	dog.visible = true


func _process(delta):
	if dog.visible and not is_dog_stuttered:
		if dog_path_follow.progress_ratio < 1.0:
			dog_path_follow.progress += delta * dog_speed
			dog.global_position = dog_path_follow.global_position
			_process_bark(delta)


func _on_dog_stutter_timer_timeout():
	is_dog_stuttered = false
	

func _process_bark(delta):
	bark_cooldown -= delta
	if bark_cooldown <= 0:
		GlobalAudio.play_dog_bark()
		bark_cooldown = randf_range(bark_cooldown_range.x, bark_cooldown_range.y)		


func _on_dog_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and not is_dog_stuttered:
		is_dog_stuttered = true
		dog_stutter_timer.start(dog_stutter_duration)
