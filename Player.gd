extends KinematicBody2D
class_name Player, "res://Player2.png"

var inputVector
export var speed = 10
var mode = "initial"
var recordingPositions = []
var recordingTimes = []
var record = []
var time = 0
var agitation = 0
var playbackCursor = 0
export var creation_order = 0 # increment when creating new players
onready var explode = preload("res://Explode.tscn")
var original_teleporter 
onready var camera = $camera
var button_pressed

func _ready():
	pass
	
func hide():
	$AnimatedSprite.visible = false

func remove_animations():
	$AnimatedSprite.stop()

func _process(delta):
	match mode:
		"insideTeleporter":
			movement(delta)
		"initial":
			movement(delta)
		"record":
			time += delta
			movement(delta)
			recordingPositions.append(position)
			recordingTimes.append(time)
			record.append(
				{
					position = position,
					time = time,
					button_pressed = button_pressed,
					frame = $AnimatedSprite.frame,
					flip_h = $AnimatedSprite.flip_h
				}
			)
			button_pressed = null
		"playback":
			time += delta
			if recordingTimes.size() > playbackCursor:
				while recordingTimes[playbackCursor] < time:
					playbackCursor += 1
					if playbackCursor >= recordingTimes.size():
						playbackCursor = 0
						time = 0
						if original_teleporter:
							original_teleporter.play("activate")
						break
					var press = record[playbackCursor].button_pressed
					if press:
						press.buttonPressAction()
					$AnimatedSprite.frame = record[playbackCursor].frame
					$AnimatedSprite.flip_h = record[playbackCursor].flip_h
				var offset = Vector2()
				if agitation > 0:
					offset = Vector2(rand_range(-agitation*20, agitation*20), rand_range(-agitation*20, agitation*20))
				position = recordingPositions[playbackCursor] + offset
					

	# Search for all other visible `players`
	var space_state = get_world_2d().direct_space_state
	
	var see = false
	for child in get_parent().get_children():
		var child_order = child.get("creation_order")
		if child_order != null:
			if child_order > creation_order: # panic if we see something in our future
				var intersection = space_state.intersect_ray(position, child.position, [self, child])
				if !intersection:
					see = true
	
	$exclamation.visible = see
	if see:
		agitation += delta
		if agitation > 1:
			var explosion = explode.instance()
			get_parent().add_child(explosion)
			explosion.position = position
			queue_free()
	else:
		if agitation>0:
			agitation -= delta
		

var velocity = Vector2()
var gravity = 300

func _on_buttonPress(trigger):
	button_pressed = trigger

func movement(delta):
	var jump
	inputVector = Vector2(0,0)
	if Input.is_action_pressed("right"): 
		inputVector += Vector2(1,0)
		$AnimatedSprite.play("run")
		$AnimatedSprite.flip_h = false
	if Input.is_action_pressed("left"):
		inputVector += Vector2(-1,0)
		$AnimatedSprite.play("run")
		$AnimatedSprite.flip_h = true
	if Input.is_action_pressed("up") and is_on_floor(): 
		jump = true
	if Input.is_action_pressed("restart"):
		get_tree().reload_current_scene()

	if jump:
		velocity.y = -250
		$AnimatedSprite.play("jump")
	else:
		if inputVector.length_squared()<.1:
			$AnimatedSprite.play("idle")
		velocity.x = inputVector.x * speed * 10
	
func _physics_process(delta):
	if mode != "playback":
		velocity.y += gravity * delta
		velocity = move_and_slide(velocity, Vector2(0,-1), true)
		
	
		

	
