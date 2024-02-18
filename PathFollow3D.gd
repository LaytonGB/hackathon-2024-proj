extends PathFollow3D


var move_time := 3.0
@onready var timer := %Timer as Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	timer.one_shot = true


func _input(event):
	if timer.is_stopped():
		if event.is_action_pressed("jump"):
			if progress_ratio == 0.0:
				timer.start(move_time)
			else:
				if OS.has_feature("web"):
					JavaScriptBridge.eval("""
						document.open();
						document.write('<h1>Success</h1>');
						document.close();
					""")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !timer.is_stopped():
		progress_ratio = (move_time - timer.time_left) / move_time
