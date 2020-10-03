extends Node2D

onready var time = 0

func _ready():
	pass

func _process(delta):
	time += delta
	scale = Vector2(1.0 + time*10, 1.0+time*10)
	$exclamation.modulate = Color(255,255,255,1-time)
	
	if time>1: 
		queue_free()
