extends Area2D

onready var player = preload("res://Player.tscn")

func _ready():
	pass

func _on_Teleporter_body_entered(body):
	if body is Player:
		match body.mode:
			_ :
				pass
	$AnimationPlayer.play("Idle")

func _on_Teleporter_body_exited(body):
	if body is Player:
		match body.mode:
			"playback":
				pass
			"initial":
				body.time = 0
				body.playbackCursor = 0
				body.mode = "record" 
				if body.original_teleporter:
					body.original_teleporter.play("activate")
			_ :
				body.time = 0
				body.playbackCursor = 0
				body.mode = "playback"
				body.camera.current = false
				if body.original_teleporter:
					body.original_teleporter.play("activate")
				
				var newBody = player.instance()
				newBody.mode = "record"
				newBody.time = 0
				newBody.playbackCursor = 0
				newBody.position = body.position
				get_parent().add_child(newBody)
				newBody.creation_order = body.creation_order + 1
				newBody.original_teleporter = $AnimationPlayer
				
	$AnimationPlayer.play("activate")
