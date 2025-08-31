class_name AudioGlobal
extends Node

# Looping
@onready var ambient_day : AudioStreamPlayer = $AmbientDay
@onready var ambient_night : AudioStreamPlayer = $AmbientNight
@onready var teacher_talking : AudioStreamPlayer = $TeacherTalking

# One-Shot
@onready var dog_bark : AudioStreamPlayer = $DogBarkPlayer
@onready var correct_answer : AudioStreamPlayer = $CorrectAnswerPlayer
@onready var wrong_answer : AudioStreamPlayer = $WrongAnswerPlayer
@onready var car_drive : AudioStreamPlayer = $CarDriveBy

func play_dog_bark():
	dog_bark.play()

func set_is_teacher_talking_active(is_active: bool):
	if is_active:
		teacher_talking.play()
	else:
		teacher_talking.stop()

func play_correct_answer():
	correct_answer.play()
	
func play_wrong_answer():
	wrong_answer.play()
	
func play_car_drive():
	car_drive.play()
	
func play_ambient(is_day : bool):
	if is_day:
		ambient_night.stop()
		ambient_day.play()
	else:
		ambient_day.stop()
		ambient_night.play()

func _play_sound(player: AudioStreamPlayer, sound: AudioStream):
	if not is_instance_valid(player) or not is_instance_valid(sound):
		print("Invalid play sound")
		return
	player.stream = sound
	player.play()
