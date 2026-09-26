extends CharacterBase

@export var Wall: Node2D
var dashing = false

@export var SUCC : Node

func _ready():
	speed = 300
	max_load = 3

func _physics_process(_delta):
	# Character controller
	direction = Input.get_vector("left", "right", "up", "down")
#	dash() # debug
	if direction:
		last_direction = direction
	if not occupied:
		move()

func dash(): # debug
	if dashing:
		if is_on_wall():
			last_direction = last_direction * -1
		direction = last_direction
		speed -= 20
		if speed <= 0:
			dashing = false
			speed = 300

func _input(_event):
	if Input.is_action_just_pressed("action"):
		# Cheat de puxar item pra a mão
		if Pickup.get_overlapping_bodies().is_empty():
			SUCC.thrown = false
			SUCC.bouncing = false
			SUCC.speed = 0
			SUCC.position = position
		if not grabbed_items.is_empty():
	#		var item = grabbed_items[0]
			var item = grabbed_items.pop_front()
			$GrabbedItems.get_children()[0].remote_path = ""
			item.launch(position, last_direction.normalized(), enemy_group)
#			print(grabbed_items, $GrabbedItems/"1".remote_path)
#			print()
		elif grabbed_items.size() < max_load:
			for i in Pickup.get_overlapping_bodies():
				if i.is_in_group("ammo"):
					grabbed_items.append(i)
			for item in grabbed_items.size():
				grabbed_items[item].linear_velocity = Vector2.ZERO
			#			grabbed_items[item].freeze = true
				$GrabbedItems.get_children()[item].remote_path = grabbed_items[item].get_path()
#				print(grabbed_items[item].name, " in slot ", $GrabbedItems.get_children()[item].name)
#			print()

func take():
	for i in Pickup.get_overlapping_bodies():
		if i.is_in_group("ammo"):
			grabbed_items.append(i)
	for item in grabbed_items.size():
		grabbed_items[item].linear_velocity = Vector2.ZERO
	#			grabbed_items[item].freeze = true
		$GrabbedItems.get_children()[item].remote_path = grabbed_items[item].get_path()
		print(grabbed_items[item].name, " in slot ", $GrabbedItems.get_children()[item].name)
	print()

#	if Input.is_action_just_released("action") and grabbed_items.is_empty():
#		SUCC.position = position
#		$GrabbedItems/"1".remote_path = SUCC.get_path()
#
#	if knockback == false:
#		if Input.is_action_just_pressed("action"):
#			Animator.play("charging up")
#		elif Input.is_action_just_released("action"):
#			if att_ready:
#				attack()
#			else:
#				if Animator.current_animation == "charging up":
#					Animator.play("idle")
#					occupied = false
#			grab()
#		if Input.is_action_just_pressed("throw"):
#			throw()
#		if not occupied and event is InputEventMouseButton and not grabbed_items.is_empty():
#			if Input.is_action_just_pressed("cycle_left"):
#				grabbed_items.append(grabbed_items.pop_front())
##				print()
#			if Input.is_action_just_pressed("cycle_right"):
#				grabbed_items.insert(0, grabbed_items.pop_back())
#			reorder()
