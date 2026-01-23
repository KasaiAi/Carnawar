extends CharacterBase

func _ready():
	speed = 300
	max_load = 3

func _physics_process(_delta):
	# Character controller
	direction = Input.get_vector("left", "right", "up", "down")
	if direction:
		last_direction = direction
	move()

func _input(event):
	if knockback == false:
		if Input.is_action_just_pressed("action"):
			Animator.play("charging up")
		elif Input.is_action_just_released("action"):
			if att_ready:
				attack()
			else:
				if Animator.current_animation == "charging up":
					Animator.play("idle")
					occupied = false
			grab()
		if Input.is_action_just_pressed("throw"):
			throw()
		if not occupied and event is InputEventMouseButton and not grabbed_items.is_empty():
			if Input.is_action_just_pressed("cycle_left"):
				grabbed_items.append(grabbed_items.pop_front())
#				print()
			if Input.is_action_just_pressed("cycle_right"):
				grabbed_items.insert(0, grabbed_items.pop_back())
			reorder()
