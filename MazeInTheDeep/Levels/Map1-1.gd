extends Node2D


func _on_WinPoint_area_entered(area):
	#win.play()
	#yield(win, "finished")
	get_tree().change_scene("res://Levels/Map2-1.tscn")
