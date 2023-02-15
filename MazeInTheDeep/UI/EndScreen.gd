extends Control

onready var select = $AudioStreamPlayer2

func _ready():
	$VBoxContainer/GoToMainMenu.grab_focus()

func _on_GoToMainMenu_button_up():
	select.play()
	yield(select, "finished")
	get_tree().change_scene("res://UI/Menu.tscn")

func _on_Quit_button_up():
	select.play()
	yield(select, "finished")
	get_tree().quit()
