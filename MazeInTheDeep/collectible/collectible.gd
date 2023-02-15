extends StaticBody2D

signal add_time
onready var select = $AudioStreamPlayer

func _on_Area2D_area_entered(area):
	emit_signal("add_time")
	$AnimationPlayer.play("pickedup")
