extends KinematicBody2D
class_name Player, "res://Player2.png"

var inputVector
export var speed = 400
var mode = "initial"
var recordingPositions = []
var recordingTimes = []
var time = 0
var playbackCursor = 0
export var creation_order = 0 # increment when creating new players

func _ready():
	pass

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
		"playback":
			time += delta
			if recordingTimes.size() > playbackCursor:
				while recordingTimes[playbackCursor] < time:
					playbackCursor += 1
					if playbackCursor >= recordingTimes.size():
						playbackCursor = 0
						time = 0
						break
				position = recordingPositions[playbackCursor]

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

func movement(delta):
	inputVector = Vector2(0,0)
	if Input.is_action_pressed("right"): inputVector += Vector2(1,0)
	if Input.is_action_pressed("left"): inputVector += Vector2(-1,0)
	if Input.is_action_pressed("up"): inputVector += Vector2(0,-1)
	if Input.is_action_pressed("down"): inputVector += Vector2(0,1)
	if Input.is_action_pressed("ui_select"):
		mode = "playback"
		time = 0 
	
	move_and_collide(inputVector * speed * delta)
