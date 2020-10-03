extends KinematicBody2D
class_name Player, "res://Player2.png"

var inputVector
export var speed = 200
var mode = "initial"
var recordingPositions = []
var recordingTimes = []
var time = 0
var agitation = 0
var playbackCursor = 0
export var creation_order = 0 # increment when creating new players
onready var explode = preload("res://Explode.tscn")
var original_teleporter 

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
						if original_teleporter:
							original_teleporter.play("activate")
						break
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
