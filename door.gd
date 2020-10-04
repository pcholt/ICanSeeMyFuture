extends Node2D

func _ready():
	pass

func open():
	$AnimationPlayer.play("open")
	
func close():
	$AnimationPlayer.play_backwards("open")
