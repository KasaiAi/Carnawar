extends RigidBody2D

@export var hits: int = 1
@export var damage: int = 30
var enemy_group: String = "neutral"

@onready var Animator = $AnimationPlayer

@export var damaging = false
var throw_distance = Vector2.ZERO
var launch_point: Vector2
var direction: Vector2
var tween

#func _ready():
#	launch_point = global_position

#func _process(_delta):
#	print(position)

func launch(from, towards, team, starts_colliding):
	Animator.play("thrown")
	$Collision.disabled = !starts_colliding
	launch_point = from
	position = from
	direction = towards
	enemy_group = team
	throw_distance = direction * 390
#	create_tween().tween_property(self, "position", throw_distance, 0.6).as_relative()
	tween = create_tween()
	tween.tween_property(self, "position", throw_distance, 0.6).as_relative()
	tween.tween_property(self, "position", throw_distance/3, 0.6).as_relative()
	tween.tween_property(self, "position", throw_distance/6, 0.4).as_relative()

func bounce():
#	throw_distance = throw_distance/2
#	if enemy_group == "":
#		create_tween().tween_property(self, "position", throw_distance, 0.4).as_relative()
#	else:
#		create_tween().tween_property(self, "position", throw_distance, 0.6).as_relative()
	enemy_group = "neutral"

# Pra um lançamento independente de animação
#func arc( direction, distance, height, time):
#	var tween = create_tween()
#	tween.tween_property(self, "position:x", direction * distance, time).as_relative()
#	tween.parallel().tween_property(self, "position:y", -height, time/2).as_relative().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
#	tween.tween_property(self, "position:y", height, time/2).as_relative().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func _on_collide(body):
	if damaging:
		if body.is_in_group("ammo"):
			body.Animator.play("bump")
			for i in body.get_colliding_bodies():
				if i.name == "Wall":
					direction = -direction
					
			body.create_tween().tween_property(body, "position", direction * 130, 0.6).as_relative()
		elif body.is_in_group(enemy_group):
			body.take_damage(direction)
	if body.name == "Wall":
		if not damaging:
			if tween:
				tween.kill()
		else:
			var rebound = round(launch_point.distance_to(position))
			rebound = throw_distance - (Vector2(rebound, rebound) * sign(throw_distance))
			tween.kill()
			tween = create_tween()
			tween.tween_property(self, "position", rebound * -1, 1).as_relative()

func _on_entered(_area):
#	print("I'm in")
	pass
