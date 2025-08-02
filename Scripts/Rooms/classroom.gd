#@tool
extends Node2D

signal room_completed(is_successful: bool)

## Used to populate questions_answers
#@export var placeholder_texture : Texture:
#	set(new_texture):
#		if placeholder_texture == new_texture:
#			return
#		placeholder_texture = new_texture
#		questions_answers.clear()
#		for i in range(3):
#			var entry : Array[Texture]
#			for j in range(4):
#				entry.append(placeholder_texture)
#			questions_answers.append(entry)

@export var questions_answers : Array[Array]
@export var correct_answers := [0, 1, 1]

@export var question_time := 6.0
@export var between_questions_time := 2.0

@onready var question_bubble := %QuestionBubble as DialogBubble
@onready var answer_bubbles : Array[DialogBubble] = [%AnswerBubble1, %AnswerBubble2, %AnswerBubble3]

var question_timer : Timer
var current_question_index := 0
var correct_answer_count := 0

func start_room():
	start(current_question_index)

func _ready():
	if Engine.is_editor_hint():
		return
	#%Planet.visible = false
	for ans in answer_bubbles:
		ans.clicked.connect(_on_answer_clicked)
	question_timer = Timer.new()
	question_timer.one_shot = true
	question_timer.autostart = false
	question_timer.timeout.connect(_on_question_timer_timeout)
	add_child(question_timer)
	set_is_question_visible(false)
	start_room()


func start(question_index: int):
	if question_index >= questions_answers.size():
		return
	for i in range(questions_answers[question_index].size() - 1):
		answer_bubbles[i].dialog_texture = questions_answers[question_index][i]
	question_bubble.dialog_texture = questions_answers[question_index][answer_bubbles.size()]
	set_is_question_visible(true)
	question_timer.start(question_time)


func _on_answer_clicked(ans: DialogBubble):
	var ans_index := answer_bubbles.find(ans)
	if correct_answers[current_question_index] == ans_index:
		correct_answer_count += 1
		GlobalAudio.play_correct_answer()
	else:
		GlobalAudio.play_wrong_answer()
	_on_question_timer_timeout(true)


func _on_question_timer_timeout(has_answered := false):
	if has_answered:
		question_timer.stop()
	else:
		GlobalAudio.play_wrong_answer()
	set_is_question_visible(false)
	current_question_index += 1
	if current_question_index >= questions_answers.size():
		room_completed.emit(correct_answer_count == questions_answers.size())
	else:
		await get_tree().create_timer(between_questions_time).timeout
		start(current_question_index)


func set_is_question_visible(is_visible: bool):
	question_bubble.visible = is_visible
	for ans in answer_bubbles:
		ans.visible = is_visible
