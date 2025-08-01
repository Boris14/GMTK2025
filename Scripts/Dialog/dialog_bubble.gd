@tool
extends Node2D

@onready var background_sprite := $Background as Sprite2D

@export var emote_sprites : Array[Texture]:
	set(new_emote_sprites):
		emote_sprites = new_emote_sprites
		_on_emote_sprites_changed()


func _on_emote_sprites_changed():
	var i := 0
	var emotes_container = get_node_or_null("Emotes")
	if not is_instance_valid(emotes_container):
		return

	for child in emotes_container.get_children():
		if i >= emote_sprites.size():
			return
	
		if child is Sprite2D and is_instance_valid(emote_sprites[i]):
			child.texture = emote_sprites[i]
			i += 1
			
