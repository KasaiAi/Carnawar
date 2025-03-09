extends CharacterBase

func _ready():
	speed = 200
	max_load = 1
	
	direction = Vector2.RIGHT

enum{GET_AMMO, LOAD_CANNON, PURSUE, INVADE}

#func _physics_process(_delta):
#	if move():
#		direction = direction * -1 # Temporary setup to flip enemy direction

func _on_test_timeout():
	if not occupied:
		attack_method()
#		print("ordem enviada, aguardando...")

func move_to(target):
	pass

func attack_method():
	if grab():
		await get_tree().create_timer(1).timeout
	if grabbed_items.is_empty():
		Animator.play("charging up")
		await Animator.animation_finished
		if att_ready:
			attack()
	else:
		throw()
	await Animator.animation_finished
	$Test.start()

func _idle_check():
	if Animator.current_animation == "idle":
		attack_method()
#	else:
#		print("all good")
#		print(Animator.current_animation)
