@tool
extends Node2D

@export var flip:bool : set = _set_direction
var projectile = load("res://Fixing everything/fixing_ammo.tscn")

func _ready():
	pass # Replace with function body.

func _set_direction(_nothing):
	scale.x *= -1

func spawn():
	var new = projectile.instantiate()
	add_child(new)
	pass

func _on_spawn_timer_timeout():
	spawn()
