extends Node2D

var test

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(_event):
	if Input.is_action_just_pressed("action") or Input.is_action_just_pressed("cycle_left"):
		test = load("res://Objects/ammo.tscn").instantiate()
		add_child(test)
		var target = Input.get_vector("left", "right", "up", "down")
		test.damaging = true
		test.launch(Vector2(640,360), target)
