extends CanvasLayer
class_name MainMenu

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("menu_drops")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_options_btn_pressed() -> void:
	pass # Replace with function body.


func _on_start_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")
	pass # Replace with function body.


func _on_start_btn_2_pressed() -> void:
	pass # Replace with function body.


func _on_exit_btn_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
