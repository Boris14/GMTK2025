extends Node2D
class_name DayNight

@export var rotation_speed : float

@onready var day_night: Node2D = $"."
@onready var main_scene: Main = $".."

@onready var day_night_animation_player: AnimationPlayer = $DayNightAnimationPlayer

#@export var

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if sun.is_on_sc
	rotate(deg_to_rad(rotation_speed * delta * 60))
	#print(rotation)
	pass


func _on_moon_visible_on_screen_notifier_2d_screen_entered() -> void:
	day_night_animation_player.play("to_night")
	print("MOON ENTERED")
	pass # Replace with function body.


func _on_sun_visible_on_screen_notifier_2d_screen_entered() -> void:
	day_night_animation_player.play("to_day")
	print("SuN ENTERED")
	
	pass # Replace with function body.
