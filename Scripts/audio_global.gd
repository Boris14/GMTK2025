class_name AudioGlobal
extends Node

@onready var dog_bark : AudioStreamPlayer = $DogBarkPlayer
@onready var correct_answer : AudioStreamPlayer = $CorrectAnswerPlayer
@onready var wrong_answer : AudioStreamPlayer = $WrongAnswerPlayer

func play_dog_bark():
	dog_bark.play()

func play_correct_answer():
	correct_answer.play()
	
func play_wrong_answer():
	wrong_answer.play()

func _play_sound(player: AudioStreamPlayer, sound: AudioStream):
	if not is_instance_valid(player) or not is_instance_valid(sound):
		print("Invalid play sound")
		return
	player.stream = sound
	player.play()
