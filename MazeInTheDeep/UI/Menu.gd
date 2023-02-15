extends Control

onready var select = $AudioStreamPlayer2

func _ready():
	$VBoxContainer/StartButton.grab_focus()

func _on_StartButton_button_up():
	select.play()
	yield(select, "finished")
	get_tree().change_scene("res://Levels/Test Level.tscn")

func _on_QuitButton_button_up():
	select.play()
	yield(select, "finished")
	get_tree().quit()
