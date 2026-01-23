extends RigidBody2D

var enemy_group: String = "neutral"

@onready var Animator = $AnimationPlayer
@onready var collision = $Hitbox

@export var thrown = false # thrown, damaging projectile
@export var bouncing = false # catchable
@export var grabbed = false
var direction: Vector2

# Variables that work
var speed
var launch_point: Vector2

var launch_speed = 8 # default: Vector2(10, -10)
var gravity = .3
var bounce
var z_pos = -6

var normal

#func _ready():
#	launch_point = global_position

func _process(_delta):
	if thrown or bouncing:
		position += direction * speed
		collision.position.y += z_pos
		z_pos += gravity
		process_animation()

# Colocar toda essa função numa animação e controlar os valores por lá
func process_animation():
	if collision.position.y >= -22:
		collision.position.y = -22
		z_pos = -z_pos
		speed = speed/2
		# On first landing switches off damage property
		if thrown:
			enemy_group = "neutral"
			thrown = false
			bouncing = true
		# Calculates movement and bounce
		elif bouncing:
			bounce -= 1
			z_pos = z_pos/1.5
			# Resets state if stationary
			if bounce <= 0:
				bouncing = false

# Launch é melhor como um método de CharacterBase, setando as condições e valores do projétil antes de lançar
func launch(dir:Vector2, team:String = "neutral"):
	direction = dir
	enemy_group = team
	
	apply_impulse(direction * 400)

func _on_collide(body):
	if body.is_in_group("wall"):
		var normal = round((global_position - body.global_position).normalized())
		if $Raycast/L.is_colliding() or $Raycast/R.is_colliding():
			direction.x *= -1
		if $Raycast/U.is_colliding() or $Raycast/D.is_colliding():
			direction.y *= -1
	
#	if not $Damaging.disabled:
#		if body.is_in_group("ammo"):
#			body.Animator.play("bump")
#			body.create_tween().tween_property(body, "position", direction * 130, 0.6).as_relative()
#		if body.is_in_group(enemy_group) and body.get_node("Attack"):
#			body.take_damage(direction)
#		if $Damaging.disabled:
#			position += Vector2(20, 20) * sign(throw_distance) * -1
#		else:
#			var rebound = round(launch_point.distance_to(position)	)
#			rebound = throw_distance - (Vector2(rebound, rebound) * sign(throw_distance))
#			#print(rebound)
#			tween = create_tween()
#			tween.tween_property(self, "position", rebound * -1, 1).as_relative()
