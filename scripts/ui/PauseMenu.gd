extends Control

var is_paused = false setget set_paused

func _ready():
	set_paused(false)

func _unhandled_input(event):
	if(event.is_action_pressed("ui_end") && Global.ableToPause):
		self.is_paused = !is_paused

func set_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused

func _on_QuitButton_pressed():
	set_paused(false)
	SceneTransition.change_scene("res://scenes/ui/MainMenu.tscn")

func _on_ResumeButton_pressed():
	set_paused(false)
