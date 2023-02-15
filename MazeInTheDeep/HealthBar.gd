extends Control

onready var label = $Panel/Label
var time_left = 0
var seconds = 0

func _ready():
	$Timer.start()

func _process(_delta):
	get_minutes_and_seconds()
	label.text = String(seconds) + "%"

func get_minutes_and_seconds():
	time_left = round($Timer.get_time_left())
	seconds = int(time_left)

func _on_Timer_timeout():
	get_tree().reload_current_scene()
	get_tree().reload_current_scene()

func _on_add_time():
	var bonus_time := 0
	var actual_time = round($Timer.get_time_left())
	bonus_time = actual_time + 15
	if (bonus_time >= 100):
		bonus_time = 100
	$Timer.set_wait_time(bonus_time)
	$Timer.start()
