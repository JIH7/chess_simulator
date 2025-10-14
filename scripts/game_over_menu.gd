extends Node

@onready var text: Label = $Label
var playAgainButton

func _ready() -> void:
	playAgainButton = $PlayAgainButton

func setText(val):
	text.text = val

func _on_play_again_button_pressed():
	SignalBus.newGame()
	get_tree().change_scene_to_file("res://main.tscn")