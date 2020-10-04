extends Sprite
export (PackedScene) var destination = null

func _ready():
	pass

func activate():
	$AnimatedSprite.play("default")

func _on_AnimatedSprite_animation_finished():
	if destination:
		get_tree().change_scene_to(destination)


func _on_hitbox_body_entered(body):
	if body is Player:
		match body.mode:
			"record", "initial":
				body.hide()
				activate()
