class_name Garbage
extends Area2D

@export var speed := 700.0
@export var gravity_force := 1000.0
@export var bounce_impulse := -400.0
@export var max_fall_speed := 1200.0

var path_follow: PathFollow2D
var has_bounced := false
var vertical_velocity := 0.0
var horizontal_velocity := 0.0


func _ready():
	area_entered.connect(_on_area_entered_area)


func start(in_path_follow: PathFollow2D):
	path_follow = in_path_follow
	path_follow.progress_ratio = 0.0
	has_bounced = false
	vertical_velocity = 0.0


func _physics_process(delta):
	if is_queued_for_deletion():
		return
	if not has_bounced and path_follow:
		if path_follow.progress_ratio < 1.0:
			# Move along the path
			path_follow.progress += delta * speed
			global_position = path_follow.global_position
			rotation = path_follow.rotation
		else:
			queue_free()
	elif has_bounced:
		# Apply gravity after bounce
		vertical_velocity += gravity_force * delta
		vertical_velocity = min(vertical_velocity, max_fall_speed)
		
		# Simple motion with bounce (just falling downward)
		position.y += vertical_velocity * delta
		position.x += horizontal_velocity * delta  # Optional: keep horizontal movement

func bounce():
	if has_bounced:
		return
	has_bounced = true
	horizontal_velocity = speed * cos(rotation)
	vertical_velocity = bounce_impulse
	path_follow = null
	await get_tree().create_timer(2.0).timeout
	z_as_relative = false


func _on_area_entered_area(area: Area2D):
	if has_bounced:
		return

	if area and area.owner and area.owner.is_in_group("Player"):
		Events.day_ruined.emit()
		bounce()


func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		bounce()
