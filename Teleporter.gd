extends Area2D

onready var player = preload("res://Player.tscn")

func _ready():
	pass

func _on_Teleporter_body_entered(body):
	$Indicator.visible = true

func _on_Teleporter_body_exited(body):
	if body is Player:
		match body.mode:
			"playback":
				pass
			"initial":
				body.time = 0
				body.playbackCursor = 0
				body.mode = "record"
			_ :
				body.time = 0
				body.playbackCursor = 0
				body.mode = "playback"
				
				var newBody = player.instance()
				newBody.mode = "record"
				newBody.time = 0
				newBody.playbackCursor = 0
				newBody.position = body.position
				get_parent().add_child(newBody)
				newBody.creation_order = body.creation_order + 1
				
	$Indicator.visible = false

