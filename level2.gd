extends Node3D


@onready var camera := %Camera3D as Camera3D


# Called when the node enters the scene tree for the first time.
func _ready():
	# cam setup
	camera.position = %Player.position + Vector3(5, 2, 5)
	camera.look_at(%Player.position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
