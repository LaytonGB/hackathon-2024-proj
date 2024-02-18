extends CharacterBody3D


const HEIGHT := 4.0
const WIDTH := 2.0

var move_position_start: Vector3
var move_position_end: Vector3
var move_rotation_start: Vector3
var move_rotation_end: Vector3
@export var move_time := 0.5
var move_factor := 1 / move_time
@onready var move_timer := %MoveTimer

var fix_timer: Timer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var clicks_counter := 0

func _ready():
	move_timer.one_shot = true


func reset_position():
	print("RESET")
	position = Vector3(1, 11, 1)


func _input(event):
	if move_timer.is_stopped():
		if event.is_action_pressed("ui_right") or event.is_action_pressed("jump") and clicks_counter in [0, 1, 5, 6, 7]:
			clicks_counter += 1
			move_timer.start(move_time)
			move_position_start = position
			move_position_end = position - Vector3(0, 0, -(HEIGHT + WIDTH) / 2)
			move_rotation_start = rotation
			move_rotation_end = rotation + Vector3(PI / 2, 0, 0)
		elif event.is_action_pressed("ui_up") or event.is_action_pressed("jump") and clicks_counter in [2, 3, 4]:
			clicks_counter += 1
			move_timer.start(move_time)
			move_position_start = position
			move_position_end = position - Vector3(-(HEIGHT + WIDTH) / 2, 0, 0)
			move_rotation_start = rotation
			move_rotation_end = rotation + Vector3(0, 0, PI / 2)
		elif event.is_action_pressed("trigger_js") or event.is_action_pressed("jump") and clicks_counter in [8]:
			clicks_counter += 1
			if OS.has_feature("web"):
				JavaScriptBridge.eval("""
					window.open("https://www.google.com", "_blank").focus();
				""")


func _physics_process(delta):
	print(position)
	
	# adjust position and rotation while moving
	if !move_timer.is_stopped():
		var weight: float = (move_time - move_timer.time_left) * move_factor
		position = move_position_start.lerp(move_position_end, weight)
		rotation = move_rotation_start.lerp(move_rotation_end, weight)
	
	# apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()


func _on_move_timer_timeout():
	position = move_position_end
	rotation = move_rotation_end
