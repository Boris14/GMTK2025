extends CanvasLayer
class_name MainMenu

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween1 = get_tree().create_tween()
	var tween2 = get_tree().create_tween()
	var tween3 = get_tree().create_tween()
	var tween4 = get_tree().create_tween()
	
	tween1.tween_property($OptionsBtn,"position",Vector2(0,150),2)
	tween2.tween_property($StartBtn,"position",Vector2(200,150),2)
	tween3.tween_property($StartBtn2,"position",Vector2(300,150),2)
	tween4.tween_property($ExitBtn,"position",Vector2(400,150),2)
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
