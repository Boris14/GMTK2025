extends CanvasLayer


@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func change_scene(target : String) -> void:
	animation_player.play("fade_out")
	await get_tree().create_timer(0.6).timeout
	get_tree().change_scene_to_file(target)
