extends CharacterBody2D
class_name CharacterBase

@onready var Animator = $AnimationPlayer
@onready var world = get_parent()

@export var occupied = false
@export var charging = false
@export var throwing = false
@export var att_ready = false
@export var knockback = false
var hitpoints = 3
var speed: int
var direction = Vector2.RIGHT
var last_direction = direction
var grabbed_items = []
var max_load: int
@export var enemy_group: String

var test

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func move():
	if direction:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO

	if not occupied:
		return move_and_slide()

func grab():
	if not occupied and grabbed_items.size() < max_load:
		var closest = {"object": null, "distance": 150}
		for item in $Pickup.get_overlapping_bodies():
			if item.is_in_group("ammo") and item.position.distance_to(position) < closest["distance"]:
				closest["object"] = item
				closest["distance"] = item.position.distance_to(position)
		if closest["object"] != null:
			if closest["object"].tween:
				closest["object"].tween.kill()
				closest["object"].bounce()
			grabbed_items.append(closest["object"])
			closest["object"].Animator.play("held")
			closest["object"].reparent($GrabbedItems)
			reorder()
			return true

func reorder():
	for item in grabbed_items:
		if item != null:
#			create_tween().tween_property(item, "position", Vector2(0, grabbed_items.find(item) * -50), 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			item.position = Vector2(0, grabbed_items.find(item) * -50)

func throw():
	# BUG: Por algum motivo os itens jogados somem (spawnam na origem da cena) se jogados muito rápido
	# Provavelmente é culpa do tween
	if not occupied:
		Animator.play("throwing")
		if not grabbed_items.is_empty():
			var item = grabbed_items.pop_front()
			item.damaging = true
			item.reparent(world)
			item.launch(position, last_direction, enemy_group, true)
			reorder()

		# Itens infinitos para debug
		else:
			var item = load("res://Objects/ammo.tscn").instantiate()
			item.position = position
			item.damaging = true
			world.add_child(item)
			item.launch(position, last_direction, enemy_group, true)

func attack():
	Animator.play("attacking")
	create_tween().tween_property(self, "position", last_direction * 500, 0.5).as_relative().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func take_damage(knockback_direction):
	print(enemy_group + " hit " + str(self.get_groups()[0]))
	hitpoints -= 1
	for i in grabbed_items.size():
		var item = grabbed_items.pop_front()
		item.reparent(world)
		item.launch(position, randv().normalized(), "neutral", false)
	att_ready = false
	Animator.stop(true)
	Animator.clear_queue()
	Animator.play("knockback")
	create_tween().tween_property(self, "position", knockback_direction * 150, 1.4).as_relative()
	Animator.queue("idle")

func _reactivate(item):
	item.get_node("Collision").disabled = false

func randv():
	var vector = Vector2.ZERO
	while vector.length() == 0:
		vector = Vector2(randi_range(-1, 1), randi_range(-1, 1))
	return vector
