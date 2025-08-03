class_name DogChase
extends Node2D

signal room_completed(room: Node2D)

@export var dog_speed := 450.0
@export var bark_cooldown_range := Vector2(2.0, 3.0)
@export var dog_stutter_duration := 0.15
@export var dog_bite_duration := 3.0

@onready var planet = %Planet
@onready var dog = %Dog as Area2D
@onready var dog_path_follow := %PathFollow2D as PathFollow2D
@onready var trigger_area := %TriggerArea as Area2D

var bark_cooldown := 0.0
var dog_stutter_timer : Timer
var dog_bite_timer : Timer
var is_dog_stuttered := false
var player : Player


func _ready():
	if Engine.is_editor_hint():
		return
	planet.queue_free()
	
	trigger_area.area_entered.connect(_on_area_entered_trigger_area)
		
	dog_stutter_timer = Timer.new()
	dog_stutter_timer.autostart = false
	dog_stutter_timer.one_shot = true
	dog_stutter_timer.timeout.connect(_on_dog_stutter_timer_timeout)
	add_child(dog_stutter_timer)
	
	dog_bite_timer = Timer.new()
	dog_bite_timer.autostart = false
	dog_bite_timer.one_shot = true
	dog_bite_timer.timeout.connect(_on_dog_bite_timer_timeout)
	add_child(dog_bite_timer)
	
	dog.visible = false
	dog.input_event.connect(_on_dog_input_event)


func start_room():
	dog.visible = true
	dog.area_entered.connect(_on_area_entered_dog)


func _process(delta):
	if dog.visible and not is_dog_stuttered:
		if dog_path_follow.progress_ratio < 1.0:
			dog_path_follow.progress += delta * dog_speed
			dog.global_position = dog_path_follow.global_position
			_process_bark(delta)
		else:
			is_dog_stuttered = true
			room_completed.emit(self)


func _on_area_entered_dog(area: Area2D):
	if area.owner.is_in_group("Player"):
		bite(area.owner)
		dog.area_entered.disconnect(_on_area_entered_dog)


func bite(in_player: Player):
	player = in_player
	player.play_anim(Player.EPlayerAnimation.FALL)
	dog_bite_timer.start(dog_bite_duration)
	is_dog_stuttered = true


func _on_area_entered_trigger_area(area: Area2D):
	if area.owner.is_in_group("Player"):
		start_room()
		trigger_area.area_entered.disconnect(_on_area_entered_trigger_area)


func _on_dog_bite_timer_timeout():
	player.play_anim(Player.EPlayerAnimation.WALK)
	room_completed.emit(self)


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
