class_name Classroom
extends Node2D

signal room_completed(room: Node2D)

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
@export var post_room_delay := 1.0

@onready var question_bubble := %QuestionBubble as DialogBubble
@onready var answer_bubbles : Array[DialogBubble] = [%AnswerBubble1, %AnswerBubble2, %AnswerBubble3]
@onready var trigger_area := %TriggerArea as Area2D

var question_timer : Timer
var current_question_index := 0
var correct_answer_count := 0
var player : Player 

func start_room(in_player: Player):
	player = in_player
	player.play_anim("Sit")
	await get_tree().create_timer(player.get_current_anim_length() + 1.0).timeout
	start(current_question_index)

func _ready():
	if Engine.is_editor_hint():
		return
	
	trigger_area.area_entered.connect(_on_area_entered_trigger_area)
	
	%Planet.queue_free()
	for ans in answer_bubbles:
		ans.clicked.connect(_on_answer_clicked)
	question_timer = Timer.new()
	question_timer.one_shot = true
	question_timer.autostart = false
	question_timer.timeout.connect(_on_question_timer_timeout)
	add_child(question_timer)
	set_is_question_visible(false)


func _on_area_entered_trigger_area(area: Area2D):
	if area.owner.is_in_group("Player"):
		start_room(area.owner as Player)
		trigger_area.area_entered.disconnect(_on_area_entered_trigger_area)


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
		if correct_answer_count < questions_answers.size():
			Events.day_ruined.emit()
		await get_tree().create_timer(post_room_delay).timeout
		player.play_anim("Walk")
		room_completed.emit(self)
	else:
		await get_tree().create_timer(between_questions_time).timeout
		start(current_question_index)


func set_is_question_visible(is_visible: bool):
	question_bubble.visible = is_visible
	for ans in answer_bubbles:
		ans.visible = is_visible
