extends Area2D

export( String, "momentary", "toggle", "on", "off") var pressAnimation = "momentary"
export (bool) var on = false
onready var door = $door
onready var line = $link

func _ready():
	if on:
		$trigger2.frame = 1
	else:
		$trigger2.frame = 0
	set_line_color()
	

func _on_Area2D_body_entered(body):
	if body is Player:
		match body.mode:
			"initial":
				buttonPressAction()
			"record":
				body._on_buttonPress(self)
				buttonPressAction()

# Called from external Player to perform actions while replaying recorded button presses.
func buttonPressAction():
	var animation = $AnimationPlayer
	match pressAnimation:
		"toggle":
			if on: 
				animation.queue("off")
			else:
				animation.queue("on")
		_:
			animation.queue(pressAnimation)

	
func set_line_color():
	if line:
		if on:
			line.default_color = Color.yellow
		else:
			line.default_color = Color.red
	if door:
		if on:
			door.open()
		else:
			door.close()
		
func _on_AnimationPlayer_animation_started(anim_name):
	match anim_name:
		"momentary", "on": on = true
		"off": on = false
	set_line_color()

func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"momentary": on = false
	set_line_color()
